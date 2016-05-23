﻿#light "off"
module FStar.Tests.Test
open FStar.Syntax
open FStar
open FStar.Syntax.Syntax
module S = FStar.Syntax.Syntax
module SS = FStar.Syntax.Subst
module U = FStar.Syntax.Util
let r = Range.dummyRange

let bv x n : bv = {
    ppname=Ident.id_of_text x;
    index=n;
    sort=S.tun
}
let a = "a"
let x = "x"
let wp = "wp"
let test_subst () = 
  let s = [Renaming[Index2Name   (0, bv a 5765)];
           Renaming[Name2Name    (bv a 5765, bv a 5761)];
           Renaming[Name2Index   (bv a 5761, 1); Name2Index   (bv x 0, 0)];
           Renaming[Index2Name   (0, bv wp 5773); Index2Name   (1, bv a 5772)]] in
  printfn "%s" (Subst.print_subst_detail s)

[<EntryPoint>] 
let main argv =
    printfn "Initializing ...";
//    Pars.init() |> ignore;
    FStar.Syntax.Print.init();
    test_subst();
//    Norm.run_all (); 
//    Unif.run_all ();
    0




//    let uvar1 = Unionfind.fresh S.Uvar in
//    let uvar2 = Unionfind.fresh S.Uvar in
//    let uv1 = S.mk (S.Tm_uvar(uvar1, S.tun)) None r in
//    let uv2 = S.mk (S.Tm_uvar(uvar2, S.tun)) None r in
//    let list_uv1 = S.mk_Tm_app (S.fvar (Ident.lid_of_path ["Prims"; "list"] r) S.Delta_constant None) [uv1, None] None r in
//    let x = S.new_bv None uv2 in
//    let abs = U.abs [x, None] S.tun None in
//    Printf.printf "Abstraction is %s\n" (Print.term_to_string abs);
//    let y = S.new_bv None S.tun in
//    Unionfind.change uvar2 (S.Fixed (list_uv1));
//    Unionfind.change uvar1 (S.Fixed(S.bv_to_name y));
//    let abs' = U.abs [y, None] abs None in
//    Printf.printf "Closed abstraction is %s\n" (Print.term_to_string abs');
//    0
     