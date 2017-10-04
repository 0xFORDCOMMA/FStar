module PatternMatching

open FStar.Tactics

open PatternMatching.Types
open PatternMatching.Utils
open PatternMatching.Exceptions

type bindings = list (var * term)

let string_of_bindings (bindings: bindings) =
  String.concat "\n"
    (List.Tot.map (fun (nm, tm) -> (">> " ^ (inspect_bv nm) ^ ": " ^ term_to_string tm))
                  bindings)

/// Pattern interpretation
/// ======================

let eqvar : eqtype = admit(); var

let rec interp_pattern_aux (pat: pattern) (tm: term) (cur_bindings: bindings)
    : match_res bindings =
  let interp_any () =
    return [] in
  let interp_var (v: eqvar) =
    match List.Tot.assoc v cur_bindings with
    | Some tm' -> if term_eq tm tm' then return cur_bindings
                 else raise (NonLinearMismatch (v, tm, tm'))
    | None -> return ((v, tm) :: cur_bindings) in
  let interp_qn (qn: qn) =
    match inspect tm with
    | Tv_FVar fv ->
      if inspect_fv fv = qn then return cur_bindings
      else raise (NameMismatch (qn, (inspect_fv fv)))
    | _ -> raise (SimpleMismatch (pat, tm)) in
  let interp_app (p_hd p_arg: p:pattern{p << pat}) =
    match inspect tm with
    | Tv_App hd (arg, _) ->
      with_hd <-- interp_pattern_aux p_hd hd cur_bindings;
      with_arg <-- interp_pattern_aux p_arg arg with_hd;
      return with_arg
    | _ -> raise (SimpleMismatch (pat, tm)) in
  match pat with
  | SPAny -> interp_any ()
  | SPVar var -> interp_var var
  | SPQn qn -> interp_qn qn
  | SPApp p_hd p_arg -> interp_app p_hd p_arg

let interp_pattern (pat: pattern) (tm: term) : match_res bindings =
  rev_bindings <-- interp_pattern_aux pat tm [];
  return (List.Tot.rev rev_bindings)

/// Pattern notations
/// =================

assume val __ : #t:Type -> t
let any_qn = ["PatternMatching"; "__"]

(** Compile a β-reduced term into a pattern **)
let rec pattern_of_term_ex tm : match_res pattern =
  match inspect tm with
  | Tv_Var bv -> return (SPVar bv)
  | Tv_FVar fv ->
    let qn = inspect_fv fv in
    return (if qn = any_qn then SPAny else SPQn qn)
  | Tv_App f (x, _) ->
    let is_any = match inspect f with
                 | Tv_FVar fv -> inspect_fv fv = any_qn
                 | _ -> false in
    if is_any then
      return SPAny
    else
      (fpat <-- pattern_of_term_ex f;
       xpat <-- pattern_of_term_ex x;
       return (SPApp fpat xpat))
  // | Tv_Unknown -> SPAny
  | _ -> raise (UnsupportedTermInPattern tm)

let beta_reduce (tm: term) : Tac term =
  norm_term [] tm ()

let pattern_of_term tm : Tac pattern =
  admit ();
  lift_exn_tac pattern_of_term_ex (beta_reduce tm)

let pattern_of_binder binder =
  pattern_of_term (type_of_binder binder)

let rec binders_and_body_of_abs tm : binders * term =
  match inspect tm with
  | Tv_Abs binder tm ->
    let binders, body = binders_and_body_of_abs tm in
    binder :: binders, body
  | _ -> [], tm

let pattern_of_abs tm : Tac pattern =
  let binders, body = binders_and_body_of_abs tm in
  pattern_of_term body

// let abspat' (f: 'a) : Tac pattern =
//   admit ();
//   pattern_of_abs (quote f ())

// let abspat (f: 'a) : tactic unit =
//   fun () ->
//     let pat = abspat' f in
//     exact (quote pat) ()

let match_term pat tm : Tac bindings =
  lift_exn_tac (interp_pattern pat) tm

let match_goal pat : Tac bindings =
  norm [] (); // β-reduce
  match_term pat (cur_goal ())

/// Pattern-matching problems
/// =========================

/// Definitions
/// -----------

type hypothesis = binder

noeq type matching_problem =
  { mp_vars: list var;
    mp_hyps: list (var * pattern);
    mp_goal: option pattern }

noeq type matching_solution =
  { ms_vars: list (var * term);
    ms_hyps: list (var * hypothesis) }

/// Notations
/// ---------

let hyp (a: Type) = binder
let goal (a: Type) = unit

let erased_hyp_qn = ["PatternMatching"; "hyp"]
let erased_goal_qn = ["PatternMatching"; "goal"]

// (fun a b (fun (h1: a) (h2: a -> b) (goal: !! b) -> pose proof (h1 h2)));

type abspat_binder_kind =
| ABKNone
| ABKHyp
| ABKGoal

let string_of_abspat_binder_kind = function
  | ABKNone -> "var"
  | ABKHyp -> "hyp"
  | ABKGoal -> "goal"

// Must store this because recomputing it yields different names
type abspat_continuation =
  list (abspat_binder_kind * var) * term

let classify_abspat_binder binder : Tac (abspat_binder_kind * term) =
  admit ();

  let var = fresh_binder (quote Type ()) in
  let hyp_pat = SPApp (SPQn erased_hyp_qn) (SPVar var) in
  let goal_pat = SPApp (SPQn erased_goal_qn) (SPVar var) in

  let typ = type_of_binder binder in
  match interp_pattern hyp_pat typ with
  | Success [(_, hyp_typ)] -> ABKHyp, hyp_typ
  | Failure _ ->
    match interp_pattern goal_pat typ with
    | Success [(_, goal_typ)] -> ABKGoal, goal_typ
    | Failure _ -> ABKNone, typ

let matching_problem_of_abs (tm: term) : Tac (matching_problem * abspat_continuation) =
  admit ();

  let binders, body = binders_and_body_of_abs tm in
  print ("Got binders: " ^ (String.concat ", " (List.Tot.map inspect_bv binders))) ();

  let problem =
    tacfold_left
      (fun problem (binder: binder) ->
         print ("Got binder: " ^ (inspect_bv binder)) ();
         let binder_kind, typ = classify_abspat_binder binder in
         print ("Compiling binder " ^ inspect_bv binder ^
                ", classified as " ^ string_of_abspat_binder_kind binder_kind ^
                ", with type " ^ term_to_string typ) ();
         match binder_kind with
         | ABKNone -> { problem with mp_vars = binder :: problem.mp_vars }
         | ABKHyp -> print (string_of_pattern (pattern_of_term typ)) (); { problem with mp_hyps = (binder, (pattern_of_term typ)) :: problem.mp_hyps }
         | ABKGoal -> { problem with mp_goal = Some (pattern_of_term typ) })
      ({ mp_vars = []; mp_hyps = []; mp_goal = None })
      binders in

  let continuation =
    let continuation_arg_of_binder binder =
      print ("Building binder arg for continuation: " ^ (inspect_bv binder)) ();
      (fst (classify_abspat_binder binder), binder) in
    (tacmap continuation_arg_of_binder binders, tm) in

  print "AA" ();
  let mp =
    { mp_vars = List.rev #var problem.mp_vars;
      mp_hyps = List.rev #(var * pattern) problem.mp_hyps;
      mp_goal = problem.mp_goal } in
  print "BB" ();
  mp, continuation

/// Resolution
/// ----------

let rec solve_mp_for_single_hyp #a
                                (name: var)
                                (pat: pattern)
                                (hypotheses: list hypothesis)
                                (body: matching_solution -> Tac a)
                                (part_sol: matching_solution)
    : Tac a =
  admit ();
  match hypotheses with
  | [] ->
    fail #a "No matching hypothesis" ()
  | h :: hs ->
    or_else
      (fun () ->
         match interp_pattern_aux pat (type_of_binder h) part_sol.ms_vars with
         | Failure ex ->
           fail ("Failed to match hyp: " ^ (string_of_match_exception ex)) ()
         | Success bindings ->
           let ms_hyps = (name, h) :: part_sol.ms_hyps in
           body ({ part_sol with ms_vars = bindings; ms_hyps = ms_hyps }))
      (fun () ->
         solve_mp_for_single_hyp name pat hs body part_sol)
      ()

let rec solve_mp_for_hyps #a
                          (mp_hyps: list (var * pattern))
                          (hypotheses: list hypothesis)
                          (body: matching_solution -> Tac a)
                          (partial_solution: matching_solution)
    : Tac a =
  match mp_hyps with
  | [] -> body partial_solution
  | (name, pat) :: pats ->
    solve_mp_for_single_hyp name pat hypotheses
      (solve_mp_for_hyps pats hypotheses body)
      partial_solution

let solve_mp #a (problem: matching_problem)
                (hypotheses: binders) (goal: term)
                (body: matching_solution -> Tac a)
    : Tac a =
  let goal_ps =
    match problem.mp_goal with
    | None -> { ms_vars = []; ms_hyps = [] }
    | Some pat ->
      match interp_pattern pat goal with
      | Failure ex -> fail ("Failed to match goal: " ^ (string_of_match_exception ex)) ()
      | Success bindings -> { ms_vars = bindings; ms_hyps = [] } in
  solve_mp_for_hyps #a problem.mp_hyps hypotheses body goal_ps

#set-options "--lax"

let apply_matching_solution #a
                            (problem: matching_problem)
                            (continuation: abspat_continuation)
    : matching_solution -> Tac a =
  admit ();

  let locate_var #a (alist: list (var * a)) var : Tac a =
    match List.Tot.assoc var alist with
    | Some tm -> tm
    | None -> fail ("No binding for " ^ (inspect_bv var)) () in

  let locate_hyp solution hyp =
    let tm = locate_var solution.ms_hyps hyp in
    (quote tm (), Q_Explicit) in

  let locate_var solution var =
    (locate_var solution.ms_vars var, Q_Explicit) in

  let compute_args vars solution =
    tacmap
      (fun (binder_kind, var) ->
         match binder_kind with
         | ABKNone -> locate_var solution var
         | ABKHyp -> locate_hyp solution var
         | ABKGoal -> (quote () (), Q_Explicit))
      vars in

  let vars, continuation_fn = continuation in

  fun solution ->
    let applied = mk_app continuation_fn (compute_args vars solution) in
    print ("Constructed this term: " ^ (term_to_string applied)) ();
    let tm_unit = quote unit () in
    let binder = fresh_binder tm_unit in
    let thunked = pack (Tv_Abs binder applied) in
    fail "A" ()
    // let unquoted = unquote #(unit -> Tac a) thunked () in
    // unquoted ()

#reset-options

/// Examples
/// --------

open FStar.Tactics

let mp_example : matching_problem =
  synth_by_tactic
    (fun () ->
      let abs = quote (fun (a b: Type) (h1: hyp (a ==> b)) (h2: hyp (a)) (_: goal (squash b)) ->
                         let open FStar.Tactics in
                         print (inspect_bv h1);;
                         print (inspect_bv h2)) () in
      let mp, continuation = matching_problem_of_abs abs in
      print "AAA" ();
      // let qq = quote mp () in
      // print_term qq ();
      exact (quote mp) ())

open FStar.Tactics

let string_of_matching_solution ms =
  let vars =
    String.concat "\n            "
      (List.Tot.map (fun (var, tm) -> var ^ ": " ^ (term_to_string tm)) ms.ms_vars) in
  let hyps =
    String.concat "\n        "
      (List.Tot.map (fun (hyp, binder) -> hyp ^ ": " ^ (inspect_bv binder)) ms.ms_hyps) in
  "\n{ bindings: " ^ vars ^ "\n" ^
  "  hyps: " ^ hyps ^ " }"

// let print_binders abs : Tac unit =
//   let bdtm = binders_and_body_of_abs abs in
//   let binders, tm = bdtm in
//   print (String.concat ", " (List.Tot.map inspect_bv binders)) ()

let mgw #a #b (abspat: a) : tactic b =
  fun () ->
    admit ();
    let abs = quote abspat () in
    let problem, continuation = matching_problem_of_abs abs in
    let goal = cur_goal () in
    let hypotheses = binders_of_env (cur_env ()) in
    let kinds_and_vars, _ = continuation in
    let s = String.concat ", " (List.Tot.map snd kinds_and_vars) in
    print s ();
    let solution = solve_mp #matching_solution problem hypotheses goal
                     (fun solution -> solution) in
    print (string_of_matching_solution solution) ();
    apply_matching_solution #b problem continuation solution

// Need to solve the problem in Minimal.fst

#set-options "--print_implicits --print_bound_var_types --ugly --print_full_names"

let example (p1 p2: Type0) =
  assert_by_tactic (p1 ==> (p1 ==> p2) ==> p2)
                   (_ <-- implies_intros;
                    mgw (fun (a b: Type) (h1: hyp (a ==> b)) (h2: hyp (a)) ((): goal (squash b)) ->
                            let open FStar.Tactics in
                            print (inspect_bv h1) ();
                            print (inspect_bv h2) ();
                            idtac ()))


// let __ =
//   assert_by_tactic (1 == 1)
//                    (fun () ->
//                      let problem = { )

//   hyp_binders <--

let tmatch_term pat tm : tactic bindings =
  lift_exn_tactic (interp_pattern pat) tm

let tmatch_goal pat : tactic bindings =
  let open FStar.Tactics in
  cg <-- cur_goal;
  tmatch_term pat cg

// let pat : pattern =
//   synth_by_tactic (abspat (fun (x: int) -> x == x))

let pat = (SPApp (SPApp (SPApp (SPQn ["Prims"; "eq2"])
                               (SPQn ["Prims"; "int"]))
                        (SPVar "x"))
                 (SPVar "x"))

open FStar.Tactics

#set-options "--tactic_trace"

let string_of_res res =
  match res with
  | Success bb -> "OK"
  | Failure ex -> (string_of_match_exception ex)

// Beta reduction not working
let test () =
  assert_by_tactic (1 == 1)
    (fun () ->
      let pat = abspat' (fun (x: int) -> Prims.squash (x == x)) in
      let bindings = match_goal pat in
      print (string_of_bindings bindings) ();
      trefl ())

// let (%) #a (h: unit) (y: Type) =
//   unit

// mgw
//   [(fun a b | (h1: a) (h2: a -> b) (goal: b) -> pose proof (h1 h2));
//    (fun a b (h: a /\ b) -> split h)]


let pattern_of_abspat abspat =
  abspat_term <-- quote abspat;
  pat <-- lift_exn_tac pattern_of_abs abspat_term;
  return pat

let match_goal_with abspat =
  pat <-- pattern_of_abspat abspat;
  match_goal_with_pat pat

let match_term_with abspat tm =
  pat <-- pattern_of_abspat abspat;
  match_term_with_PatternMatching pat tm

// bindings <-- match_goal_with_pat (PApp (PQn squash_qna) [PApp (PQn eq2_qn) [PAny; PVar "a"; PVar "b"]]);

// Ltac reflect term :=
//   lazymatch term with
//   | op ?x ?y -> =
//     let rx := reflect x in
//     let ry := reflect y in
//     constr:(Node rx ry)
//   | _ -> constr:(Leaf term)

// let unquote #a tm : a =
//   synth_by_tactic (exact (return tm))

let match_term_with2 (tm: term) (abspat: 'a -> 'b -> 'c) (k: term -> term -> tactic 'd) : tactic 'd =
  pat <-- pattern_of_abspat abspat;
  bindings <-- match_term pat tm;
  match bindings with
  | [(_, t1); (_, t2)] -> k t1 t2
  | _ -> fail ("Too many or too few bindings: " ^ (string_of_bindings bindings))

let match_goal_with2 (abspat: 'a -> 'b -> 'c) (k: term -> term -> tactic 'd) : tactic 'd =
  g <-- cur_goal;
  match_term_with2 g abspat k

let print_pattern (abspat: 'a) : tactic unit =
  pat <-- pattern_of_abspat abspat;
  print (string_of_PatternMatching pat)

assume val a0: a
assume val a0_neutral_l : a1: a -> Lemma ((a1 `op` a0) `eql` a1)
assume val a0_neutral_r : a1: a -> Lemma ((a0 `op` a1) `eql` a1)
assume val op_comm : a1: a -> a2: a -> Lemma ((a1 `op` a2) `eql` (a2 `op` a1))
assume val op_PatternMatching : a1: a -> a2: a -> Lemma ((a1 `op` a1) `eql` (a2 `op` a2))

let rec first #a (tactics: list (tactic a)) : tactic a =
  match tactics with
  | [] -> fail "No tactics"
  | [t] -> t
  | t :: ts -> or_else t (first ts)

let ( --> ) abspat tac =
  match_goal_with abspat;;
  tac

// TODO: Add a forall handler

let string_of_binder (b: binder) =
  term_to_string (type_of_binder b)

let match_env_with abspat =
  env <-- cur_env;
  let hyps = binders_of_env env in
  print_pattern abspat;;
  let matcher = match_term_with abspat in
  first (List.Tot.map (fun hyp ->
             bindings <-- matcher (type_of_binder hyp);
             return (hyp, bindings))
           hyps)

// let reif tm : tactic unit =
//   bindings <-- match_term_with (fun x -> - x) tm;
//   match bindings with
//   | [(_, tx)] -> print_term tx;;
//                 idtac
//   | _ -> fail "A"

// let x () : Lemma True =
//   assert_by_tactic True
//     (m1 <-- quote (- 1);
//      reif m1)

let rec reflect_ops (tm: term) : tactic term =
  or_else (match_term_with2 tm (fun x y -> x `op` y)
             (fun x y -> admit ();
                      rx <-- reflect_ops x;
                      ry <-- reflect_ops y;
                      node <-- quote Node;
                      return (mk_app node [rx; ry])))
          (leaf <-- quote Leaf;
           return (mk_app leaf [tm]))


// assume val g1: Type0
// assume val g2: Type0
// assume val w1: g1
// assume val w12: g1 -> g2

// let test : unit =
//   assert_by_tactic g2 (apply (quote w12);; exact (quote w1))

let change_goal_lemma (#g1 #g2: Type0) : squash g1 -> (squash (g1 == g2)) -> squash g2 =
  (fun w1 eq -> w1)

// let prove_assoc (a1 a2 a3: a) : Lemma True =
//   assert_by_tactic (a1 `eql` a2)
//     (apply (quote (change_goal_lemma #(a1 `eql` a2) #(a1 `eql` a2)));;
//      idtac)

// let prove_assoc (a1 a2 a3: a) : Lemma True =
//   // assert_by_tactic ((a1 `op` (a2 `op` a3)) `eql` ((a1 `op` a2) `op` a3))
//   assert_by_tactic (a1 `eql` a2)
//     (xy <-- match_goal_with (fun x y -> squash (x `eql` y));
//      match xy with
//      | [(_, tx); (_, ty)] ->
//        dup;;
//        eq_fv <-- quote eql;
//        squash_fv <-- quote squash;
//        aa1 <-- quote a1;
//        aa2 <-- quote a2;
//        exact (return (mk_app squash_fv [mk_app eq_fv [aa1; aa2]]));;
//        trefl
//      | _ -> fail "impossible")


// FIXME why does running fail on 0 goals fail?
// FIXME does bind apply tactics to each goal individually?

// let weaken hyp impl =

// let test0 (f: False \/ False) : Lemma True =
//   assert_by_tactic False (res <-- match_env_with (fun x y -> x \/ y);
//                       print (string_of_bindings (snd res));;
//                       fail "A")

type narg_type = name:string * typ:Type
type narg #t: Type = name:string * value:t

noeq type klist : (ts: list narg_type) -> Type =
| HNil: klist []
| HCons: #hdT:Type -> #tlT: list narg_type ->
         hd:(string * hdT) ->
         tl:(klist tlT) ->
         klist ((fst hd, hdT) :: tlT)

type kfunc (nargTs: list narg_type) retT =
  klist nargTs -> retT

let (^.) = HCons

let x = ("start", 1) ^. ("len", 2) ^. ("str", "abc") ^. HNil


let bind_bind_t
    (m: Type -> Type)
    (return: #a: Type -> aa: a -> m a)
    (bind: #a: Type -> #b: Type -> m a -> (a -> m b) -> m b) =
  forall #a #b #c (ma: m a) (f: a -> m b) (g: b -> m c).
     bind #b #c (bind ma f) g ==
     bind #a #c ma (fun (aa: a) -> bind (f aa) g)

noeq type monad_typeclass =
| MkMonad :
    m: (Type -> Type) ->
    return: (#a:Type -> aa: a -> m a) ->
    bind: (#a: Type -> #b: Type -> m a -> (a -> m b) -> m b) ->
    bind_bind: (forall #a #b #c (ma: m a) (f: a -> m b) (g: b -> m c).
                bind #b #c (bind ma f) g ==
                bind #a #c ma (fun (aa: a) -> bind (f aa) g)) ->
    monad_typeclass



assume val substring: s:string -> start:int -> len:int -> string

// match_term #(#x + #y) #(return (#x - #y)) { x=1; y=2 }

let ex_capture : unit =
  assert_by_tactic (True \/ False)
    (bindings <-- match_goal_with (fun x y -> squash (x \/ y));
     print (string_of_bindings bindings))

let ex_non_linear_mismatch : unit =
  assert_by_tactic (True \/ False)
    (match_goal_with (fun x -> squash (x \/ __));;
     idtac)


let step =
  first [True
           --> trivial;

         squash (__ /\ __)
           --> split;

         (fun x y -> squash ((x `op` y) `eql` (y `op` x)))
           --> apply_lemma (quote op_comm);

         (fun x y -> squash ((x `op` x) `eql` (y `op` y)))
           --> apply_lemma (quote op_same_squares);

         fail "Nope"]

let crush =
  repeat step;; idtac
  // or_else trivial (fail "crush failed")

let ex0 (a1 a2: a) =
  assert_by_tactic ((a1 `op` a2) `eql` (a2 `op` a1)) crush

let ex1 (a1 a2: a) =
  assert_by_tactic ((a1 `op` a1) `eql` (a2 `op` a2)) crush

let ex2 (a1 a2: a) =
  assert_by_tactic (((a1 `op` a1) `eql` (a2 `op` a2)) /\ True) crush

let ex2 (a1 a2: a) =
  assert_by_tactic ((((a1 `op` a1) `eql` (a2 `op` a2)) /\ True)) crush

let ex_non_linear_mismatch : unit =
  assert_by_tactic (True \/ False)
    (match_goal_with (fun x -> squash (x \/ x));;
     idtac)

















let test2 (a1 a2 a3 a4 a5 a6 a7: a)
    : Lemma ((a1 `op` (a2 `op` a3)) `op` (((a4 `op` a5) `op` a6) `op` a7) `eql`
             (a1 `op` (a2 `op` (a3 `op` (((a4 `op` a5) `op` a6) `op` a7))))) =
  assert_by_tactic ((a1 `op` (a2 `op` a3)) `op` (((a4 `op` a5) `op` a6) `op` a7) `eql`
                    (a1 `op` (a2 `op` (a3 `op` (((a4 `op` a5) `op` a6) `op` a7)))))
                   (dump "A";;
                    xx <-- print_pattern (fun (x y: a) -> squash (x `eql` x));
                    match_goal_with2 (fun (x y: a) -> squash (x `eql` x))
                         (fun (x y: term) -> print_term x;; print_term y);;
                    fail "A");
  admit ()

// Ltac reflect term :=
//   lazymatch term with
//   | op ?x ?y -> =
//     let rx := reflect x in
//     let ry := reflect y in
//     constr:(Node rx ry)
//   | _ -> constr:(Leaf term)

// Ltac subst_reflected term :=
//   let reflected := reflect term in
//   change term with (interp reflected);
//   rewrite !(interp_flatten reflected).

// Ltac solve_eq :=
//   lazymatch goal with
//   | [  |- ?x = ?y ] ->
//     subst_reflected x;
//     subst_reflected y;
//     reflexivity

// Ltac solve_eq_slow := rewrite !Opassoc; reflexivity.

// let rec balanced n a =
//   match n with
//   | O -> a
//   | S x -> Op (Balanced x a) (Balanced x a)

// let rec pow2 n =
//   match n with
//   | O -> 1
//   | S x -> (pow2 x) + (pow2 x)

// let rec skewed n a =
//   match n with
//   | O -> a
//   | S x -> Op a (Skewed x a)

// Definition eqN n := forall a, Balanced n a = Skewed (pow2 n - 1) a.

// Goal eqN 7.
//   intro; simpl.
//   Time solve_eq_slow.
// Qed.

