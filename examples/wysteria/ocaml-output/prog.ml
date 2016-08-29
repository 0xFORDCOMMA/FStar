open AST
open FFI
open Z


let const_meta = Meta ([], Can_b, [], Can_w)

let gt x y = x > y

let program = [
("alice_s", (T_eprins), (mk_ffi ~$1 "FFI.singleton" (FFI.singleton) [  (mk_var "alice" (T_prin)); ] (fun x -> D_v (const_meta, V_eprins x))));
("bob_s", (T_eprins), (mk_ffi ~$1 "FFI.singleton" (FFI.singleton) [  (mk_var "bob" (T_prin)); ] (fun x -> D_v (const_meta, V_eprins x))));
("charlie_s", (T_eprins), (mk_ffi ~$1 "FFI.singleton" (FFI.singleton) [  (mk_var "charlie" (T_prin)); ] (fun x -> D_v (const_meta, V_eprins x))));
("ab", (T_cons ("Prins.eprins", [])), (mk_ffi ~$2 "FFI.union" (FFI.union) [  (mk_var "alice_s" (T_eprins)); (mk_var "bob_s" (T_eprins)); ] (fun x -> D_v (const_meta, V_eprins x))));
("bc", (T_cons ("Prins.eprins", [])), (mk_ffi ~$2 "FFI.union" (FFI.union) [  (mk_var "bob_s" (T_eprins)); (mk_var "charlie_s" (T_eprins)); ] (fun x -> D_v (const_meta, V_eprins x))));
("ac", (T_cons ("Prins.eprins", [])), (mk_ffi ~$2 "FFI.union" (FFI.union) [  (mk_var "alice_s" (T_eprins)); (mk_var "charlie_s" (T_eprins)); ] (fun x -> D_v (const_meta, V_eprins x))));
("abc", (T_cons ("Prins.eprins", [])), (mk_ffi ~$2 "FFI.union" (FFI.union) [  (mk_var "ab" (T_cons ("Prins.eprins", []))); (mk_var "charlie_s" (T_eprins)); ] (fun x -> D_v (const_meta, V_eprins x))));
("check_fresh", (T_unknown), (mk_fix (mk_varname "check_fresh" (T_unknown)) (mk_varname "l" (T_cons ("Prims.list", [ (T_sh);]))) (mk_abs (mk_varname "s" (T_sh)) (mk_cond (mk_ffi ~$2 "Prims.op_Equality" (Prims.op_Equality) [  (mk_var "l" (T_cons ("Prims.list", [ (T_sh);]))); (mk_ffi ~$1 "FFI.mk_nil" (FFI.mk_nil) [  (mk_const (C_unit ())); ] (fun x -> mk_v_opaque x (slice_list Semantics.slice_v_ffi) (compose_lists Semantics.compose_vals_ffi) (slice_list_sps Semantics.slice_v_sps_ffi))); ] (fun x -> D_v (const_meta, V_bool x))) (mk_const (C_bool true)) (mk_let (mk_varname "x" (T_sh)) (mk_ffi ~$1 "FFI.hd_of_cons" (FFI.hd_of_cons) [  (mk_var "l" (T_cons ("Prims.list", [ (T_sh);]))); ] (fun x -> x)) (mk_let (mk_varname "get_tmp" (T_unknown)) (mk_abs (mk_varname "_15_24" (T_prin)) (mk_abs (mk_varname "_15_26" (T_unit)) (mk_const (C_opaque ((), Obj.magic 2, T_cons ("Prims.int", [])))))) (mk_let (mk_varname "t1" (T_box (T_cons ("Prims.int", [])))) (mk_aspar (mk_var "alice_s" (T_eprins)) (mk_app (mk_var "get_tmp" (T_unknown)) (mk_var "alice" (T_prin)))) (mk_let (mk_varname "t2" (T_box (T_cons ("Prims.int", [])))) (mk_aspar (mk_var "bob_s" (T_eprins)) (mk_app (mk_var "get_tmp" (T_unknown)) (mk_var "bob" (T_prin)))) (mk_let (mk_varname "t3" (T_box (T_cons ("Prims.int", [])))) (mk_aspar (mk_var "charlie_s" (T_eprins)) (mk_app (mk_var "get_tmp" (T_unknown)) (mk_var "charlie" (T_prin)))) (mk_let (mk_varname "check_one" (T_unknown)) (mk_abs (mk_varname "_15_33" (T_unit)) (mk_let (mk_varname "t1'" (T_cons ("Prims.int", []))) (mk_unbox (mk_var "t1" (T_box (T_cons ("Prims.int", []))))) (mk_let (mk_varname "t2'" (T_cons ("Prims.int", []))) (mk_unbox (mk_var "t2" (T_box (T_cons ("Prims.int", []))))) (mk_let (mk_varname "t3'" (T_cons ("Prims.int", []))) (mk_unbox (mk_var "t3" (T_box (T_cons ("Prims.int", []))))) (mk_let (mk_varname "t4'" (T_bool)) (mk_ffi ~$2 "Prims.(>)" gt [  (mk_var "t1'" (T_cons ("Prims.int", []))); (mk_var "t2'" (T_cons ("Prims.int", []))); ] (fun x -> D_v (const_meta, V_bool x))) (mk_let (mk_varname "t5'" (T_bool)) (mk_ffi ~$2 "Prims.op_Equality" (Prims.op_Equality) [  (mk_var "t3'" (T_cons ("Prims.int", []))); (mk_var "t1'" (T_cons ("Prims.int", []))); ] (fun x -> D_v (const_meta, V_bool x))) (mk_let (mk_varname "c1" (T_cons ("Prims.int", []))) (mk_combsh (mk_var "x" (T_sh))) (mk_let (mk_varname "c2" (T_cons ("Prims.int", []))) (mk_combsh (mk_var "s" (T_sh))) (mk_ffi ~$2 "Prims.op_Equality" (Prims.op_Equality) [  (mk_var "c1" (T_cons ("Prims.int", []))); (mk_var "c2" (T_cons ("Prims.int", []))); ] (fun x -> D_v (const_meta, V_bool x))))))))))) (mk_let (mk_varname "b" (T_bool)) (mk_assec (mk_var "abc" (T_cons ("Prins.eprins", []))) (mk_var "check_one" (T_unknown))) (mk_cond (mk_var "b" (T_bool)) (mk_const (C_bool false)) (mk_app (mk_app (mk_var "check_fresh" (T_unknown)) (mk_ffi ~$1 "FFI.tl_of_cons" (FFI.tl_of_cons) [  (mk_var "l" (T_cons ("Prims.list", [ (T_sh);]))); ] (fun x -> mk_v_opaque x (slice_list Semantics.slice_v_ffi) (compose_lists Semantics.compose_vals_ffi) (slice_list_sps Semantics.slice_v_sps_ffi)))) (mk_var "s" (T_sh)))))))))))))));
("deal", (T_unknown), (mk_abs (mk_varname "ps" (T_eprins)) (mk_abs (mk_varname "shares" (T_cons ("Prims.list", [ (T_sh);]))) (mk_abs (mk_varname "rands" (T_wire (T_cons ("Prims.int", [])))) (mk_abs (mk_varname "deal_to" (T_prin)) (mk_let (mk_varname "proj" (T_unknown)) (mk_abs (mk_varname "p" (T_prin)) (mk_abs (mk_varname "_15_61" (T_unit)) (mk_projwire (mk_var "p" (T_prin)) (mk_var "rands" (T_wire (T_cons ("Prims.int", []))))))) (mk_let (mk_varname "r1" (T_box (T_cons ("Prims.int", [])))) (mk_aspar (mk_var "alice_s" (T_eprins)) (mk_app (mk_var "proj" (T_unknown)) (mk_var "alice" (T_prin)))) (mk_let (mk_varname "r2" (T_box (T_cons ("Prims.int", [])))) (mk_aspar (mk_var "bob_s" (T_eprins)) (mk_app (mk_var "proj" (T_unknown)) (mk_var "bob" (T_prin)))) (mk_let (mk_varname "r3" (T_box (T_cons ("Prims.int", [])))) (mk_aspar (mk_var "charlie_s" (T_eprins)) (mk_app (mk_var "proj" (T_unknown)) (mk_var "charlie" (T_prin)))) (mk_let (mk_varname "add" (T_unknown)) (mk_abs (mk_varname "_15_69" (T_unit)) (mk_let (mk_varname "r1'" (T_cons ("Prims.int", []))) (mk_unbox (mk_var "r1" (T_box (T_cons ("Prims.int", []))))) (mk_let (mk_varname "r2'" (T_cons ("Prims.int", []))) (mk_unbox (mk_var "r2" (T_box (T_cons ("Prims.int", []))))) (mk_let (mk_varname "r3'" (T_cons ("Prims.int", []))) (mk_unbox (mk_var "r3" (T_box (T_cons ("Prims.int", []))))) (mk_let (mk_varname "t1" (T_cons ("Prims.int", []))) (mk_ffi ~$2 "Prims.(+)" (Prims.(+)) [  (mk_var "r1'" (T_cons ("Prims.int", []))); (mk_var "r2'" (T_cons ("Prims.int", []))); ] (fun x -> mk_v_opaque x slice_id compose_ids slice_id_sps)) (mk_let (mk_varname "t2" (T_cons ("Prims.int", []))) (mk_ffi ~$2 "Prims.(+)" (Prims.(+)) [  (mk_var "t1" (T_cons ("Prims.int", []))); (mk_var "r3'" (T_cons ("Prims.int", []))); ] (fun x -> mk_v_opaque x slice_id compose_ids slice_id_sps)) (mk_mksh (mk_var "t2" (T_cons ("Prims.int", [])))))))))) (mk_let (mk_varname "new_sh" (T_sh)) (mk_assec (mk_var "abc" (T_cons ("Prins.eprins", []))) (mk_var "add" (T_unknown))) (mk_let (mk_varname "max" (T_cons ("Prims.int", []))) (mk_const (C_opaque ((), Obj.magic 52, T_cons ("Prims.int", [])))) (mk_let (mk_varname "conditional_sub" (T_unknown)) (mk_abs (mk_varname "c" (T_sh)) (mk_abs (mk_varname "_15_85" (T_unit)) (mk_let (mk_varname "r1'" (T_cons ("Prims.int", []))) (mk_unbox (mk_var "r1" (T_box (T_cons ("Prims.int", []))))) (mk_let (mk_varname "r2'" (T_cons ("Prims.int", []))) (mk_unbox (mk_var "r2" (T_box (T_cons ("Prims.int", []))))) (mk_let (mk_varname "r3'" (T_cons ("Prims.int", []))) (mk_unbox (mk_var "r3" (T_box (T_cons ("Prims.int", []))))) (mk_let (mk_varname "t1" (T_bool)) (mk_ffi ~$2 "Prims.(>)" gt [  (mk_var "r1'" (T_cons ("Prims.int", []))); (mk_var "r2'" (T_cons ("Prims.int", []))); ] (fun x -> D_v (const_meta, V_bool x))) (mk_let (mk_varname "t2" (T_bool)) (mk_ffi ~$2 "Prims.op_Equality" (Prims.op_Equality) [  (mk_var "r3'" (T_cons ("Prims.int", []))); (mk_var "r1'" (T_cons ("Prims.int", []))); ] (fun x -> D_v (const_meta, V_bool x))) (mk_let (mk_varname "c'" (T_cons ("Prims.int", []))) (mk_combsh (mk_var "c" (T_sh))) (mk_let (mk_varname "mod_c" (T_cons ("Prims.int", []))) (mk_cond (mk_ffi ~$2 "Prims.(>)" gt [  (mk_var "c'" (T_cons ("Prims.int", []))); (mk_var "max" (T_cons ("Prims.int", []))); ] (fun x -> D_v (const_meta, V_bool x))) (mk_ffi ~$2 "Prims.(-)" (Prims.(-)) [  (mk_var "c'" (T_cons ("Prims.int", []))); (mk_var "max" (T_cons ("Prims.int", []))); ] (fun x -> mk_v_opaque x slice_id compose_ids slice_id_sps)) (mk_var "c'" (T_cons ("Prims.int", [])))) (mk_mksh (mk_var "mod_c" (T_cons ("Prims.int", []))))))))))))) (mk_let (mk_varname "new_sh" (T_sh)) (mk_assec (mk_var "abc" (T_cons ("Prins.eprins", []))) (mk_app (mk_var "conditional_sub" (T_unknown)) (mk_var "new_sh" (T_sh)))) (mk_let (mk_varname "new_sh" (T_sh)) (mk_assec (mk_var "abc" (T_cons ("Prins.eprins", []))) (mk_app (mk_var "conditional_sub" (T_unknown)) (mk_var "new_sh" (T_sh)))) (mk_let (mk_varname "new_sh" (T_sh)) (mk_assec (mk_var "abc" (T_cons ("Prins.eprins", []))) (mk_app (mk_var "conditional_sub" (T_unknown)) (mk_var "new_sh" (T_sh)))) (mk_let (mk_varname "fresh" (T_bool)) (mk_app (mk_app (mk_var "check_fresh" (T_unknown)) (mk_var "shares" (T_cons ("Prims.list", [ (T_sh);])))) (mk_var "new_sh" (T_sh))) (mk_cond (mk_var "fresh" (T_bool)) (mk_let (mk_varname "card" (T_unknown)) (mk_abs (mk_varname "_15_106" (T_unit)) (mk_let (mk_varname "r1'" (T_cons ("Prims.int", []))) (mk_unbox (mk_var "r1" (T_box (T_cons ("Prims.int", []))))) (mk_let (mk_varname "r2'" (T_cons ("Prims.int", []))) (mk_unbox (mk_var "r2" (T_box (T_cons ("Prims.int", []))))) (mk_let (mk_varname "r3'" (T_cons ("Prims.int", []))) (mk_unbox (mk_var "r3" (T_box (T_cons ("Prims.int", []))))) (mk_let (mk_varname "t1" (T_bool)) (mk_ffi ~$2 "Prims.(>)" gt [  (mk_var "r1'" (T_cons ("Prims.int", []))); (mk_var "r2'" (T_cons ("Prims.int", []))); ] (fun x -> D_v (const_meta, V_bool x))) (mk_let (mk_varname "t2" (T_bool)) (mk_ffi ~$2 "Prims.op_Equality" (Prims.op_Equality) [  (mk_var "r3'" (T_cons ("Prims.int", []))); (mk_var "r1'" (T_cons ("Prims.int", []))); ] (fun x -> D_v (const_meta, V_bool x))) (mk_combsh (mk_var "new_sh" (T_sh))))))))) (mk_let (mk_varname "c" (T_cons ("Prims.int", []))) (mk_assec (mk_var "abc" (T_cons ("Prins.eprins", []))) (mk_var "card" (T_unknown))) (mk_ffi ~$2 "FFI.mk_tuple" (FFI.mk_tuple) [  (mk_ffi ~$2 "FFI.mk_cons" (FFI.mk_cons) [  (mk_var "new_sh" (T_sh)); (mk_var "shares" (T_cons ("Prims.list", [ (T_sh);]))); ] (fun x -> mk_v_opaque x (slice_list Semantics.slice_v_ffi) (compose_lists Semantics.compose_vals_ffi) (slice_list_sps Semantics.slice_v_sps_ffi))); (mk_var "c" (T_cons ("Prims.int", []))); ] (fun x -> mk_v_opaque x ((slice_tuple (slice_list Semantics.slice_v_ffi)) slice_id) ((compose_tuples (compose_lists Semantics.compose_vals_ffi)) compose_ids) ((slice_tuple_sps (slice_list_sps Semantics.slice_v_sps_ffi)) slice_id_sps))))) (mk_ffi ~$2 "FFI.mk_tuple" (FFI.mk_tuple) [  (mk_var "shares" (T_cons ("Prims.list", [ (T_sh);]))); (mk_var "max" (T_cons ("Prims.int", []))); ] (fun x -> mk_v_opaque x ((slice_tuple (slice_list Semantics.slice_v_ffi)) slice_id) ((compose_tuples (compose_lists Semantics.compose_vals_ffi)) compose_ids) ((slice_tuple_sps (slice_list_sps Semantics.slice_v_sps_ffi)) slice_id_sps)))))))))))))))))))));
]
