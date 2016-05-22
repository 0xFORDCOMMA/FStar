
open Prims
# 42 "FStar.TypeChecker.Normalize.fst"
type step =
| WHNF
| Inline
| UnfoldUntil of FStar_Syntax_Syntax.delta_depth
| Beta
| BetaUVars
| Simplify
| EraseUniverses
| AllowUnboundUniverses
| DeltaComp
| SNComp
| Eta
| EtaArgs
| Unmeta
| Unlabel 
 and steps =
step Prims.list

# 43 "FStar.TypeChecker.Normalize.fst"
let is_WHNF = (fun _discr_ -> (match (_discr_) with
| WHNF (_) -> begin
true
end
| _ -> begin
false
end))

# 44 "FStar.TypeChecker.Normalize.fst"
let is_Inline = (fun _discr_ -> (match (_discr_) with
| Inline (_) -> begin
true
end
| _ -> begin
false
end))

# 45 "FStar.TypeChecker.Normalize.fst"
let is_UnfoldUntil = (fun _discr_ -> (match (_discr_) with
| UnfoldUntil (_) -> begin
true
end
| _ -> begin
false
end))

# 46 "FStar.TypeChecker.Normalize.fst"
let is_Beta = (fun _discr_ -> (match (_discr_) with
| Beta (_) -> begin
true
end
| _ -> begin
false
end))

# 47 "FStar.TypeChecker.Normalize.fst"
let is_BetaUVars = (fun _discr_ -> (match (_discr_) with
| BetaUVars (_) -> begin
true
end
| _ -> begin
false
end))

# 48 "FStar.TypeChecker.Normalize.fst"
let is_Simplify = (fun _discr_ -> (match (_discr_) with
| Simplify (_) -> begin
true
end
| _ -> begin
false
end))

# 49 "FStar.TypeChecker.Normalize.fst"
let is_EraseUniverses = (fun _discr_ -> (match (_discr_) with
| EraseUniverses (_) -> begin
true
end
| _ -> begin
false
end))

# 50 "FStar.TypeChecker.Normalize.fst"
let is_AllowUnboundUniverses = (fun _discr_ -> (match (_discr_) with
| AllowUnboundUniverses (_) -> begin
true
end
| _ -> begin
false
end))

# 52 "FStar.TypeChecker.Normalize.fst"
let is_DeltaComp = (fun _discr_ -> (match (_discr_) with
| DeltaComp (_) -> begin
true
end
| _ -> begin
false
end))

# 53 "FStar.TypeChecker.Normalize.fst"
let is_SNComp = (fun _discr_ -> (match (_discr_) with
| SNComp (_) -> begin
true
end
| _ -> begin
false
end))

# 54 "FStar.TypeChecker.Normalize.fst"
let is_Eta = (fun _discr_ -> (match (_discr_) with
| Eta (_) -> begin
true
end
| _ -> begin
false
end))

# 55 "FStar.TypeChecker.Normalize.fst"
let is_EtaArgs = (fun _discr_ -> (match (_discr_) with
| EtaArgs (_) -> begin
true
end
| _ -> begin
false
end))

# 56 "FStar.TypeChecker.Normalize.fst"
let is_Unmeta = (fun _discr_ -> (match (_discr_) with
| Unmeta (_) -> begin
true
end
| _ -> begin
false
end))

# 57 "FStar.TypeChecker.Normalize.fst"
let is_Unlabel = (fun _discr_ -> (match (_discr_) with
| Unlabel (_) -> begin
true
end
| _ -> begin
false
end))

# 45 "FStar.TypeChecker.Normalize.fst"
let ___UnfoldUntil____0 = (fun projectee -> (match (projectee) with
| UnfoldUntil (_53_8) -> begin
_53_8
end))

# 61 "FStar.TypeChecker.Normalize.fst"
type closure =
| Clos of (env * FStar_Syntax_Syntax.term * (env * FStar_Syntax_Syntax.term) FStar_Syntax_Syntax.memo)
| Univ of FStar_Syntax_Syntax.universe
| Dummy 
 and env =
closure Prims.list

# 62 "FStar.TypeChecker.Normalize.fst"
let is_Clos = (fun _discr_ -> (match (_discr_) with
| Clos (_) -> begin
true
end
| _ -> begin
false
end))

# 63 "FStar.TypeChecker.Normalize.fst"
let is_Univ = (fun _discr_ -> (match (_discr_) with
| Univ (_) -> begin
true
end
| _ -> begin
false
end))

# 64 "FStar.TypeChecker.Normalize.fst"
let is_Dummy = (fun _discr_ -> (match (_discr_) with
| Dummy (_) -> begin
true
end
| _ -> begin
false
end))

# 62 "FStar.TypeChecker.Normalize.fst"
let ___Clos____0 = (fun projectee -> (match (projectee) with
| Clos (_53_11) -> begin
_53_11
end))

# 63 "FStar.TypeChecker.Normalize.fst"
let ___Univ____0 = (fun projectee -> (match (projectee) with
| Univ (_53_14) -> begin
_53_14
end))

# 67 "FStar.TypeChecker.Normalize.fst"
let closure_to_string : closure  ->  Prims.string = (fun _53_1 -> (match (_53_1) with
| Clos (_53_17, t, _53_20) -> begin
(FStar_Syntax_Print.term_to_string t)
end
| _53_24 -> begin
"dummy"
end))

# 71 "FStar.TypeChecker.Normalize.fst"
type cfg =
{steps : steps; tcenv : FStar_TypeChecker_Env.env; delta_level : FStar_TypeChecker_Env.delta_level}

# 71 "FStar.TypeChecker.Normalize.fst"
let is_Mkcfg : cfg  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkcfg"))))

# 77 "FStar.TypeChecker.Normalize.fst"
type branches =
(FStar_Syntax_Syntax.pat * FStar_Syntax_Syntax.term Prims.option * FStar_Syntax_Syntax.term) Prims.list

# 79 "FStar.TypeChecker.Normalize.fst"
type stack_elt =
| Arg of (closure * FStar_Syntax_Syntax.aqual * FStar_Range.range)
| UnivArgs of (FStar_Syntax_Syntax.universe Prims.list * FStar_Range.range)
| MemoLazy of (env * FStar_Syntax_Syntax.term) FStar_Syntax_Syntax.memo
| Match of (env * branches * FStar_Range.range)
| Abs of (env * FStar_Syntax_Syntax.binders * env * (FStar_Syntax_Syntax.lcomp, FStar_Ident.lident) FStar_Util.either Prims.option * FStar_Range.range)
| App of (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.aqual * FStar_Range.range)
| Meta of (FStar_Syntax_Syntax.metadata * FStar_Range.range)

# 80 "FStar.TypeChecker.Normalize.fst"
let is_Arg = (fun _discr_ -> (match (_discr_) with
| Arg (_) -> begin
true
end
| _ -> begin
false
end))

# 81 "FStar.TypeChecker.Normalize.fst"
let is_UnivArgs = (fun _discr_ -> (match (_discr_) with
| UnivArgs (_) -> begin
true
end
| _ -> begin
false
end))

# 82 "FStar.TypeChecker.Normalize.fst"
let is_MemoLazy = (fun _discr_ -> (match (_discr_) with
| MemoLazy (_) -> begin
true
end
| _ -> begin
false
end))

# 83 "FStar.TypeChecker.Normalize.fst"
let is_Match = (fun _discr_ -> (match (_discr_) with
| Match (_) -> begin
true
end
| _ -> begin
false
end))

# 84 "FStar.TypeChecker.Normalize.fst"
let is_Abs = (fun _discr_ -> (match (_discr_) with
| Abs (_) -> begin
true
end
| _ -> begin
false
end))

# 85 "FStar.TypeChecker.Normalize.fst"
let is_App = (fun _discr_ -> (match (_discr_) with
| App (_) -> begin
true
end
| _ -> begin
false
end))

# 86 "FStar.TypeChecker.Normalize.fst"
let is_Meta = (fun _discr_ -> (match (_discr_) with
| Meta (_) -> begin
true
end
| _ -> begin
false
end))

# 80 "FStar.TypeChecker.Normalize.fst"
let ___Arg____0 = (fun projectee -> (match (projectee) with
| Arg (_53_31) -> begin
_53_31
end))

# 81 "FStar.TypeChecker.Normalize.fst"
let ___UnivArgs____0 = (fun projectee -> (match (projectee) with
| UnivArgs (_53_34) -> begin
_53_34
end))

# 82 "FStar.TypeChecker.Normalize.fst"
let ___MemoLazy____0 = (fun projectee -> (match (projectee) with
| MemoLazy (_53_37) -> begin
_53_37
end))

# 83 "FStar.TypeChecker.Normalize.fst"
let ___Match____0 = (fun projectee -> (match (projectee) with
| Match (_53_40) -> begin
_53_40
end))

# 84 "FStar.TypeChecker.Normalize.fst"
let ___Abs____0 = (fun projectee -> (match (projectee) with
| Abs (_53_43) -> begin
_53_43
end))

# 85 "FStar.TypeChecker.Normalize.fst"
let ___App____0 = (fun projectee -> (match (projectee) with
| App (_53_46) -> begin
_53_46
end))

# 86 "FStar.TypeChecker.Normalize.fst"
let ___Meta____0 = (fun projectee -> (match (projectee) with
| Meta (_53_49) -> begin
_53_49
end))

# 88 "FStar.TypeChecker.Normalize.fst"
type stack =
stack_elt Prims.list

# 101 "FStar.TypeChecker.Normalize.fst"
let mk = (fun t r -> (FStar_Syntax_Syntax.mk t None r))

# 102 "FStar.TypeChecker.Normalize.fst"
let set_memo = (fun r t -> (match ((FStar_ST.read r)) with
| Some (_53_55) -> begin
(FStar_All.failwith "Unexpected set_memo: thunk already evaluated")
end
| None -> begin
(FStar_ST.op_Colon_Equals r (Some (t)))
end))

# 107 "FStar.TypeChecker.Normalize.fst"
let env_to_string : closure Prims.list  ->  Prims.string = (fun env -> (let _142_173 = (FStar_List.map closure_to_string env)
in (FStar_All.pipe_right _142_173 (FStar_String.concat "; "))))

# 110 "FStar.TypeChecker.Normalize.fst"
let stack_elt_to_string : stack_elt  ->  Prims.string = (fun _53_2 -> (match (_53_2) with
| Arg (c, _53_62, _53_64) -> begin
(closure_to_string c)
end
| MemoLazy (_53_68) -> begin
"MemoLazy"
end
| Abs (_53_71, bs, _53_74, _53_76, _53_78) -> begin
(let _142_176 = (FStar_All.pipe_left FStar_Util.string_of_int (FStar_List.length bs))
in (FStar_Util.format1 "Abs %s" _142_176))
end
| _53_82 -> begin
"Match"
end))

# 116 "FStar.TypeChecker.Normalize.fst"
let stack_to_string : stack_elt Prims.list  ->  Prims.string = (fun s -> (let _142_179 = (FStar_List.map stack_elt_to_string s)
in (FStar_All.pipe_right _142_179 (FStar_String.concat "; "))))

# 119 "FStar.TypeChecker.Normalize.fst"
let log : cfg  ->  (Prims.unit  ->  Prims.unit)  ->  Prims.unit = (fun cfg f -> if (FStar_TypeChecker_Env.debug cfg.tcenv (FStar_Options.Other ("Norm"))) then begin
(f ())
end else begin
()
end)

# 124 "FStar.TypeChecker.Normalize.fst"
let is_empty = (fun _53_3 -> (match (_53_3) with
| [] -> begin
true
end
| _53_89 -> begin
false
end))

# 128 "FStar.TypeChecker.Normalize.fst"
let lookup_bvar = (fun env x -> try
(match (()) with
| () -> begin
(FStar_List.nth env x.FStar_Syntax_Syntax.index)
end)
with
| _53_96 -> begin
(let _142_195 = (let _142_194 = (FStar_Syntax_Print.db_to_string x)
in (FStar_Util.format1 "Failed to find %s\n" _142_194))
in (FStar_All.failwith _142_195))
end)

# 132 "FStar.TypeChecker.Normalize.fst"
let rec unfold_effect_abbrev : FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp_typ = (fun env comp -> (
# 133 "FStar.TypeChecker.Normalize.fst"
let c = (FStar_Syntax_Util.comp_to_comp_typ comp)
in (match ((let _142_200 = (env.FStar_TypeChecker_Env.universe_of env c.FStar_Syntax_Syntax.result_typ)
in (FStar_TypeChecker_Env.lookup_effect_abbrev env _142_200 c.FStar_Syntax_Syntax.effect_name))) with
| None -> begin
c
end
| Some (binders, cdef) -> begin
(
# 137 "FStar.TypeChecker.Normalize.fst"
let _53_109 = (FStar_Syntax_Subst.open_comp binders cdef)
in (match (_53_109) with
| (binders, cdef) -> begin
(
# 138 "FStar.TypeChecker.Normalize.fst"
let inst = (let _142_204 = (let _142_203 = (FStar_Syntax_Syntax.as_arg c.FStar_Syntax_Syntax.result_typ)
in (_142_203)::c.FStar_Syntax_Syntax.effect_args)
in (FStar_List.map2 (fun _53_113 _53_117 -> (match ((_53_113, _53_117)) with
| ((x, _53_112), (t, _53_116)) -> begin
FStar_Syntax_Syntax.Name2Term ((x, t))
end)) binders _142_204))
in (
# 139 "FStar.TypeChecker.Normalize.fst"
let c1 = (FStar_Syntax_Subst.subst_comp (FStar_Syntax_Syntax.Instantiation (inst)) cdef)
in (
# 140 "FStar.TypeChecker.Normalize.fst"
let c = (FStar_All.pipe_right (
# 140 "FStar.TypeChecker.Normalize.fst"
let _53_120 = (FStar_Syntax_Util.comp_to_comp_typ c1)
in {FStar_Syntax_Syntax.effect_name = _53_120.FStar_Syntax_Syntax.effect_name; FStar_Syntax_Syntax.result_typ = _53_120.FStar_Syntax_Syntax.result_typ; FStar_Syntax_Syntax.effect_args = _53_120.FStar_Syntax_Syntax.effect_args; FStar_Syntax_Syntax.flags = c.FStar_Syntax_Syntax.flags}) FStar_Syntax_Syntax.mk_Comp)
in (unfold_effect_abbrev env c))))
end))
end)))

# 151 "FStar.TypeChecker.Normalize.fst"
let norm_universe : cfg  ->  closure Prims.list  ->  FStar_Syntax_Syntax.universe  ->  FStar_Syntax_Syntax.universe = (fun cfg env u -> (
# 152 "FStar.TypeChecker.Normalize.fst"
let norm_univs = (fun us -> (
# 153 "FStar.TypeChecker.Normalize.fst"
let us = (FStar_Util.sort_with FStar_Syntax_Util.compare_univs us)
in (
# 158 "FStar.TypeChecker.Normalize.fst"
let _53_141 = (FStar_List.fold_left (fun _53_132 u -> (match (_53_132) with
| (cur_kernel, cur_max, out) -> begin
(
# 160 "FStar.TypeChecker.Normalize.fst"
let _53_136 = (FStar_Syntax_Util.univ_kernel u)
in (match (_53_136) with
| (k_u, n) -> begin
if (FStar_Syntax_Util.eq_univs cur_kernel k_u) then begin
(cur_kernel, u, out)
end else begin
(k_u, u, (cur_max)::out)
end
end))
end)) (FStar_Syntax_Syntax.U_zero, FStar_Syntax_Syntax.U_zero, []) us)
in (match (_53_141) with
| (_53_138, u, out) -> begin
(FStar_List.rev ((u)::out))
end))))
in (
# 171 "FStar.TypeChecker.Normalize.fst"
let rec aux = (fun u -> (
# 172 "FStar.TypeChecker.Normalize.fst"
let u = (FStar_Syntax_Subst.compress_univ u)
in (match (u) with
| FStar_Syntax_Syntax.U_bvar (x) -> begin
try
(match (()) with
| () -> begin
(match ((FStar_List.nth env x)) with
| Univ (u) -> begin
(u)::[]
end
| Dummy -> begin
(u)::[]
end
| _53_158 -> begin
(FStar_All.failwith "Impossible: universe variable bound to a term")
end)
end)
with
| _53_151 -> begin
if (FStar_All.pipe_right cfg.steps (FStar_List.contains AllowUnboundUniverses)) then begin
(FStar_Syntax_Syntax.U_unknown)::[]
end else begin
(FStar_All.failwith "Universe variable not found")
end
end
end
| (FStar_Syntax_Syntax.U_zero) | (FStar_Syntax_Syntax.U_unif (_)) | (FStar_Syntax_Syntax.U_name (_)) | (FStar_Syntax_Syntax.U_unknown) -> begin
(u)::[]
end
| FStar_Syntax_Syntax.U_max ([]) -> begin
(FStar_Syntax_Syntax.U_zero)::[]
end
| FStar_Syntax_Syntax.U_max (us) -> begin
(let _142_219 = (FStar_List.collect aux us)
in (FStar_All.pipe_right _142_219 norm_univs))
end
| FStar_Syntax_Syntax.U_succ (u) -> begin
(let _142_221 = (aux u)
in (FStar_List.map (fun _142_220 -> FStar_Syntax_Syntax.U_succ (_142_220)) _142_221))
end)))
in if (FStar_All.pipe_right cfg.steps (FStar_List.contains EraseUniverses)) then begin
FStar_Syntax_Syntax.U_unknown
end else begin
(match ((aux u)) with
| ([]) | (FStar_Syntax_Syntax.U_zero::[]) -> begin
FStar_Syntax_Syntax.U_zero
end
| FStar_Syntax_Syntax.U_zero::u::[] -> begin
u
end
| FStar_Syntax_Syntax.U_zero::us -> begin
FStar_Syntax_Syntax.U_max (us)
end
| u::[] -> begin
u
end
| us -> begin
FStar_Syntax_Syntax.U_max (us)
end)
end)))

# 210 "FStar.TypeChecker.Normalize.fst"
let rec closure_as_term : cfg  ->  closure Prims.list  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun cfg env t -> (
# 211 "FStar.TypeChecker.Normalize.fst"
let _53_189 = (log cfg (fun _53_188 -> (match (()) with
| () -> begin
(let _142_245 = (FStar_Syntax_Print.tag_of_term t)
in (let _142_244 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.print2 ">>> %s Closure_as_term %s\n" _142_245 _142_244)))
end)))
in (match (env) with
| [] when (not ((FStar_All.pipe_right cfg.steps (FStar_List.contains BetaUVars)))) -> begin
t
end
| _53_193 -> begin
(
# 215 "FStar.TypeChecker.Normalize.fst"
let t = (FStar_Syntax_Subst.compress t)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_delayed (_53_196) -> begin
(FStar_All.failwith "Impossible")
end
| (FStar_Syntax_Syntax.Tm_unknown) | (FStar_Syntax_Syntax.Tm_constant (_)) | (FStar_Syntax_Syntax.Tm_name (_)) | (FStar_Syntax_Syntax.Tm_fvar (_)) -> begin
t
end
| FStar_Syntax_Syntax.Tm_uvar (_53_209) -> begin
t
end
| FStar_Syntax_Syntax.Tm_type (u) -> begin
(let _142_250 = (let _142_249 = (norm_universe cfg env u)
in FStar_Syntax_Syntax.Tm_type (_142_249))
in (mk _142_250 t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_uinst (t, us) -> begin
(let _142_251 = (FStar_List.map (norm_universe cfg env) us)
in (FStar_Syntax_Syntax.mk_Tm_uinst t _142_251))
end
| FStar_Syntax_Syntax.Tm_bvar (x) -> begin
(match ((lookup_bvar env x)) with
| Univ (_53_220) -> begin
(FStar_All.failwith "Impossible: term variable is bound to a universe")
end
| Dummy -> begin
t
end
| Clos (env, t0, r) -> begin
(closure_as_term cfg env t0)
end)
end
| FStar_Syntax_Syntax.Tm_app (head, args) -> begin
(match (head.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_uvar (_53_233) when (FStar_All.pipe_right cfg.steps (FStar_List.contains BetaUVars)) -> begin
(
# 243 "FStar.TypeChecker.Normalize.fst"
let head = (closure_as_term_delayed cfg env head)
in (match (head.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_abs (binders, body, _53_239) when ((FStar_List.length binders) = (FStar_List.length args)) -> begin
(let _142_257 = (FStar_List.fold_left (fun env' _53_246 -> (match (_53_246) with
| (t, _53_245) -> begin
(let _142_256 = (let _142_255 = (let _142_254 = (FStar_Util.mk_ref None)
in (env, t, _142_254))
in Clos (_142_255))
in (_142_256)::env')
end)) env args)
in (closure_as_term cfg _142_257 body))
end
| _53_248 -> begin
(mk (FStar_Syntax_Syntax.Tm_app ((head, args))) t.FStar_Syntax_Syntax.pos)
end))
end
| _53_250 -> begin
(
# 250 "FStar.TypeChecker.Normalize.fst"
let head = (closure_as_term_delayed cfg env head)
in (
# 251 "FStar.TypeChecker.Normalize.fst"
let args = (closures_as_args_delayed cfg env args)
in (mk (FStar_Syntax_Syntax.Tm_app ((head, args))) t.FStar_Syntax_Syntax.pos)))
end)
end
| FStar_Syntax_Syntax.Tm_abs (bs, body, lopt) -> begin
(
# 256 "FStar.TypeChecker.Normalize.fst"
let _53_260 = (closures_as_binders_delayed cfg env bs)
in (match (_53_260) with
| (bs, env) -> begin
(
# 257 "FStar.TypeChecker.Normalize.fst"
let body = (closure_as_term_delayed cfg env body)
in (let _142_260 = (let _142_259 = (let _142_258 = (close_lcomp_opt cfg env lopt)
in (bs, body, _142_258))
in FStar_Syntax_Syntax.Tm_abs (_142_259))
in (mk _142_260 t.FStar_Syntax_Syntax.pos)))
end))
end
| FStar_Syntax_Syntax.Tm_arrow (bs, c) -> begin
(
# 261 "FStar.TypeChecker.Normalize.fst"
let _53_268 = (closures_as_binders_delayed cfg env bs)
in (match (_53_268) with
| (bs, env) -> begin
(
# 262 "FStar.TypeChecker.Normalize.fst"
let c = (close_comp cfg env c)
in (mk (FStar_Syntax_Syntax.Tm_arrow ((bs, c))) t.FStar_Syntax_Syntax.pos))
end))
end
| FStar_Syntax_Syntax.Tm_refine (x, phi) -> begin
(
# 266 "FStar.TypeChecker.Normalize.fst"
let _53_276 = (let _142_262 = (let _142_261 = (FStar_Syntax_Syntax.mk_binder x)
in (_142_261)::[])
in (closures_as_binders_delayed cfg env _142_262))
in (match (_53_276) with
| (x, env) -> begin
(
# 267 "FStar.TypeChecker.Normalize.fst"
let phi = (closure_as_term_delayed cfg env phi)
in (let _142_266 = (let _142_265 = (let _142_264 = (let _142_263 = (FStar_List.hd x)
in (FStar_All.pipe_right _142_263 Prims.fst))
in (_142_264, phi))
in FStar_Syntax_Syntax.Tm_refine (_142_265))
in (mk _142_266 t.FStar_Syntax_Syntax.pos)))
end))
end
| FStar_Syntax_Syntax.Tm_ascribed (t1, FStar_Util.Inl (t2), lopt) -> begin
(let _142_272 = (let _142_271 = (let _142_270 = (closure_as_term_delayed cfg env t1)
in (let _142_269 = (let _142_268 = (closure_as_term_delayed cfg env t2)
in (FStar_All.pipe_left (fun _142_267 -> FStar_Util.Inl (_142_267)) _142_268))
in (_142_270, _142_269, lopt)))
in FStar_Syntax_Syntax.Tm_ascribed (_142_271))
in (mk _142_272 t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_ascribed (t1, FStar_Util.Inr (c), lopt) -> begin
(let _142_278 = (let _142_277 = (let _142_276 = (closure_as_term_delayed cfg env t1)
in (let _142_275 = (let _142_274 = (close_comp cfg env c)
in (FStar_All.pipe_left (fun _142_273 -> FStar_Util.Inr (_142_273)) _142_274))
in (_142_276, _142_275, lopt)))
in FStar_Syntax_Syntax.Tm_ascribed (_142_277))
in (mk _142_278 t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_meta (t', FStar_Syntax_Syntax.Meta_pattern (args)) -> begin
(let _142_283 = (let _142_282 = (let _142_281 = (closure_as_term_delayed cfg env t')
in (let _142_280 = (let _142_279 = (FStar_All.pipe_right args (FStar_List.map (closures_as_args_delayed cfg env)))
in FStar_Syntax_Syntax.Meta_pattern (_142_279))
in (_142_281, _142_280)))
in FStar_Syntax_Syntax.Tm_meta (_142_282))
in (mk _142_283 t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_meta (t', m) -> begin
(let _142_286 = (let _142_285 = (let _142_284 = (closure_as_term_delayed cfg env t')
in (_142_284, m))
in FStar_Syntax_Syntax.Tm_meta (_142_285))
in (mk _142_286 t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_let ((false, lb::[]), body) -> begin
(
# 284 "FStar.TypeChecker.Normalize.fst"
let env0 = env
in (
# 285 "FStar.TypeChecker.Normalize.fst"
let env = (FStar_List.fold_left (fun env _53_308 -> (Dummy)::env) env lb.FStar_Syntax_Syntax.lbunivs)
in (
# 286 "FStar.TypeChecker.Normalize.fst"
let typ = (closure_as_term_delayed cfg env lb.FStar_Syntax_Syntax.lbtyp)
in (
# 287 "FStar.TypeChecker.Normalize.fst"
let def = (closure_as_term cfg env lb.FStar_Syntax_Syntax.lbdef)
in (
# 288 "FStar.TypeChecker.Normalize.fst"
let body = (match (lb.FStar_Syntax_Syntax.lbname) with
| FStar_Util.Inr (_53_314) -> begin
body
end
| FStar_Util.Inl (_53_317) -> begin
(closure_as_term cfg ((Dummy)::env0) body)
end)
in (
# 291 "FStar.TypeChecker.Normalize.fst"
let lb = (
# 291 "FStar.TypeChecker.Normalize.fst"
let _53_320 = lb
in {FStar_Syntax_Syntax.lbname = _53_320.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = _53_320.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = typ; FStar_Syntax_Syntax.lbeff = _53_320.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = def})
in (mk (FStar_Syntax_Syntax.Tm_let (((false, (lb)::[]), body))) t.FStar_Syntax_Syntax.pos)))))))
end
| FStar_Syntax_Syntax.Tm_let ((_53_324, lbs), body) -> begin
(
# 295 "FStar.TypeChecker.Normalize.fst"
let norm_one_lb = (fun env lb -> (
# 296 "FStar.TypeChecker.Normalize.fst"
let env_univs = (FStar_List.fold_right (fun _53_333 env -> (Dummy)::env) lb.FStar_Syntax_Syntax.lbunivs env)
in (
# 297 "FStar.TypeChecker.Normalize.fst"
let env = if (FStar_Syntax_Syntax.is_top_level lbs) then begin
env_univs
end else begin
(FStar_List.fold_right (fun _53_337 env -> (Dummy)::env) lbs env_univs)
end
in (
# 300 "FStar.TypeChecker.Normalize.fst"
let _53_341 = lb
in (let _142_298 = (closure_as_term cfg env_univs lb.FStar_Syntax_Syntax.lbtyp)
in (let _142_297 = (closure_as_term cfg env lb.FStar_Syntax_Syntax.lbdef)
in {FStar_Syntax_Syntax.lbname = _53_341.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = _53_341.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = _142_298; FStar_Syntax_Syntax.lbeff = _53_341.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = _142_297}))))))
in (
# 302 "FStar.TypeChecker.Normalize.fst"
let lbs = (FStar_All.pipe_right lbs (FStar_List.map (norm_one_lb env)))
in (
# 303 "FStar.TypeChecker.Normalize.fst"
let body = (
# 304 "FStar.TypeChecker.Normalize.fst"
let body_env = (FStar_List.fold_right (fun _53_344 env -> (Dummy)::env) lbs env)
in (closure_as_term cfg env body))
in (mk (FStar_Syntax_Syntax.Tm_let (((true, lbs), body))) t.FStar_Syntax_Syntax.pos))))
end
| FStar_Syntax_Syntax.Tm_match (head, branches) -> begin
(
# 309 "FStar.TypeChecker.Normalize.fst"
let head = (closure_as_term cfg env head)
in (
# 310 "FStar.TypeChecker.Normalize.fst"
let norm_one_branch = (fun env _53_359 -> (match (_53_359) with
| (pat, w_opt, tm) -> begin
(
# 311 "FStar.TypeChecker.Normalize.fst"
let rec norm_pat = (fun env p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_constant (_53_364) -> begin
(p, env)
end
| FStar_Syntax_Syntax.Pat_disj ([]) -> begin
(FStar_All.failwith "Impossible")
end
| FStar_Syntax_Syntax.Pat_disj (hd::tl) -> begin
(
# 315 "FStar.TypeChecker.Normalize.fst"
let _53_374 = (norm_pat env hd)
in (match (_53_374) with
| (hd, env') -> begin
(
# 316 "FStar.TypeChecker.Normalize.fst"
let tl = (FStar_All.pipe_right tl (FStar_List.map (fun p -> (let _142_310 = (norm_pat env p)
in (Prims.fst _142_310)))))
in ((
# 317 "FStar.TypeChecker.Normalize.fst"
let _53_377 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_disj ((hd)::tl); FStar_Syntax_Syntax.ty = _53_377.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _53_377.FStar_Syntax_Syntax.p}), env'))
end))
end
| FStar_Syntax_Syntax.Pat_cons (fv, pats) -> begin
(
# 319 "FStar.TypeChecker.Normalize.fst"
let _53_394 = (FStar_All.pipe_right pats (FStar_List.fold_left (fun _53_385 _53_388 -> (match ((_53_385, _53_388)) with
| ((pats, env), (p, b)) -> begin
(
# 320 "FStar.TypeChecker.Normalize.fst"
let _53_391 = (norm_pat env p)
in (match (_53_391) with
| (p, env) -> begin
(((p, b))::pats, env)
end))
end)) ([], env)))
in (match (_53_394) with
| (pats, env) -> begin
((
# 322 "FStar.TypeChecker.Normalize.fst"
let _53_395 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_cons ((fv, (FStar_List.rev pats))); FStar_Syntax_Syntax.ty = _53_395.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _53_395.FStar_Syntax_Syntax.p}), env)
end))
end
| FStar_Syntax_Syntax.Pat_var (x) -> begin
(
# 324 "FStar.TypeChecker.Normalize.fst"
let x = (
# 324 "FStar.TypeChecker.Normalize.fst"
let _53_399 = x
in (let _142_313 = (closure_as_term cfg env x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _53_399.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _53_399.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _142_313}))
in ((
# 325 "FStar.TypeChecker.Normalize.fst"
let _53_402 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var (x); FStar_Syntax_Syntax.ty = _53_402.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _53_402.FStar_Syntax_Syntax.p}), (Dummy)::env))
end
| FStar_Syntax_Syntax.Pat_wild (x) -> begin
(
# 327 "FStar.TypeChecker.Normalize.fst"
let x = (
# 327 "FStar.TypeChecker.Normalize.fst"
let _53_406 = x
in (let _142_314 = (closure_as_term cfg env x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _53_406.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _53_406.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _142_314}))
in ((
# 328 "FStar.TypeChecker.Normalize.fst"
let _53_409 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild (x); FStar_Syntax_Syntax.ty = _53_409.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _53_409.FStar_Syntax_Syntax.p}), (Dummy)::env))
end
| FStar_Syntax_Syntax.Pat_dot_term (x, t) -> begin
(
# 330 "FStar.TypeChecker.Normalize.fst"
let x = (
# 330 "FStar.TypeChecker.Normalize.fst"
let _53_415 = x
in (let _142_315 = (closure_as_term cfg env x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _53_415.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _53_415.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _142_315}))
in (
# 331 "FStar.TypeChecker.Normalize.fst"
let t = (closure_as_term cfg env t)
in ((
# 332 "FStar.TypeChecker.Normalize.fst"
let _53_419 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_dot_term ((x, t)); FStar_Syntax_Syntax.ty = _53_419.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _53_419.FStar_Syntax_Syntax.p}), env)))
end))
in (
# 333 "FStar.TypeChecker.Normalize.fst"
let _53_423 = (norm_pat env pat)
in (match (_53_423) with
| (pat, env) -> begin
(
# 334 "FStar.TypeChecker.Normalize.fst"
let w_opt = (match (w_opt) with
| None -> begin
None
end
| Some (w) -> begin
(let _142_316 = (closure_as_term cfg env w)
in Some (_142_316))
end)
in (
# 337 "FStar.TypeChecker.Normalize.fst"
let tm = (closure_as_term cfg env tm)
in (pat, w_opt, tm)))
end)))
end))
in (let _142_319 = (let _142_318 = (let _142_317 = (FStar_All.pipe_right branches (FStar_List.map (norm_one_branch env)))
in (head, _142_317))
in FStar_Syntax_Syntax.Tm_match (_142_318))
in (mk _142_319 t.FStar_Syntax_Syntax.pos))))
end))
end)))
and closure_as_term_delayed : cfg  ->  closure Prims.list  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun cfg env t -> (match (env) with
| _53_433 when (FStar_All.pipe_right cfg.steps (FStar_List.contains BetaUVars)) -> begin
(closure_as_term cfg env t)
end
| [] -> begin
t
end
| _53_436 -> begin
(closure_as_term cfg env t)
end))
and closures_as_args_delayed : cfg  ->  closure Prims.list  ->  FStar_Syntax_Syntax.args  ->  FStar_Syntax_Syntax.args = (fun cfg env args -> (match (env) with
| [] when (not ((FStar_All.pipe_right cfg.steps (FStar_List.contains BetaUVars)))) -> begin
args
end
| _53_442 -> begin
(FStar_List.map (fun _53_445 -> (match (_53_445) with
| (x, imp) -> begin
(let _142_327 = (closure_as_term_delayed cfg env x)
in (_142_327, imp))
end)) args)
end))
and closures_as_binders_delayed : cfg  ->  closure Prims.list  ->  FStar_Syntax_Syntax.binders  ->  (FStar_Syntax_Syntax.binders * closure Prims.list) = (fun cfg env bs -> (
# 354 "FStar.TypeChecker.Normalize.fst"
let _53_461 = (FStar_All.pipe_right bs (FStar_List.fold_left (fun _53_451 _53_454 -> (match ((_53_451, _53_454)) with
| ((env, out), (b, imp)) -> begin
(
# 355 "FStar.TypeChecker.Normalize.fst"
let b = (
# 355 "FStar.TypeChecker.Normalize.fst"
let _53_455 = b
in (let _142_333 = (closure_as_term_delayed cfg env b.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _53_455.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _53_455.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _142_333}))
in (
# 356 "FStar.TypeChecker.Normalize.fst"
let env = (Dummy)::env
in (env, ((b, imp))::out)))
end)) (env, [])))
in (match (_53_461) with
| (env, bs) -> begin
((FStar_List.rev bs), env)
end)))
and close_comp : cfg  ->  closure Prims.list  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun cfg env c -> (match (env) with
| [] when (FStar_All.pipe_right cfg.steps (FStar_List.contains BetaUVars)) -> begin
c
end
| _53_467 -> begin
(match (c.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Total (t) -> begin
(let _142_337 = (closure_as_term_delayed cfg env t)
in (FStar_Syntax_Syntax.mk_Total _142_337))
end
| FStar_Syntax_Syntax.GTotal (t) -> begin
(let _142_338 = (closure_as_term_delayed cfg env t)
in (FStar_Syntax_Syntax.mk_GTotal _142_338))
end
| FStar_Syntax_Syntax.Comp (c) -> begin
(
# 368 "FStar.TypeChecker.Normalize.fst"
let rt = (closure_as_term_delayed cfg env c.FStar_Syntax_Syntax.result_typ)
in (
# 369 "FStar.TypeChecker.Normalize.fst"
let args = (closures_as_args_delayed cfg env c.FStar_Syntax_Syntax.effect_args)
in (
# 370 "FStar.TypeChecker.Normalize.fst"
let flags = (FStar_All.pipe_right c.FStar_Syntax_Syntax.flags (FStar_List.map (fun _53_4 -> (match (_53_4) with
| FStar_Syntax_Syntax.DECREASES (t) -> begin
(let _142_340 = (closure_as_term_delayed cfg env t)
in FStar_Syntax_Syntax.DECREASES (_142_340))
end
| f -> begin
f
end))))
in (FStar_Syntax_Syntax.mk_Comp (
# 373 "FStar.TypeChecker.Normalize.fst"
let _53_481 = c
in {FStar_Syntax_Syntax.effect_name = _53_481.FStar_Syntax_Syntax.effect_name; FStar_Syntax_Syntax.result_typ = rt; FStar_Syntax_Syntax.effect_args = args; FStar_Syntax_Syntax.flags = flags})))))
end)
end))
and close_lcomp_opt : cfg  ->  closure Prims.list  ->  (FStar_Syntax_Syntax.lcomp, FStar_Ident.lident) FStar_Util.either Prims.option  ->  (FStar_Syntax_Syntax.lcomp, FStar_Ident.lident) FStar_Util.either Prims.option = (fun cfg env lopt -> (match (lopt) with
| Some (FStar_Util.Inl (lc)) -> begin
(let _142_348 = (let _142_347 = (
# 378 "FStar.TypeChecker.Normalize.fst"
let _53_489 = lc
in (let _142_346 = (closure_as_term_delayed cfg env lc.FStar_Syntax_Syntax.res_typ)
in {FStar_Syntax_Syntax.eff_name = _53_489.FStar_Syntax_Syntax.eff_name; FStar_Syntax_Syntax.res_typ = _142_346; FStar_Syntax_Syntax.cflags = _53_489.FStar_Syntax_Syntax.cflags; FStar_Syntax_Syntax.comp = (fun _53_491 -> (match (()) with
| () -> begin
(let _142_345 = (lc.FStar_Syntax_Syntax.comp ())
in (close_comp cfg env _142_345))
end))}))
in FStar_Util.Inl (_142_347))
in Some (_142_348))
end
| _53_493 -> begin
lopt
end))

# 386 "FStar.TypeChecker.Normalize.fst"
let maybe_simplify : step Prims.list  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun steps tm -> (
# 387 "FStar.TypeChecker.Normalize.fst"
let w = (fun t -> (
# 387 "FStar.TypeChecker.Normalize.fst"
let _53_498 = t
in {FStar_Syntax_Syntax.n = _53_498.FStar_Syntax_Syntax.n; FStar_Syntax_Syntax.tk = _53_498.FStar_Syntax_Syntax.tk; FStar_Syntax_Syntax.pos = tm.FStar_Syntax_Syntax.pos; FStar_Syntax_Syntax.vars = _53_498.FStar_Syntax_Syntax.vars}))
in (
# 388 "FStar.TypeChecker.Normalize.fst"
let simp_t = (fun t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_fvar (fv) when (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.true_lid) -> begin
Some (true)
end
| FStar_Syntax_Syntax.Tm_fvar (fv) when (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.false_lid) -> begin
Some (false)
end
| _53_507 -> begin
None
end))
in (
# 392 "FStar.TypeChecker.Normalize.fst"
let simplify = (fun arg -> ((simp_t (Prims.fst arg)), arg))
in if (FStar_All.pipe_left Prims.op_Negation (FStar_List.contains Simplify steps)) then begin
tm
end else begin
(match (tm.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.Tm_app ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uinst ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar (fv); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, _); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, args)) | (FStar_Syntax_Syntax.Tm_app ({FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar (fv); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _}, args)) -> begin
if (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.and_lid) then begin
(match ((FStar_All.pipe_right args (FStar_List.map simplify))) with
| ((Some (true), _)::(_, (arg, _))::[]) | ((_, (arg, _))::(Some (true), _)::[]) -> begin
arg
end
| ((Some (false), _)::_::[]) | (_::(Some (false), _)::[]) -> begin
(w FStar_Syntax_Util.t_false)
end
| _53_585 -> begin
tm
end)
end else begin
if (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.or_lid) then begin
(match ((FStar_All.pipe_right args (FStar_List.map simplify))) with
| ((Some (true), _)::_::[]) | (_::(Some (true), _)::[]) -> begin
(w FStar_Syntax_Util.t_true)
end
| ((Some (false), _)::(_, (arg, _))::[]) | ((_, (arg, _))::(Some (false), _)::[]) -> begin
arg
end
| _53_628 -> begin
tm
end)
end else begin
if (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.imp_lid) then begin
(match ((FStar_All.pipe_right args (FStar_List.map simplify))) with
| (_::(Some (true), _)::[]) | ((Some (false), _)::_::[]) -> begin
(w FStar_Syntax_Util.t_true)
end
| (Some (true), _53_655)::(_53_646, (arg, _53_649))::[] -> begin
arg
end
| _53_659 -> begin
tm
end)
end else begin
if (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.not_lid) then begin
(match ((FStar_All.pipe_right args (FStar_List.map simplify))) with
| (Some (true), _53_663)::[] -> begin
(w FStar_Syntax_Util.t_false)
end
| (Some (false), _53_669)::[] -> begin
(w FStar_Syntax_Util.t_true)
end
| _53_673 -> begin
tm
end)
end else begin
if ((FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.forall_lid) || (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.exists_lid)) then begin
(match (args) with
| ((t, _)::[]) | ((_, Some (FStar_Syntax_Syntax.Implicit (_)))::(t, _)::[]) -> begin
(match ((let _142_359 = (FStar_Syntax_Subst.compress t)
in _142_359.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_abs (_53_691::[], body, _53_695) -> begin
(match ((simp_t body)) with
| Some (true) -> begin
(w FStar_Syntax_Util.t_true)
end
| Some (false) -> begin
(w FStar_Syntax_Util.t_false)
end
| _53_703 -> begin
tm
end)
end
| _53_705 -> begin
tm
end)
end
| _53_707 -> begin
tm
end)
end else begin
tm
end
end
end
end
end
end
| _53_709 -> begin
tm
end)
end))))

# 445 "FStar.TypeChecker.Normalize.fst"
let rec norm : cfg  ->  env  ->  stack  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun cfg env stack t -> (
# 447 "FStar.TypeChecker.Normalize.fst"
let t = (FStar_Syntax_Subst.compress t)
in (
# 448 "FStar.TypeChecker.Normalize.fst"
let _53_716 = (log cfg (fun _53_715 -> (match (()) with
| () -> begin
(let _142_389 = (FStar_Syntax_Print.tag_of_term t)
in (let _142_388 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.print2 ">>> %s\nNorm %s\n" _142_389 _142_388)))
end)))
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_delayed (_53_719) -> begin
(FStar_All.failwith "Impossible")
end
| (FStar_Syntax_Syntax.Tm_unknown) | (FStar_Syntax_Syntax.Tm_uvar (_)) | (FStar_Syntax_Syntax.Tm_constant (_)) | (FStar_Syntax_Syntax.Tm_name (_)) | (FStar_Syntax_Syntax.Tm_fvar ({FStar_Syntax_Syntax.fv_name = _; FStar_Syntax_Syntax.fv_delta = FStar_Syntax_Syntax.Delta_constant; FStar_Syntax_Syntax.fv_qual = _})) | (FStar_Syntax_Syntax.Tm_fvar ({FStar_Syntax_Syntax.fv_name = _; FStar_Syntax_Syntax.fv_delta = _; FStar_Syntax_Syntax.fv_qual = Some (FStar_Syntax_Syntax.Data_ctor)})) | (FStar_Syntax_Syntax.Tm_fvar ({FStar_Syntax_Syntax.fv_name = _; FStar_Syntax_Syntax.fv_delta = _; FStar_Syntax_Syntax.fv_qual = Some (FStar_Syntax_Syntax.Record_ctor (_))})) -> begin
(rebuild cfg env stack t)
end
| FStar_Syntax_Syntax.Tm_type (u) -> begin
(
# 463 "FStar.TypeChecker.Normalize.fst"
let u = (norm_universe cfg env u)
in (let _142_393 = (mk (FStar_Syntax_Syntax.Tm_type (u)) t.FStar_Syntax_Syntax.pos)
in (rebuild cfg env stack _142_393)))
end
| FStar_Syntax_Syntax.Tm_uinst (t', us) -> begin
if (FStar_All.pipe_right cfg.steps (FStar_List.contains EraseUniverses)) then begin
(norm cfg env stack t')
end else begin
(
# 469 "FStar.TypeChecker.Normalize.fst"
let us = (let _142_395 = (let _142_394 = (FStar_List.map (norm_universe cfg env) us)
in (_142_394, t.FStar_Syntax_Syntax.pos))
in UnivArgs (_142_395))
in (
# 470 "FStar.TypeChecker.Normalize.fst"
let stack = (us)::stack
in (norm cfg env stack t')))
end
end
| FStar_Syntax_Syntax.Tm_fvar (f) -> begin
(
# 474 "FStar.TypeChecker.Normalize.fst"
let should_delta = (match (cfg.delta_level) with
| FStar_TypeChecker_Env.NoDelta -> begin
false
end
| FStar_TypeChecker_Env.OnlyInline -> begin
true
end
| FStar_TypeChecker_Env.Unfold (l) -> begin
(FStar_TypeChecker_Common.delta_depth_greater_than f.FStar_Syntax_Syntax.fv_delta l)
end)
in if (not (should_delta)) then begin
(rebuild cfg env stack t)
end else begin
(match ((FStar_TypeChecker_Env.lookup_definition cfg.delta_level cfg.tcenv f.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)) with
| None -> begin
(rebuild cfg env stack t)
end
| Some (us, t) -> begin
(
# 484 "FStar.TypeChecker.Normalize.fst"
let n = (FStar_List.length us)
in if (n > 0) then begin
(match (stack) with
| UnivArgs (us', _53_781)::stack -> begin
(
# 488 "FStar.TypeChecker.Normalize.fst"
let env = (FStar_All.pipe_right us' (FStar_List.fold_left (fun env u -> (Univ (u))::env) env))
in (norm cfg env stack t))
end
| _53_789 when (FStar_All.pipe_right cfg.steps (FStar_List.contains EraseUniverses)) -> begin
(norm cfg env stack t)
end
| _53_791 -> begin
(let _142_399 = (let _142_398 = (FStar_Syntax_Print.lid_to_string f.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)
in (FStar_Util.format1 "Impossible: missing universe instantiation on %s" _142_398))
in (FStar_All.failwith _142_399))
end)
end else begin
(norm cfg env stack t)
end)
end)
end)
end
| FStar_Syntax_Syntax.Tm_bvar (x) -> begin
(match ((lookup_bvar env x)) with
| Univ (_53_795) -> begin
(FStar_All.failwith "Impossible: term variable is bound to a universe")
end
| Dummy -> begin
(FStar_All.failwith "Term variable not found")
end
| Clos (env, t0, r) -> begin
(match ((FStar_ST.read r)) with
| Some (env, t') -> begin
(
# 503 "FStar.TypeChecker.Normalize.fst"
let _53_808 = (log cfg (fun _53_807 -> (match (()) with
| () -> begin
(let _142_402 = (FStar_Syntax_Print.term_to_string t)
in (let _142_401 = (FStar_Syntax_Print.term_to_string t')
in (FStar_Util.print2 "Lazy hit: %s cached to %s\n" _142_402 _142_401)))
end)))
in (match ((let _142_403 = (FStar_Syntax_Subst.compress t')
in _142_403.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_abs (_53_811) -> begin
(norm cfg env stack t')
end
| _53_814 -> begin
(rebuild cfg env stack t')
end))
end
| None -> begin
(norm cfg env ((MemoLazy (r))::stack) t0)
end)
end)
end
| FStar_Syntax_Syntax.Tm_abs (bs, body, lopt) -> begin
(match (stack) with
| Meta (_53_824)::_53_822 -> begin
(FStar_All.failwith "Labeled abstraction")
end
| UnivArgs (_53_830)::_53_828 -> begin
(FStar_All.failwith "Ill-typed term: universes cannot be applied to term abstraction")
end
| Match (_53_836)::_53_834 -> begin
(FStar_All.failwith "Ill-typed term: cannot pattern match an abstraction")
end
| Arg (c, _53_842, _53_844)::stack -> begin
(match (c) with
| Univ (_53_849) -> begin
(norm cfg ((c)::env) stack t)
end
| _53_852 -> begin
(match (bs) with
| [] -> begin
(FStar_All.failwith "Impossible")
end
| _53_855::[] -> begin
(match (lopt) with
| None when (FStar_ST.read FStar_Options.__test_norm_all) -> begin
(
# 540 "FStar.TypeChecker.Normalize.fst"
let _53_859 = (log cfg (fun _53_858 -> (match (()) with
| () -> begin
(let _142_405 = (closure_to_string c)
in (FStar_Util.print1 "\tShifted %s\n" _142_405))
end)))
in (norm cfg ((c)::env) stack body))
end
| Some (FStar_Util.Inr (l)) when ((FStar_Ident.lid_equals l FStar_Syntax_Const.effect_Tot_lid) || (FStar_Ident.lid_equals l FStar_Syntax_Const.effect_GTot_lid)) -> begin
(
# 546 "FStar.TypeChecker.Normalize.fst"
let _53_865 = (log cfg (fun _53_864 -> (match (()) with
| () -> begin
(let _142_407 = (closure_to_string c)
in (FStar_Util.print1 "\tShifted %s\n" _142_407))
end)))
in (norm cfg ((c)::env) stack body))
end
| Some (FStar_Util.Inl (lc)) when (FStar_Syntax_Util.is_tot_or_gtot_lcomp lc) -> begin
(
# 550 "FStar.TypeChecker.Normalize.fst"
let _53_871 = (log cfg (fun _53_870 -> (match (()) with
| () -> begin
(let _142_409 = (closure_to_string c)
in (FStar_Util.print1 "\tShifted %s\n" _142_409))
end)))
in (norm cfg ((c)::env) stack body))
end
| _53_874 -> begin
(
# 555 "FStar.TypeChecker.Normalize.fst"
let cfg = (
# 555 "FStar.TypeChecker.Normalize.fst"
let _53_875 = cfg
in {steps = (WHNF)::cfg.steps; tcenv = _53_875.tcenv; delta_level = _53_875.delta_level})
in (let _142_410 = (closure_as_term cfg env t)
in (rebuild cfg env stack _142_410)))
end)
end
| _53_880::tl -> begin
(
# 559 "FStar.TypeChecker.Normalize.fst"
let _53_883 = (log cfg (fun _53_882 -> (match (()) with
| () -> begin
(let _142_412 = (closure_to_string c)
in (FStar_Util.print1 "\tShifted %s\n" _142_412))
end)))
in (
# 560 "FStar.TypeChecker.Normalize.fst"
let body = (mk (FStar_Syntax_Syntax.Tm_abs ((tl, body, lopt))) t.FStar_Syntax_Syntax.pos)
in (norm cfg ((c)::env) stack body)))
end)
end)
end
| MemoLazy (r)::stack -> begin
(
# 566 "FStar.TypeChecker.Normalize.fst"
let _53_890 = (set_memo r (env, t))
in (
# 567 "FStar.TypeChecker.Normalize.fst"
let _53_893 = (log cfg (fun _53_892 -> (match (()) with
| () -> begin
(FStar_Util.print_string "\tSet memo\n")
end)))
in (norm cfg env stack t)))
end
| (App (_)::_) | (Abs (_)::_) | ([]) -> begin
if (FStar_List.contains WHNF cfg.steps) then begin
(let _142_414 = (closure_as_term cfg env t)
in (rebuild cfg env stack _142_414))
end else begin
(
# 575 "FStar.TypeChecker.Normalize.fst"
let _53_911 = (FStar_Syntax_Subst.open_term' bs body)
in (match (_53_911) with
| (bs, body, opening) -> begin
(
# 576 "FStar.TypeChecker.Normalize.fst"
let lopt = (match (lopt) with
| Some (FStar_Util.Inl (l)) -> begin
(let _142_420 = (let _142_418 = (let _142_416 = (let _142_415 = (l.FStar_Syntax_Syntax.comp ())
in (FStar_Syntax_Subst.subst_comp opening _142_415))
in (FStar_All.pipe_right _142_416 FStar_Syntax_Util.lcomp_of_comp))
in (FStar_All.pipe_right _142_418 (fun _142_417 -> FStar_Util.Inl (_142_417))))
in (FStar_All.pipe_right _142_420 (fun _142_419 -> Some (_142_419))))
end
| _53_916 -> begin
lopt
end)
in (
# 579 "FStar.TypeChecker.Normalize.fst"
let env' = (FStar_All.pipe_right bs (FStar_List.fold_left (fun env _53_919 -> (Dummy)::env) env))
in (
# 580 "FStar.TypeChecker.Normalize.fst"
let _53_923 = (log cfg (fun _53_922 -> (match (()) with
| () -> begin
(let _142_424 = (FStar_All.pipe_left FStar_Util.string_of_int (FStar_List.length bs))
in (FStar_Util.print1 "\tShifted %s dummies\n" _142_424))
end)))
in (norm cfg env' ((Abs ((env, bs, env', lopt, t.FStar_Syntax_Syntax.pos)))::stack) body))))
end))
end
end)
end
| FStar_Syntax_Syntax.Tm_app (head, args) -> begin
(
# 585 "FStar.TypeChecker.Normalize.fst"
let stack = (FStar_All.pipe_right stack (FStar_List.fold_right (fun _53_931 stack -> (match (_53_931) with
| (a, aq) -> begin
(let _142_431 = (let _142_430 = (let _142_429 = (let _142_428 = (let _142_427 = (FStar_Util.mk_ref None)
in (env, a, _142_427))
in Clos (_142_428))
in (_142_429, aq, t.FStar_Syntax_Syntax.pos))
in Arg (_142_430))
in (_142_431)::stack)
end)) args))
in (
# 586 "FStar.TypeChecker.Normalize.fst"
let _53_935 = (log cfg (fun _53_934 -> (match (()) with
| () -> begin
(let _142_433 = (FStar_All.pipe_left FStar_Util.string_of_int (FStar_List.length args))
in (FStar_Util.print1 "\tPushed %s arguments\n" _142_433))
end)))
in (norm cfg env stack head)))
end
| FStar_Syntax_Syntax.Tm_refine (x, f) -> begin
if (FStar_List.contains WHNF cfg.steps) then begin
(match ((env, stack)) with
| ([], []) -> begin
(
# 593 "FStar.TypeChecker.Normalize.fst"
let t_x = (norm cfg env [] x.FStar_Syntax_Syntax.sort)
in (
# 594 "FStar.TypeChecker.Normalize.fst"
let t = (mk (FStar_Syntax_Syntax.Tm_refine (((
# 594 "FStar.TypeChecker.Normalize.fst"
let _53_945 = x
in {FStar_Syntax_Syntax.ppname = _53_945.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _53_945.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = t_x}), f))) t.FStar_Syntax_Syntax.pos)
in (rebuild cfg env stack t)))
end
| _53_949 -> begin
(let _142_434 = (closure_as_term cfg env t)
in (rebuild cfg env stack _142_434))
end)
end else begin
(
# 597 "FStar.TypeChecker.Normalize.fst"
let t_x = (norm cfg env [] x.FStar_Syntax_Syntax.sort)
in (
# 598 "FStar.TypeChecker.Normalize.fst"
let _53_953 = (FStar_Syntax_Subst.open_term (((x, None))::[]) f)
in (match (_53_953) with
| (closing, f) -> begin
(
# 599 "FStar.TypeChecker.Normalize.fst"
let f = (norm cfg ((Dummy)::env) [] f)
in (
# 600 "FStar.TypeChecker.Normalize.fst"
let t = (let _142_437 = (let _142_436 = (let _142_435 = (FStar_Syntax_Subst.close closing f)
in ((
# 600 "FStar.TypeChecker.Normalize.fst"
let _53_955 = x
in {FStar_Syntax_Syntax.ppname = _53_955.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _53_955.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = t_x}), _142_435))
in FStar_Syntax_Syntax.Tm_refine (_142_436))
in (mk _142_437 t.FStar_Syntax_Syntax.pos))
in (rebuild cfg env stack t)))
end)))
end
end
| FStar_Syntax_Syntax.Tm_arrow (bs, c) -> begin
if (FStar_List.contains WHNF cfg.steps) then begin
(let _142_438 = (closure_as_term cfg env t)
in (rebuild cfg env stack _142_438))
end else begin
(
# 606 "FStar.TypeChecker.Normalize.fst"
let _53_964 = (FStar_Syntax_Subst.open_comp bs c)
in (match (_53_964) with
| (bs, c) -> begin
(
# 607 "FStar.TypeChecker.Normalize.fst"
let c = (let _142_441 = (FStar_All.pipe_right bs (FStar_List.fold_left (fun env _53_966 -> (Dummy)::env) env))
in (norm_comp cfg _142_441 c))
in (
# 608 "FStar.TypeChecker.Normalize.fst"
let t = (let _142_442 = (norm_binders cfg env bs)
in (FStar_Syntax_Util.arrow _142_442 c))
in (rebuild cfg env stack t)))
end))
end
end
| FStar_Syntax_Syntax.Tm_ascribed (t1, tc, l) -> begin
(match (stack) with
| (Match (_)::_) | (Arg (_)::_) | (MemoLazy (_)::_) -> begin
(norm cfg env stack t1)
end
| _53_994 -> begin
(
# 617 "FStar.TypeChecker.Normalize.fst"
let t1 = (norm cfg env [] t1)
in (
# 618 "FStar.TypeChecker.Normalize.fst"
let _53_997 = (log cfg (fun _53_996 -> (match (()) with
| () -> begin
(FStar_Util.print_string "+++ Normalizing ascription \n")
end)))
in (
# 619 "FStar.TypeChecker.Normalize.fst"
let tc = (match (tc) with
| FStar_Util.Inl (t) -> begin
(let _142_444 = (norm cfg env [] t)
in FStar_Util.Inl (_142_444))
end
| FStar_Util.Inr (c) -> begin
(let _142_445 = (norm_comp cfg env c)
in FStar_Util.Inr (_142_445))
end)
in (let _142_446 = (mk (FStar_Syntax_Syntax.Tm_ascribed ((t1, tc, l))) t.FStar_Syntax_Syntax.pos)
in (rebuild cfg env stack _142_446)))))
end)
end
| FStar_Syntax_Syntax.Tm_match (head, branches) -> begin
(
# 626 "FStar.TypeChecker.Normalize.fst"
let stack = (Match ((env, branches, t.FStar_Syntax_Syntax.pos)))::stack
in (norm cfg env stack head))
end
| FStar_Syntax_Syntax.Tm_let ((false, lb::[]), body) -> begin
(
# 630 "FStar.TypeChecker.Normalize.fst"
let env = (let _142_449 = (let _142_448 = (let _142_447 = (FStar_Util.mk_ref None)
in (env, lb.FStar_Syntax_Syntax.lbdef, _142_447))
in Clos (_142_448))
in (_142_449)::env)
in (norm cfg env stack body))
end
| FStar_Syntax_Syntax.Tm_let ((_53_1018, {FStar_Syntax_Syntax.lbname = FStar_Util.Inr (_53_1030); FStar_Syntax_Syntax.lbunivs = _53_1028; FStar_Syntax_Syntax.lbtyp = _53_1026; FStar_Syntax_Syntax.lbeff = _53_1024; FStar_Syntax_Syntax.lbdef = _53_1022}::_53_1020), _53_1036) -> begin
(rebuild cfg env stack t)
end
| FStar_Syntax_Syntax.Tm_let (lbs, body) -> begin
(
# 647 "FStar.TypeChecker.Normalize.fst"
let _53_1058 = (FStar_List.fold_right (fun lb _53_1047 -> (match (_53_1047) with
| (rec_env, memos, i) -> begin
(
# 648 "FStar.TypeChecker.Normalize.fst"
let f_i = (let _142_452 = (
# 648 "FStar.TypeChecker.Normalize.fst"
let _53_1048 = (FStar_Util.left lb.FStar_Syntax_Syntax.lbname)
in {FStar_Syntax_Syntax.ppname = _53_1048.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = i; FStar_Syntax_Syntax.sort = _53_1048.FStar_Syntax_Syntax.sort})
in (FStar_Syntax_Syntax.bv_to_tm _142_452))
in (
# 649 "FStar.TypeChecker.Normalize.fst"
let fix_f_i = (mk (FStar_Syntax_Syntax.Tm_let ((lbs, f_i))) t.FStar_Syntax_Syntax.pos)
in (
# 650 "FStar.TypeChecker.Normalize.fst"
let memo = (FStar_Util.mk_ref None)
in (
# 651 "FStar.TypeChecker.Normalize.fst"
let rec_env = (Clos ((env, fix_f_i, memo)))::rec_env
in (rec_env, (memo)::memos, (i + 1))))))
end)) (Prims.snd lbs) (env, [], 0))
in (match (_53_1058) with
| (rec_env, memos, _53_1057) -> begin
(
# 653 "FStar.TypeChecker.Normalize.fst"
let _53_1061 = (FStar_List.map2 (fun lb memo -> (FStar_ST.op_Colon_Equals memo (Some ((rec_env, lb.FStar_Syntax_Syntax.lbdef))))) (Prims.snd lbs) memos)
in (
# 654 "FStar.TypeChecker.Normalize.fst"
let body_env = (FStar_List.fold_right (fun lb env -> (let _142_459 = (let _142_458 = (let _142_457 = (FStar_Util.mk_ref None)
in (rec_env, lb.FStar_Syntax_Syntax.lbdef, _142_457))
in Clos (_142_458))
in (_142_459)::env)) (Prims.snd lbs) env)
in (norm cfg body_env stack body)))
end))
end
| FStar_Syntax_Syntax.Tm_meta (head, m) -> begin
(match (stack) with
| _53_1073::_53_1071 -> begin
(match (m) with
| FStar_Syntax_Syntax.Meta_labeled (l, r, _53_1078) -> begin
(norm cfg env ((Meta ((m, r)))::stack) head)
end
| FStar_Syntax_Syntax.Meta_pattern (args) -> begin
(
# 666 "FStar.TypeChecker.Normalize.fst"
let args = (norm_pattern_args cfg env args)
in (norm cfg env ((Meta ((FStar_Syntax_Syntax.Meta_pattern (args), t.FStar_Syntax_Syntax.pos)))::stack) head))
end
| _53_1085 -> begin
(norm cfg env stack head)
end)
end
| _53_1087 -> begin
(
# 673 "FStar.TypeChecker.Normalize.fst"
let head = (norm cfg env [] head)
in (
# 674 "FStar.TypeChecker.Normalize.fst"
let m = (match (m) with
| FStar_Syntax_Syntax.Meta_pattern (args) -> begin
(let _142_460 = (norm_pattern_args cfg env args)
in FStar_Syntax_Syntax.Meta_pattern (_142_460))
end
| _53_1092 -> begin
m
end)
in (
# 678 "FStar.TypeChecker.Normalize.fst"
let t = (mk (FStar_Syntax_Syntax.Tm_meta ((head, m))) t.FStar_Syntax_Syntax.pos)
in (rebuild cfg env stack t))))
end)
end))))
and norm_pattern_args : cfg  ->  env  ->  FStar_Syntax_Syntax.args Prims.list  ->  FStar_Syntax_Syntax.args Prims.list = (fun cfg env args -> (FStar_All.pipe_right args (FStar_List.map (FStar_List.map (fun _53_1100 -> (match (_53_1100) with
| (a, imp) -> begin
(let _142_465 = (norm cfg env [] a)
in (_142_465, imp))
end))))))
and norm_comp : cfg  ->  env  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun cfg env comp -> (
# 687 "FStar.TypeChecker.Normalize.fst"
let comp = (ghost_to_pure_aux cfg env comp)
in (match (comp.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Total (t) -> begin
(
# 690 "FStar.TypeChecker.Normalize.fst"
let _53_1107 = comp
in (let _142_470 = (let _142_469 = (norm cfg env [] t)
in FStar_Syntax_Syntax.Total (_142_469))
in {FStar_Syntax_Syntax.n = _142_470; FStar_Syntax_Syntax.tk = _53_1107.FStar_Syntax_Syntax.tk; FStar_Syntax_Syntax.pos = _53_1107.FStar_Syntax_Syntax.pos; FStar_Syntax_Syntax.vars = _53_1107.FStar_Syntax_Syntax.vars}))
end
| FStar_Syntax_Syntax.GTotal (t) -> begin
(
# 693 "FStar.TypeChecker.Normalize.fst"
let _53_1111 = comp
in (let _142_472 = (let _142_471 = (norm cfg env [] t)
in FStar_Syntax_Syntax.GTotal (_142_471))
in {FStar_Syntax_Syntax.n = _142_472; FStar_Syntax_Syntax.tk = _53_1111.FStar_Syntax_Syntax.tk; FStar_Syntax_Syntax.pos = _53_1111.FStar_Syntax_Syntax.pos; FStar_Syntax_Syntax.vars = _53_1111.FStar_Syntax_Syntax.vars}))
end
| FStar_Syntax_Syntax.Comp (ct) -> begin
(
# 696 "FStar.TypeChecker.Normalize.fst"
let norm_args = (fun args -> (FStar_All.pipe_right args (FStar_List.map (fun _53_1119 -> (match (_53_1119) with
| (a, i) -> begin
(let _142_476 = (norm cfg env [] a)
in (_142_476, i))
end)))))
in (
# 697 "FStar.TypeChecker.Normalize.fst"
let _53_1120 = comp
in (let _142_480 = (let _142_479 = (
# 697 "FStar.TypeChecker.Normalize.fst"
let _53_1122 = ct
in (let _142_478 = (norm cfg env [] ct.FStar_Syntax_Syntax.result_typ)
in (let _142_477 = (norm_args ct.FStar_Syntax_Syntax.effect_args)
in {FStar_Syntax_Syntax.effect_name = _53_1122.FStar_Syntax_Syntax.effect_name; FStar_Syntax_Syntax.result_typ = _142_478; FStar_Syntax_Syntax.effect_args = _142_477; FStar_Syntax_Syntax.flags = _53_1122.FStar_Syntax_Syntax.flags})))
in FStar_Syntax_Syntax.Comp (_142_479))
in {FStar_Syntax_Syntax.n = _142_480; FStar_Syntax_Syntax.tk = _53_1120.FStar_Syntax_Syntax.tk; FStar_Syntax_Syntax.pos = _53_1120.FStar_Syntax_Syntax.pos; FStar_Syntax_Syntax.vars = _53_1120.FStar_Syntax_Syntax.vars})))
end)))
and ghost_to_pure_aux : cfg  ->  env  ->  FStar_Syntax_Syntax.comp  ->  (FStar_Syntax_Syntax.comp', Prims.unit) FStar_Syntax_Syntax.syntax = (fun cfg env c -> (
# 704 "FStar.TypeChecker.Normalize.fst"
let norm = (fun t -> (norm (
# 705 "FStar.TypeChecker.Normalize.fst"
let _53_1129 = cfg
in {steps = (Inline)::(UnfoldUntil (FStar_Syntax_Syntax.Delta_constant))::(EraseUniverses)::(AllowUnboundUniverses)::[]; tcenv = _53_1129.tcenv; delta_level = _53_1129.delta_level}) env [] t))
in (
# 706 "FStar.TypeChecker.Normalize.fst"
let non_info = (fun t -> (let _142_488 = (norm t)
in (FStar_Syntax_Util.non_informative _142_488)))
in (match (c.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Total (_53_1134) -> begin
c
end
| FStar_Syntax_Syntax.GTotal (t) when (non_info t) -> begin
(
# 709 "FStar.TypeChecker.Normalize.fst"
let _53_1138 = c
in {FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Total (t); FStar_Syntax_Syntax.tk = _53_1138.FStar_Syntax_Syntax.tk; FStar_Syntax_Syntax.pos = _53_1138.FStar_Syntax_Syntax.pos; FStar_Syntax_Syntax.vars = _53_1138.FStar_Syntax_Syntax.vars})
end
| FStar_Syntax_Syntax.Comp (ct) -> begin
(
# 711 "FStar.TypeChecker.Normalize.fst"
let l = (FStar_TypeChecker_Env.norm_eff_name cfg.tcenv ct.FStar_Syntax_Syntax.effect_name)
in if ((FStar_Syntax_Util.is_ghost_effect l) && (non_info ct.FStar_Syntax_Syntax.result_typ)) then begin
(
# 714 "FStar.TypeChecker.Normalize.fst"
let ct = if (FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name FStar_Syntax_Const.effect_Ghost_lid) then begin
(
# 716 "FStar.TypeChecker.Normalize.fst"
let _53_1143 = ct
in {FStar_Syntax_Syntax.effect_name = FStar_Syntax_Const.effect_Pure_lid; FStar_Syntax_Syntax.result_typ = _53_1143.FStar_Syntax_Syntax.result_typ; FStar_Syntax_Syntax.effect_args = _53_1143.FStar_Syntax_Syntax.effect_args; FStar_Syntax_Syntax.flags = _53_1143.FStar_Syntax_Syntax.flags})
end else begin
if (FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name FStar_Syntax_Const.effect_GTot_lid) then begin
(
# 718 "FStar.TypeChecker.Normalize.fst"
let _53_1145 = ct
in {FStar_Syntax_Syntax.effect_name = FStar_Syntax_Const.effect_Tot_lid; FStar_Syntax_Syntax.result_typ = _53_1145.FStar_Syntax_Syntax.result_typ; FStar_Syntax_Syntax.effect_args = _53_1145.FStar_Syntax_Syntax.effect_args; FStar_Syntax_Syntax.flags = _53_1145.FStar_Syntax_Syntax.flags})
end else begin
if (FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name FStar_Syntax_Const.effect_GHOST_lid) then begin
(
# 720 "FStar.TypeChecker.Normalize.fst"
let _53_1147 = ct
in {FStar_Syntax_Syntax.effect_name = FStar_Syntax_Const.effect_PURE_lid; FStar_Syntax_Syntax.result_typ = _53_1147.FStar_Syntax_Syntax.result_typ; FStar_Syntax_Syntax.effect_args = _53_1147.FStar_Syntax_Syntax.effect_args; FStar_Syntax_Syntax.flags = _53_1147.FStar_Syntax_Syntax.flags})
end else begin
(
# 721 "FStar.TypeChecker.Normalize.fst"
let ct = (unfold_effect_abbrev cfg.tcenv c)
in (
# 722 "FStar.TypeChecker.Normalize.fst"
let _53_1150 = ct
in {FStar_Syntax_Syntax.effect_name = FStar_Syntax_Const.effect_PURE_lid; FStar_Syntax_Syntax.result_typ = _53_1150.FStar_Syntax_Syntax.result_typ; FStar_Syntax_Syntax.effect_args = _53_1150.FStar_Syntax_Syntax.effect_args; FStar_Syntax_Syntax.flags = _53_1150.FStar_Syntax_Syntax.flags}))
end
end
end
in (
# 723 "FStar.TypeChecker.Normalize.fst"
let _53_1153 = c
in {FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Comp (ct); FStar_Syntax_Syntax.tk = _53_1153.FStar_Syntax_Syntax.tk; FStar_Syntax_Syntax.pos = _53_1153.FStar_Syntax_Syntax.pos; FStar_Syntax_Syntax.vars = _53_1153.FStar_Syntax_Syntax.vars}))
end else begin
c
end)
end
| _53_1156 -> begin
c
end))))
and norm_binder : cfg  ->  env  ->  FStar_Syntax_Syntax.binder  ->  FStar_Syntax_Syntax.binder = (fun cfg env _53_1161 -> (match (_53_1161) with
| (x, imp) -> begin
(let _142_493 = (
# 729 "FStar.TypeChecker.Normalize.fst"
let _53_1162 = x
in (let _142_492 = (norm cfg env [] x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _53_1162.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _53_1162.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _142_492}))
in (_142_493, imp))
end))
and norm_binders : cfg  ->  env  ->  FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.binders = (fun cfg env bs -> (
# 733 "FStar.TypeChecker.Normalize.fst"
let _53_1175 = (FStar_List.fold_left (fun _53_1169 b -> (match (_53_1169) with
| (nbs', env) -> begin
(
# 734 "FStar.TypeChecker.Normalize.fst"
let b = (norm_binder cfg env b)
in ((b)::nbs', (Dummy)::env))
end)) ([], env) bs)
in (match (_53_1175) with
| (nbs, _53_1174) -> begin
(FStar_List.rev nbs)
end)))
and rebuild : cfg  ->  env  ->  stack  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun cfg env stack t -> (match (stack) with
| [] -> begin
t
end
| Meta (m, r)::stack -> begin
(
# 748 "FStar.TypeChecker.Normalize.fst"
let t = (mk (FStar_Syntax_Syntax.Tm_meta ((t, m))) r)
in (rebuild cfg env stack t))
end
| MemoLazy (r)::stack -> begin
(
# 752 "FStar.TypeChecker.Normalize.fst"
let _53_1192 = (set_memo r (env, t))
in (rebuild cfg env stack t))
end
| Abs (env', bs, env'', lopt, r)::stack -> begin
(
# 756 "FStar.TypeChecker.Normalize.fst"
let bs = (norm_binders cfg env' bs)
in (
# 757 "FStar.TypeChecker.Normalize.fst"
let lopt = (close_lcomp_opt cfg env'' lopt)
in (let _142_503 = (
# 758 "FStar.TypeChecker.Normalize.fst"
let _53_1205 = (FStar_Syntax_Util.abs bs t lopt)
in {FStar_Syntax_Syntax.n = _53_1205.FStar_Syntax_Syntax.n; FStar_Syntax_Syntax.tk = _53_1205.FStar_Syntax_Syntax.tk; FStar_Syntax_Syntax.pos = r; FStar_Syntax_Syntax.vars = _53_1205.FStar_Syntax_Syntax.vars})
in (rebuild cfg env stack _142_503))))
end
| (Arg (Univ (_), _, _)::_) | (Arg (Dummy, _, _)::_) -> begin
(FStar_All.failwith "Impossible")
end
| UnivArgs (us, r)::stack -> begin
(
# 764 "FStar.TypeChecker.Normalize.fst"
let t = (FStar_Syntax_Syntax.mk_Tm_uinst t us)
in (rebuild cfg env stack t))
end
| Arg (Clos (env, tm, m), aq, r)::stack -> begin
(
# 768 "FStar.TypeChecker.Normalize.fst"
let _53_1248 = (log cfg (fun _53_1247 -> (match (()) with
| () -> begin
(let _142_505 = (FStar_Syntax_Print.term_to_string tm)
in (FStar_Util.print1 "Rebuilding with arg %s\n" _142_505))
end)))
in (match ((FStar_ST.read m)) with
| None -> begin
if (FStar_List.contains WHNF cfg.steps) then begin
(
# 773 "FStar.TypeChecker.Normalize.fst"
let arg = (closure_as_term cfg env tm)
in (
# 774 "FStar.TypeChecker.Normalize.fst"
let t = (FStar_Syntax_Syntax.extend_app t (arg, aq) None r)
in (rebuild cfg env stack t)))
end else begin
(
# 776 "FStar.TypeChecker.Normalize.fst"
let stack = (MemoLazy (m))::(App ((t, aq, r)))::stack
in (norm cfg env stack tm))
end
end
| Some (_53_1255, a) -> begin
(
# 780 "FStar.TypeChecker.Normalize.fst"
let t = (FStar_Syntax_Syntax.extend_app t (a, aq) None r)
in (rebuild cfg env stack t))
end))
end
| App (head, aq, r)::stack -> begin
(
# 785 "FStar.TypeChecker.Normalize.fst"
let t = (FStar_Syntax_Syntax.extend_app head (t, aq) None r)
in (let _142_506 = (maybe_simplify cfg.steps t)
in (rebuild cfg env stack _142_506)))
end
| Match (env, branches, r)::stack -> begin
(
# 789 "FStar.TypeChecker.Normalize.fst"
let _53_1276 = (log cfg (fun _53_1275 -> (match (()) with
| () -> begin
(let _142_508 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.print1 "Rebuilding with match, scrutinee is %s ...\n" _142_508))
end)))
in (
# 790 "FStar.TypeChecker.Normalize.fst"
let norm_and_rebuild_match = (fun _53_1279 -> (match (()) with
| () -> begin
(
# 791 "FStar.TypeChecker.Normalize.fst"
let whnf = (FStar_List.contains WHNF cfg.steps)
in (
# 792 "FStar.TypeChecker.Normalize.fst"
let cfg = (
# 792 "FStar.TypeChecker.Normalize.fst"
let _53_1281 = cfg
in (let _142_511 = (FStar_TypeChecker_Env.glb_delta cfg.delta_level FStar_TypeChecker_Env.OnlyInline)
in {steps = _53_1281.steps; tcenv = _53_1281.tcenv; delta_level = _142_511}))
in (
# 793 "FStar.TypeChecker.Normalize.fst"
let norm_or_whnf = (fun env t -> if whnf then begin
(closure_as_term cfg env t)
end else begin
(norm cfg env [] t)
end)
in (
# 797 "FStar.TypeChecker.Normalize.fst"
let branches = (match (env) with
| [] when whnf -> begin
branches
end
| _53_1289 -> begin
(FStar_All.pipe_right branches (FStar_List.map (fun branch -> (
# 801 "FStar.TypeChecker.Normalize.fst"
let _53_1294 = (FStar_Syntax_Subst.open_branch branch)
in (match (_53_1294) with
| (p, wopt, e) -> begin
(
# 802 "FStar.TypeChecker.Normalize.fst"
let env = (let _142_519 = (FStar_Syntax_Syntax.pat_bvs p)
in (FStar_All.pipe_right _142_519 (FStar_List.fold_left (fun env x -> (Dummy)::env) env)))
in (
# 804 "FStar.TypeChecker.Normalize.fst"
let wopt = (match (wopt) with
| None -> begin
None
end
| Some (w) -> begin
(let _142_520 = (norm_or_whnf env w)
in Some (_142_520))
end)
in (
# 807 "FStar.TypeChecker.Normalize.fst"
let e = (norm_or_whnf env e)
in (FStar_Syntax_Util.branch (p, wopt, e)))))
end)))))
end)
in (let _142_521 = (mk (FStar_Syntax_Syntax.Tm_match ((t, branches))) r)
in (rebuild cfg env stack _142_521))))))
end))
in (
# 811 "FStar.TypeChecker.Normalize.fst"
let rec is_cons = (fun head -> (match (head.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_uinst (h, _53_1308) -> begin
(is_cons h)
end
| (FStar_Syntax_Syntax.Tm_constant (_)) | (FStar_Syntax_Syntax.Tm_fvar ({FStar_Syntax_Syntax.fv_name = _; FStar_Syntax_Syntax.fv_delta = _; FStar_Syntax_Syntax.fv_qual = Some (FStar_Syntax_Syntax.Data_ctor)})) | (FStar_Syntax_Syntax.Tm_fvar ({FStar_Syntax_Syntax.fv_name = _; FStar_Syntax_Syntax.fv_delta = _; FStar_Syntax_Syntax.fv_qual = Some (FStar_Syntax_Syntax.Record_ctor (_))})) -> begin
true
end
| _53_1333 -> begin
false
end))
in (
# 818 "FStar.TypeChecker.Normalize.fst"
let guard_when_clause = (fun wopt b rest -> (match (wopt) with
| None -> begin
b
end
| Some (w) -> begin
(
# 822 "FStar.TypeChecker.Normalize.fst"
let then_branch = b
in (
# 823 "FStar.TypeChecker.Normalize.fst"
let else_branch = (mk (FStar_Syntax_Syntax.Tm_match ((t, rest))) r)
in (FStar_Syntax_Util.if_then_else w then_branch else_branch)))
end))
in (
# 827 "FStar.TypeChecker.Normalize.fst"
let rec matches_pat = (fun t p -> (
# 831 "FStar.TypeChecker.Normalize.fst"
let t = (FStar_Syntax_Subst.compress t)
in (
# 832 "FStar.TypeChecker.Normalize.fst"
let _53_1350 = (FStar_Syntax_Util.head_and_args t)
in (match (_53_1350) with
| (head, args) -> begin
(match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj (ps) -> begin
(
# 835 "FStar.TypeChecker.Normalize.fst"
let mopt = (FStar_Util.find_map ps (fun p -> (
# 836 "FStar.TypeChecker.Normalize.fst"
let m = (matches_pat t p)
in (match (m) with
| FStar_Util.Inl (_53_1356) -> begin
Some (m)
end
| FStar_Util.Inr (true) -> begin
Some (m)
end
| FStar_Util.Inr (false) -> begin
None
end))))
in (match (mopt) with
| None -> begin
FStar_Util.Inr (false)
end
| Some (m) -> begin
m
end))
end
| (FStar_Syntax_Syntax.Pat_var (_)) | (FStar_Syntax_Syntax.Pat_wild (_)) -> begin
FStar_Util.Inl ((t)::[])
end
| FStar_Syntax_Syntax.Pat_dot_term (_53_1373) -> begin
FStar_Util.Inl ([])
end
| FStar_Syntax_Syntax.Pat_constant (s) -> begin
(match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_constant (s') when (s = s') -> begin
FStar_Util.Inl ([])
end
| _53_1380 -> begin
(let _142_538 = (not ((is_cons head)))
in FStar_Util.Inr (_142_538))
end)
end
| FStar_Syntax_Syntax.Pat_cons (fv, arg_pats) -> begin
(match ((let _142_539 = (FStar_Syntax_Util.un_uinst head)
in _142_539.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_fvar (fv') when (FStar_Syntax_Syntax.fv_eq fv fv') -> begin
(matches_args [] args arg_pats)
end
| _53_1388 -> begin
(let _142_540 = (not ((is_cons head)))
in FStar_Util.Inr (_142_540))
end)
end)
end))))
and matches_args = (fun out a p -> (match ((a, p)) with
| ([], []) -> begin
FStar_Util.Inl (out)
end
| ((t, _53_1398)::rest_a, (p, _53_1404)::rest_p) -> begin
(match ((matches_pat t p)) with
| FStar_Util.Inl (s) -> begin
(matches_args (FStar_List.append out s) rest_a rest_p)
end
| m -> begin
m
end)
end
| _53_1412 -> begin
FStar_Util.Inr (false)
end))
in (
# 869 "FStar.TypeChecker.Normalize.fst"
let rec matches = (fun t p -> (match (p) with
| [] -> begin
(norm_and_rebuild_match ())
end
| (p, wopt, b)::rest -> begin
(match ((matches_pat t p)) with
| FStar_Util.Inr (false) -> begin
(matches t rest)
end
| FStar_Util.Inr (true) -> begin
(norm_and_rebuild_match ())
end
| FStar_Util.Inl (s) -> begin
(
# 880 "FStar.TypeChecker.Normalize.fst"
let _53_1430 = (log cfg (fun _53_1429 -> (match (()) with
| () -> begin
(let _142_551 = (FStar_Syntax_Print.pat_to_string p)
in (let _142_550 = (let _142_549 = (FStar_List.map FStar_Syntax_Print.term_to_string s)
in (FStar_All.pipe_right _142_549 (FStar_String.concat "; ")))
in (FStar_Util.print2 "Matches pattern %s with subst = %s\n" _142_551 _142_550)))
end)))
in (
# 885 "FStar.TypeChecker.Normalize.fst"
let env = (FStar_List.fold_left (fun env t -> (let _142_556 = (let _142_555 = (let _142_554 = (FStar_Util.mk_ref (Some (([], t))))
in ([], t, _142_554))
in Clos (_142_555))
in (_142_556)::env)) env s)
in (let _142_557 = (guard_when_clause wopt b rest)
in (norm cfg env stack _142_557))))
end)
end))
in (matches t branches)))))))
end))

# 890 "FStar.TypeChecker.Normalize.fst"
let config : step Prims.list  ->  FStar_TypeChecker_Env.env  ->  cfg = (fun s e -> (
# 891 "FStar.TypeChecker.Normalize.fst"
let d = (match ((FStar_Util.find_map s (fun _53_5 -> (match (_53_5) with
| UnfoldUntil (k) -> begin
Some (k)
end
| _53_1441 -> begin
None
end)))) with
| Some (k) -> begin
FStar_TypeChecker_Env.Unfold (k)
end
| None -> begin
if (FStar_List.contains Inline s) then begin
FStar_TypeChecker_Env.OnlyInline
end else begin
FStar_TypeChecker_Env.NoDelta
end
end)
in {steps = s; tcenv = e; delta_level = d}))

# 898 "FStar.TypeChecker.Normalize.fst"
let normalize : steps  ->  FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun s e t -> (let _142_569 = (config s e)
in (norm _142_569 [] [] t)))

# 899 "FStar.TypeChecker.Normalize.fst"
let normalize_comp : steps  ->  FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun s e t -> (let _142_576 = (config s e)
in (norm_comp _142_576 [] t)))

# 900 "FStar.TypeChecker.Normalize.fst"
let normalize_universe : FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.universe  ->  FStar_Syntax_Syntax.universe = (fun env u -> (let _142_581 = (config [] env)
in (norm_universe _142_581 [] u)))

# 901 "FStar.TypeChecker.Normalize.fst"
let ghost_to_pure : FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun env c -> (let _142_586 = (config [] env)
in (ghost_to_pure_aux _142_586 [] c)))

# 903 "FStar.TypeChecker.Normalize.fst"
let term_to_string : FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.term  ->  Prims.string = (fun env t -> (let _142_591 = (normalize ((AllowUnboundUniverses)::[]) env t)
in (FStar_Syntax_Print.term_to_string _142_591)))

# 904 "FStar.TypeChecker.Normalize.fst"
let comp_to_string : FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.comp  ->  Prims.string = (fun env c -> (let _142_597 = (let _142_596 = (config ((AllowUnboundUniverses)::[]) env)
in (norm_comp _142_596 [] c))
in (FStar_Syntax_Print.comp_to_string _142_597)))

# 906 "FStar.TypeChecker.Normalize.fst"
let normalize_refinement : steps  ->  FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.typ = (fun steps env t0 -> (
# 907 "FStar.TypeChecker.Normalize.fst"
let t = (normalize (FStar_List.append steps ((Beta)::[])) env t0)
in (
# 908 "FStar.TypeChecker.Normalize.fst"
let rec aux = (fun t -> (
# 909 "FStar.TypeChecker.Normalize.fst"
let t = (FStar_Syntax_Subst.compress t)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_refine (x, phi) -> begin
(
# 912 "FStar.TypeChecker.Normalize.fst"
let t0 = (aux x.FStar_Syntax_Syntax.sort)
in (match (t0.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_refine (y, phi1) -> begin
(let _142_608 = (let _142_607 = (let _142_606 = (FStar_Syntax_Util.mk_conj phi1 phi)
in (y, _142_606))
in FStar_Syntax_Syntax.Tm_refine (_142_607))
in (mk _142_608 t0.FStar_Syntax_Syntax.pos))
end
| _53_1477 -> begin
t
end))
end
| _53_1479 -> begin
t
end)))
in (aux t))))

# 921 "FStar.TypeChecker.Normalize.fst"
let normalize_sigelt : steps  ->  FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.sigelt  ->  FStar_Syntax_Syntax.sigelt = (fun _53_1480 _53_1482 _53_1484 -> (FStar_All.failwith "NYI: normalize_sigelt"))

# 923 "FStar.TypeChecker.Normalize.fst"
let eta_expand : FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun _53_1486 t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_name (x) -> begin
(
# 926 "FStar.TypeChecker.Normalize.fst"
let _53_1493 = (FStar_Syntax_Util.arrow_formals_comp x.FStar_Syntax_Syntax.sort)
in (match (_53_1493) with
| (binders, c) -> begin
(match (binders) with
| [] -> begin
t
end
| _53_1496 -> begin
(
# 930 "FStar.TypeChecker.Normalize.fst"
let _53_1499 = (FStar_All.pipe_right binders FStar_Syntax_Util.args_of_binders)
in (match (_53_1499) with
| (binders, args) -> begin
(let _142_623 = (FStar_Syntax_Syntax.mk_Tm_app t args None t.FStar_Syntax_Syntax.pos)
in (let _142_622 = (let _142_621 = (FStar_All.pipe_right (FStar_Syntax_Util.lcomp_of_comp c) (fun _142_619 -> FStar_Util.Inl (_142_619)))
in (FStar_All.pipe_right _142_621 (fun _142_620 -> Some (_142_620))))
in (FStar_Syntax_Util.abs binders _142_623 _142_622)))
end))
end)
end))
end
| _53_1501 -> begin
(let _142_626 = (let _142_625 = (FStar_Syntax_Print.tag_of_term t)
in (let _142_624 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.format2 "NYI: eta_expand(%s) %s" _142_625 _142_624)))
in (FStar_All.failwith _142_626))
end))




