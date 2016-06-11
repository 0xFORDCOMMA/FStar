﻿(*
   Copyright 2008-2014 Nikhil Swamy and Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)
#light "off"

module FStar.SMTEncoding.ErrorReporting
open FStar
open FStar.Util
open FStar.SMTEncoding.Term
open FStar.SMTEncoding

type label = error_label
type labels = error_labels
let sort_labels (l:labels) = List.sortWith (fun (_, _, r1) (_, _, r2) -> Range.compare r1 r2) l
let remove_dups (l:labels) = Util.remove_dups (fun (_, m1, r1) (_, m2, r2) -> r1=r2 && m1=m2) l
type msg = string * Range.range
type ranges = list<(option<string> * Range.range)>

let fresh_label : ranges -> term -> labels -> term * labels =
    let ctr = ref 0 in 
    fun rs t labs -> 
        let l = incr ctr; format1 "label_%s" (string_of_int !ctr) in
        let lvar = l, Bool_sort in
        let message, range = match rs with 
            | [] -> t.hash, Range.dummyRange
            | (Some reason, r)::_ -> reason, r
            | (None, r)::_ -> "failed to prove a pre-condition", r in
        let label = (lvar, message, range) in
        let lterm = Term.mkFreeV lvar in
        let lt = Term.mkOr(lterm, t) in
        lt, label::labs

(*
   label_goals query : term * labels
      traverses the query, finding sub-formulas that are goals to be proven, 
      and labels each such sub-goal with a distinct label variable

      Returns the labeled query and the label terms that were added
*)
let label_goals use_env_msg r q : term * labels * ranges = 
    let flag, msg_prefix = match use_env_msg with 
        | None -> false, ""
        | Some f -> true, f() in
    let fresh_label rs t labs = 
        let rs' = if not flag
                 then rs
                 else match rs with 
                        | (Some reason, _)::_ -> [Some ("Failed to verify implicit argument: " ^reason), r]
                        | _ -> [Some "Failed to verify implicit argument", r] in
        let lt, labs = fresh_label rs' t labs in
        lt, labs, rs in
    let rec aux rs q labs = match q.tm with
        | BoundV _ 
        | Integer _ -> 
          q, labs, rs

        | Labeled(_, "push", r) -> 
          Term.mkTrue, labs, (None, r)::rs

        | Labeled(_, "pop", r) ->
          Term.mkTrue, labs, List.tl rs

        | Labeled(arg, reason, r) -> 
          let tm, labs, rs = aux ((Some reason, r)::rs) arg labs in
          tm, labs, List.tl rs

        | App(Imp, [lhs;rhs]) -> 
          let rhs, labs, rs = aux rs rhs labs in
          let lhs, labs, rs = match lhs.tm with 
            | App(And, conjuncts) -> 
              let (labs, rs), conjuncts = Util.fold_map (fun (labs, rs) tm -> 
                match tm.tm with 
                | Quant(Forall, [[{tm=App(Var "Prims.guard_free", [p])}]], iopt, sorts, {tm=App(Iff, [l;r])}) ->
                  let r, labs, rs = aux rs r labs in
                  let q = mk <| Quant(Forall, [[p]], Some 0, sorts, mk (App(Iff, [l;r]))) in
                  (labs, rs), q
                | _ -> (labs, rs), tm) (labs, rs) conjuncts in
              let tm = List.fold_right (fun conjunct out -> Term.mkAnd(out, conjunct)) conjuncts Term.mkTrue in
              tm, labs, rs
           | _ -> lhs, labs, rs in
          Term.mkImp(lhs, rhs), labs, rs

        | App(And, conjuncts) ->
          let rs, conjuncts, labs = List.fold_left (fun (rs, cs, labs) c -> 
            let c, labs, rs = aux rs c labs in
            rs, c::cs, labs) 
            (rs, [], labs)
            conjuncts in
          let tm = List.fold_left (fun out conjunct -> Term.mkAnd(out, conjunct)) Term.mkTrue conjuncts in
          tm, labs, rs
       
        | App(ITE, [hd; q1; q2]) -> 
          let q1, labs, _ = aux rs q1 labs in
          let q2, labs, _ = aux rs q2 labs in
          mk (App(ITE, [hd; q1; q2])), labs, rs

        | Quant(Exists, _, _, _, _)
        | App(Iff, _)
        | App(Or, _) -> //non-atomic, but can't case split 
          fresh_label rs q labs

        | FreeV _ 
        | App(True, _)
        | App(False, _)
        | App(Not, _)
        | App(Eq, _)
        | App(LT, _)
        | App(LTE, _)
        | App(GT, _)
        | App(GTE, _)
        | App(Var _, _) -> //atomic goals
          fresh_label rs q labs

        | App(Add, _)
        | App(Sub, _)
        | App(Div, _)
        | App(Mul, _)
        | App(Minus, _)
        | App(Mod, _) -> 
          failwith "Impossible: non-propositional term"
       
        | App(ITE, _)
        | App(Imp, _) -> 
          failwith "Impossible: arity mismatch"
       
        | Quant(Forall, pats, iopt, sorts, body) -> 
          let body, labs, rs = aux rs body labs in 
          mk (Quant(Forall, pats, iopt, sorts, body)), labs, rs in
    aux [] q []


(* 
   detail_errors all_labels potential_errors askZ3
    
      -- Searching through the list of errors labels to exhaustively list 
         only those that are definitely not provable given the current 
         solver parameters.

      -- potential_errors are the labels in the initial counterexample model
 *)
let detail_errors (all_labels:labels) (potential_errors:labels) (askZ3:decls_t -> (bool * labels)) : labels = 
    let ctr = Util.mk_ref 0 in
    let elim labs = //assumes that all the labs are true, effectively removing them from the query
        incr ctr;
        Term.Echo ("DETAILING ERRORS" ^ (string_of_int !ctr)) ::
        (labs |> List.map (fun (l, _, _) -> Term.Assume(mkEq(Term.mkFreeV l, Term.mkTrue), Some "Disabling label", Some ("disable_label_"^fst l)))) in
    let print_labs tag l = l |> List.iter (fun (l, _, _) -> Util.print2 "%s : %s; " tag (fst l)) in
    //l1 - l2: difference of label lists
    let minus l1 l2 = 
        l1 |> List.filter (fun ((x, _), _, _) ->
        not (l2 |> Util.for_some (fun ((y, _), _, _) -> x=y))) in

    //check all active labels linearly and classify as eliminated/error
    let rec linear_check eliminated errors active = 
        match active with 
            | [] -> let labs = errors |> sort_labels in
//                    print_labs "Localized errors: " labs;
                    labs
            | hd::tl -> 
              let ok, _ = askZ3 (elim <| (eliminated @ errors @ tl)) in //hd is the only thing to prove
              if ok //hd is provable
              then linear_check (hd::eliminated) errors tl
              else linear_check eliminated (hd::errors) tl in

    //bisect active labels and classify as eliminated/potential_error
    let rec bisect (eliminated:labels) (potential_errors:labels) (active:labels) =
        match active with
            | [] -> (eliminated, potential_errors)
            | _ -> 
              let pfx, sfx = match active with 
                | [_] -> active, []
                | _ -> Util.first_N (List.length active / 2) active in
              let ok, pfx_subset = askZ3 (elim (eliminated @ potential_errors @ sfx)) in //focus on the goals in pfx, only
              if ok //good; everything in the pfx is provable
              then bisect (eliminated@pfx) potential_errors sfx
              else match pfx_subset with 
                     | [] ->  //didn't prove it, but didn't get back a useful error report either
                       //all of them may be errors
                       bisect eliminated (potential_errors@pfx) sfx

                     | _ -> //looks like something in pfx_subset may be to blame 
                       let potential_errors = potential_errors@pfx_subset in
                       let pfx_active = minus pfx pfx_subset in //but we can't yet eliminate pfx_active
                       bisect eliminated potential_errors (pfx_active@sfx)  
    in

    //bisect until fixed point; then do a linear scan on the potential errors
    let rec until_fixpoint eliminated potential_errors active = 
        let eliminated', potential_errors = bisect eliminated potential_errors active in
        if Util.physical_equality eliminated eliminated' //converged
        then linear_check eliminated [] potential_errors
        else until_fixpoint eliminated' [] potential_errors in

    let active = minus all_labels potential_errors in
    until_fixpoint [] potential_errors active