
open Prims

let no_free_vars : FStar_Syntax_Syntax.free_vars = {FStar_Syntax_Syntax.free_names = FStar_Syntax_Syntax.no_names; FStar_Syntax_Syntax.free_uvars = FStar_Syntax_Syntax.no_uvs; FStar_Syntax_Syntax.free_univs = FStar_Syntax_Syntax.no_universe_uvars}


let singleton_bv : FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.free_vars = (fun x -> (let _128_4 = (let _128_3 = (FStar_Syntax_Syntax.new_bv_set ())
in (FStar_Util.set_add x _128_3))
in {FStar_Syntax_Syntax.free_names = _128_4; FStar_Syntax_Syntax.free_uvars = FStar_Syntax_Syntax.no_uvs; FStar_Syntax_Syntax.free_univs = FStar_Syntax_Syntax.no_universe_uvars}))


let singleton_uv : ((FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax FStar_Syntax_Syntax.uvar_basis FStar_Unionfind.uvar * (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax)  ->  FStar_Syntax_Syntax.free_vars = (fun x -> (let _128_8 = (let _128_7 = (FStar_Syntax_Syntax.new_uv_set ())
in (FStar_Util.set_add x _128_7))
in {FStar_Syntax_Syntax.free_names = FStar_Syntax_Syntax.no_names; FStar_Syntax_Syntax.free_uvars = _128_8; FStar_Syntax_Syntax.free_univs = FStar_Syntax_Syntax.no_universe_uvars}))


let singleton_univ : FStar_Syntax_Syntax.universe_uvar  ->  FStar_Syntax_Syntax.free_vars = (fun x -> (let _128_12 = (let _128_11 = (FStar_Syntax_Syntax.new_universe_uvar_set ())
in (FStar_Util.set_add x _128_11))
in {FStar_Syntax_Syntax.free_names = FStar_Syntax_Syntax.no_names; FStar_Syntax_Syntax.free_uvars = FStar_Syntax_Syntax.no_uvs; FStar_Syntax_Syntax.free_univs = _128_12}))


let union : FStar_Syntax_Syntax.free_vars  ->  FStar_Syntax_Syntax.free_vars  ->  FStar_Syntax_Syntax.free_vars = (fun f1 f2 -> (let _128_19 = (FStar_Util.set_union f1.FStar_Syntax_Syntax.free_names f2.FStar_Syntax_Syntax.free_names)
in (let _128_18 = (FStar_Util.set_union f1.FStar_Syntax_Syntax.free_uvars f2.FStar_Syntax_Syntax.free_uvars)
in (let _128_17 = (FStar_Util.set_union f1.FStar_Syntax_Syntax.free_univs f2.FStar_Syntax_Syntax.free_univs)
in {FStar_Syntax_Syntax.free_names = _128_19; FStar_Syntax_Syntax.free_uvars = _128_18; FStar_Syntax_Syntax.free_univs = _128_17}))))


let rec free_univs : FStar_Syntax_Syntax.universe  ->  FStar_Syntax_Syntax.free_vars = (fun u -> (match ((FStar_Syntax_Subst.compress_univ u)) with
| (FStar_Syntax_Syntax.U_zero) | (FStar_Syntax_Syntax.U_bvar (_)) | (FStar_Syntax_Syntax.U_name (_)) | (FStar_Syntax_Syntax.U_unknown) -> begin
no_free_vars
end
| FStar_Syntax_Syntax.U_succ (u) -> begin
(free_univs u)
end
| FStar_Syntax_Syntax.U_max (us) -> begin
(FStar_List.fold_left (fun out x -> (let _128_24 = (free_univs x)
in (union out _128_24))) no_free_vars us)
end
| FStar_Syntax_Syntax.U_unif (u) -> begin
(singleton_univ u)
end))


let rec free_names_and_uvs' : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.free_vars = (fun tm -> (

let aux_binders = (fun bs acc -> (FStar_All.pipe_right bs (FStar_List.fold_left (fun n _36_31 -> (match (_36_31) with
| (x, _36_30) -> begin
(let _128_40 = (free_names_and_uvars x.FStar_Syntax_Syntax.sort)
in (union n _128_40))
end)) acc)))
in (

let t = (FStar_Syntax_Subst.compress tm)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_delayed (_36_34) -> begin
(FStar_All.failwith "Impossible")
end
| FStar_Syntax_Syntax.Tm_name (x) -> begin
(singleton_bv x)
end
| FStar_Syntax_Syntax.Tm_uvar (x, t) -> begin
(singleton_uv (x, t))
end
| FStar_Syntax_Syntax.Tm_type (u) -> begin
(free_univs u)
end
| (FStar_Syntax_Syntax.Tm_bvar (_)) | (FStar_Syntax_Syntax.Tm_fvar (_)) | (FStar_Syntax_Syntax.Tm_constant (_)) | (FStar_Syntax_Syntax.Tm_unknown) -> begin
no_free_vars
end
| FStar_Syntax_Syntax.Tm_uinst (t, us) -> begin
(

let f = (free_names_and_uvars t)
in (FStar_List.fold_left (fun out u -> (let _128_46 = (free_univs u)
in (union out _128_46))) f us))
end
| FStar_Syntax_Syntax.Tm_abs (bs, t, _36_64) -> begin
(let _128_47 = (free_names_and_uvars t)
in (aux_binders bs _128_47))
end
| FStar_Syntax_Syntax.Tm_arrow (bs, c) -> begin
(let _128_48 = (free_names_and_uvars_comp c)
in (aux_binders bs _128_48))
end
| FStar_Syntax_Syntax.Tm_refine (bv, t) -> begin
(let _128_49 = (free_names_and_uvars t)
in (aux_binders (((bv, None))::[]) _128_49))
end
| FStar_Syntax_Syntax.Tm_app (t, args) -> begin
(let _128_50 = (free_names_and_uvars t)
in (free_names_and_uvars_args args _128_50))
end
| FStar_Syntax_Syntax.Tm_match (t, pats) -> begin
(let _128_59 = (let _128_58 = (free_names_and_uvars t)
in (FStar_List.fold_left (fun n _36_87 -> (match (_36_87) with
| (p, wopt, t) -> begin
(

let n1 = (match (wopt) with
| None -> begin
no_free_vars
end
| Some (w) -> begin
(free_names_and_uvars w)
end)
in (

let n2 = (free_names_and_uvars t)
in (

let n = (let _128_53 = (union n2 n)
in (union n1 _128_53))
in (let _128_57 = (FStar_Syntax_Syntax.pat_bvs p)
in (FStar_All.pipe_right _128_57 (FStar_List.fold_left (fun n x -> (let _128_56 = (free_names_and_uvars x.FStar_Syntax_Syntax.sort)
in (union n _128_56))) n))))))
end)) _128_58))
in (FStar_All.pipe_right pats _128_59))
end
| FStar_Syntax_Syntax.Tm_ascribed (t1, FStar_Util.Inl (t2), _36_100) -> begin
(let _128_61 = (free_names_and_uvars t1)
in (let _128_60 = (free_names_and_uvars t2)
in (union _128_61 _128_60)))
end
| FStar_Syntax_Syntax.Tm_ascribed (t1, FStar_Util.Inr (c), _36_107) -> begin
(let _128_63 = (free_names_and_uvars t1)
in (let _128_62 = (free_names_and_uvars_comp c)
in (union _128_63 _128_62)))
end
| FStar_Syntax_Syntax.Tm_let (lbs, t) -> begin
(let _128_70 = (let _128_69 = (free_names_and_uvars t)
in (FStar_List.fold_left (fun n lb -> (let _128_68 = (let _128_67 = (free_names_and_uvars lb.FStar_Syntax_Syntax.lbtyp)
in (let _128_66 = (free_names_and_uvars lb.FStar_Syntax_Syntax.lbdef)
in (union _128_67 _128_66)))
in (union n _128_68))) _128_69))
in (FStar_All.pipe_right (Prims.snd lbs) _128_70))
end
| FStar_Syntax_Syntax.Tm_meta (t, FStar_Syntax_Syntax.Meta_pattern (args)) -> begin
(let _128_71 = (free_names_and_uvars t)
in (FStar_List.fold_right free_names_and_uvars_args args _128_71))
end
| FStar_Syntax_Syntax.Tm_meta (t, _36_123) -> begin
(free_names_and_uvars t)
end))))
and free_names_and_uvars : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.free_vars = (fun t -> (

let t = (FStar_Syntax_Subst.compress t)
in (match ((FStar_ST.read t.FStar_Syntax_Syntax.vars)) with
| Some (n) -> begin
if (should_invalidate_cache n) then begin
(

let _36_130 = (FStar_ST.op_Colon_Equals t.FStar_Syntax_Syntax.vars None)
in (free_names_and_uvars t))
end else begin
n
end
end
| _36_133 -> begin
(

let n = (free_names_and_uvs' t)
in (

let _36_135 = (FStar_ST.op_Colon_Equals t.FStar_Syntax_Syntax.vars (Some (n)))
in n))
end)))
and free_names_and_uvars_args : FStar_Syntax_Syntax.args  ->  FStar_Syntax_Syntax.free_vars  ->  FStar_Syntax_Syntax.free_vars = (fun args acc -> (FStar_All.pipe_right args (FStar_List.fold_left (fun n _36_143 -> (match (_36_143) with
| (x, _36_142) -> begin
(let _128_77 = (free_names_and_uvars x)
in (union n _128_77))
end)) acc)))
and free_names_and_uvars_binders = (fun bs acc -> (FStar_All.pipe_right bs (FStar_List.fold_left (fun n _36_150 -> (match (_36_150) with
| (x, _36_149) -> begin
(let _128_80 = (free_names_and_uvars x.FStar_Syntax_Syntax.sort)
in (union n _128_80))
end)) acc)))
and free_names_and_uvars_comp : FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.free_vars = (fun c -> (match ((FStar_ST.read c.FStar_Syntax_Syntax.vars)) with
| Some (n) -> begin
if (should_invalidate_cache n) then begin
(

let _36_154 = (FStar_ST.op_Colon_Equals c.FStar_Syntax_Syntax.vars None)
in (free_names_and_uvars_comp c))
end else begin
n
end
end
| _36_157 -> begin
(

let n = (match (c.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.GTotal (t)) | (FStar_Syntax_Syntax.Total (t)) -> begin
(free_names_and_uvars t)
end
| FStar_Syntax_Syntax.Comp (ct) -> begin
(let _128_82 = (free_names_and_uvars ct.FStar_Syntax_Syntax.result_typ)
in (free_names_and_uvars_args ct.FStar_Syntax_Syntax.effect_args _128_82))
end)
in (

let _36_164 = (FStar_ST.op_Colon_Equals c.FStar_Syntax_Syntax.vars (Some (n)))
in n))
end))
and should_invalidate_cache : FStar_Syntax_Syntax.free_vars  ->  Prims.bool = (fun n -> ((let _128_85 = (FStar_All.pipe_right n.FStar_Syntax_Syntax.free_uvars FStar_Util.set_elements)
in (FStar_All.pipe_right _128_85 (FStar_Util.for_some (fun _36_170 -> (match (_36_170) with
| (u, _36_169) -> begin
(match ((FStar_Unionfind.find u)) with
| FStar_Syntax_Syntax.Fixed (_36_172) -> begin
true
end
| _36_175 -> begin
false
end)
end))))) || (let _128_87 = (FStar_All.pipe_right n.FStar_Syntax_Syntax.free_univs FStar_Util.set_elements)
in (FStar_All.pipe_right _128_87 (FStar_Util.for_some (fun u -> (match ((FStar_Unionfind.find u)) with
| Some (_36_178) -> begin
true
end
| None -> begin
false
end)))))))


let names : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.bv FStar_Util.set = (fun t -> (let _128_90 = (free_names_and_uvars t)
in _128_90.FStar_Syntax_Syntax.free_names))


let uvars : FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.uvar * FStar_Syntax_Syntax.typ) FStar_Util.set = (fun t -> (let _128_93 = (free_names_and_uvars t)
in _128_93.FStar_Syntax_Syntax.free_uvars))


let univs : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.universe_uvar FStar_Util.set = (fun t -> (let _128_96 = (free_names_and_uvars t)
in _128_96.FStar_Syntax_Syntax.free_univs))


let names_of_binders : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.bv FStar_Util.set = (fun bs -> (let _128_99 = (free_names_and_uvars_binders bs no_free_vars)
in _128_99.FStar_Syntax_Syntax.free_names))




