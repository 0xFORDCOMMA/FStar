open Prims
type sort =
  | Bool_sort
  | Int_sort
  | String_sort
  | Term_sort
  | Fuel_sort
  | BitVec_sort of Prims.int
  | Array of (sort,sort) FStar_Pervasives_Native.tuple2
  | Arrow of (sort,sort) FStar_Pervasives_Native.tuple2
  | Sort of Prims.string[@@deriving show]
let uu___is_Bool_sort: sort -> Prims.bool =
  fun projectee  ->
    match projectee with | Bool_sort  -> true | uu____29 -> false
let uu___is_Int_sort: sort -> Prims.bool =
  fun projectee  ->
    match projectee with | Int_sort  -> true | uu____34 -> false
let uu___is_String_sort: sort -> Prims.bool =
  fun projectee  ->
    match projectee with | String_sort  -> true | uu____39 -> false
let uu___is_Term_sort: sort -> Prims.bool =
  fun projectee  ->
    match projectee with | Term_sort  -> true | uu____44 -> false
let uu___is_Fuel_sort: sort -> Prims.bool =
  fun projectee  ->
    match projectee with | Fuel_sort  -> true | uu____49 -> false
let uu___is_BitVec_sort: sort -> Prims.bool =
  fun projectee  ->
    match projectee with | BitVec_sort _0 -> true | uu____55 -> false
let __proj__BitVec_sort__item___0: sort -> Prims.int =
  fun projectee  -> match projectee with | BitVec_sort _0 -> _0
let uu___is_Array: sort -> Prims.bool =
  fun projectee  ->
    match projectee with | Array _0 -> true | uu____73 -> false
let __proj__Array__item___0:
  sort -> (sort,sort) FStar_Pervasives_Native.tuple2 =
  fun projectee  -> match projectee with | Array _0 -> _0
let uu___is_Arrow: sort -> Prims.bool =
  fun projectee  ->
    match projectee with | Arrow _0 -> true | uu____103 -> false
let __proj__Arrow__item___0:
  sort -> (sort,sort) FStar_Pervasives_Native.tuple2 =
  fun projectee  -> match projectee with | Arrow _0 -> _0
let uu___is_Sort: sort -> Prims.bool =
  fun projectee  ->
    match projectee with | Sort _0 -> true | uu____129 -> false
let __proj__Sort__item___0: sort -> Prims.string =
  fun projectee  -> match projectee with | Sort _0 -> _0
let rec strSort: sort -> Prims.string =
  fun x  ->
    match x with
    | Bool_sort  -> "Bool"
    | Int_sort  -> "Int"
    | Term_sort  -> "Term"
    | String_sort  -> "FString"
    | Fuel_sort  -> "Fuel"
    | BitVec_sort n1 ->
        let uu____143 = FStar_Util.string_of_int n1 in
        FStar_Util.format1 "(_ BitVec %s)" uu____143
    | Array (s1,s2) ->
        let uu____146 = strSort s1 in
        let uu____147 = strSort s2 in
        FStar_Util.format2 "(Array %s %s)" uu____146 uu____147
    | Arrow (s1,s2) ->
        let uu____150 = strSort s1 in
        let uu____151 = strSort s2 in
        FStar_Util.format2 "(%s -> %s)" uu____150 uu____151
    | Sort s -> s
type op =
  | TrueOp
  | FalseOp
  | Not
  | And
  | Or
  | Imp
  | Iff
  | Eq
  | LT
  | LTE
  | GT
  | GTE
  | Add
  | Sub
  | Div
  | Mul
  | Minus
  | Mod
  | BvAnd
  | BvXor
  | BvOr
  | BvShl
  | BvShr
  | BvUdiv
  | BvMod
  | BvMul
  | BvUlt
  | BvUext of Prims.int
  | NatToBv of Prims.int
  | BvToNat
  | ITE
  | Var of Prims.string[@@deriving show]
let uu___is_TrueOp: op -> Prims.bool =
  fun projectee  ->
    match projectee with | TrueOp  -> true | uu____169 -> false
let uu___is_FalseOp: op -> Prims.bool =
  fun projectee  ->
    match projectee with | FalseOp  -> true | uu____174 -> false
let uu___is_Not: op -> Prims.bool =
  fun projectee  -> match projectee with | Not  -> true | uu____179 -> false
let uu___is_And: op -> Prims.bool =
  fun projectee  -> match projectee with | And  -> true | uu____184 -> false
let uu___is_Or: op -> Prims.bool =
  fun projectee  -> match projectee with | Or  -> true | uu____189 -> false
let uu___is_Imp: op -> Prims.bool =
  fun projectee  -> match projectee with | Imp  -> true | uu____194 -> false
let uu___is_Iff: op -> Prims.bool =
  fun projectee  -> match projectee with | Iff  -> true | uu____199 -> false
let uu___is_Eq: op -> Prims.bool =
  fun projectee  -> match projectee with | Eq  -> true | uu____204 -> false
let uu___is_LT: op -> Prims.bool =
  fun projectee  -> match projectee with | LT  -> true | uu____209 -> false
let uu___is_LTE: op -> Prims.bool =
  fun projectee  -> match projectee with | LTE  -> true | uu____214 -> false
let uu___is_GT: op -> Prims.bool =
  fun projectee  -> match projectee with | GT  -> true | uu____219 -> false
let uu___is_GTE: op -> Prims.bool =
  fun projectee  -> match projectee with | GTE  -> true | uu____224 -> false
let uu___is_Add: op -> Prims.bool =
  fun projectee  -> match projectee with | Add  -> true | uu____229 -> false
let uu___is_Sub: op -> Prims.bool =
  fun projectee  -> match projectee with | Sub  -> true | uu____234 -> false
let uu___is_Div: op -> Prims.bool =
  fun projectee  -> match projectee with | Div  -> true | uu____239 -> false
let uu___is_Mul: op -> Prims.bool =
  fun projectee  -> match projectee with | Mul  -> true | uu____244 -> false
let uu___is_Minus: op -> Prims.bool =
  fun projectee  ->
    match projectee with | Minus  -> true | uu____249 -> false
let uu___is_Mod: op -> Prims.bool =
  fun projectee  -> match projectee with | Mod  -> true | uu____254 -> false
let uu___is_BvAnd: op -> Prims.bool =
  fun projectee  ->
    match projectee with | BvAnd  -> true | uu____259 -> false
let uu___is_BvXor: op -> Prims.bool =
  fun projectee  ->
    match projectee with | BvXor  -> true | uu____264 -> false
let uu___is_BvOr: op -> Prims.bool =
  fun projectee  -> match projectee with | BvOr  -> true | uu____269 -> false
let uu___is_BvShl: op -> Prims.bool =
  fun projectee  ->
    match projectee with | BvShl  -> true | uu____274 -> false
let uu___is_BvShr: op -> Prims.bool =
  fun projectee  ->
    match projectee with | BvShr  -> true | uu____279 -> false
let uu___is_BvUdiv: op -> Prims.bool =
  fun projectee  ->
    match projectee with | BvUdiv  -> true | uu____284 -> false
let uu___is_BvMod: op -> Prims.bool =
  fun projectee  ->
    match projectee with | BvMod  -> true | uu____289 -> false
let uu___is_BvMul: op -> Prims.bool =
  fun projectee  ->
    match projectee with | BvMul  -> true | uu____294 -> false
let uu___is_BvUlt: op -> Prims.bool =
  fun projectee  ->
    match projectee with | BvUlt  -> true | uu____299 -> false
let uu___is_BvUext: op -> Prims.bool =
  fun projectee  ->
    match projectee with | BvUext _0 -> true | uu____305 -> false
let __proj__BvUext__item___0: op -> Prims.int =
  fun projectee  -> match projectee with | BvUext _0 -> _0
let uu___is_NatToBv: op -> Prims.bool =
  fun projectee  ->
    match projectee with | NatToBv _0 -> true | uu____319 -> false
let __proj__NatToBv__item___0: op -> Prims.int =
  fun projectee  -> match projectee with | NatToBv _0 -> _0
let uu___is_BvToNat: op -> Prims.bool =
  fun projectee  ->
    match projectee with | BvToNat  -> true | uu____332 -> false
let uu___is_ITE: op -> Prims.bool =
  fun projectee  -> match projectee with | ITE  -> true | uu____337 -> false
let uu___is_Var: op -> Prims.bool =
  fun projectee  ->
    match projectee with | Var _0 -> true | uu____343 -> false
let __proj__Var__item___0: op -> Prims.string =
  fun projectee  -> match projectee with | Var _0 -> _0
type qop =
  | Forall
  | Exists[@@deriving show]
let uu___is_Forall: qop -> Prims.bool =
  fun projectee  ->
    match projectee with | Forall  -> true | uu____356 -> false
let uu___is_Exists: qop -> Prims.bool =
  fun projectee  ->
    match projectee with | Exists  -> true | uu____361 -> false
type term' =
  | Integer of Prims.string
  | BoundV of Prims.int
  | FreeV of (Prims.string,sort) FStar_Pervasives_Native.tuple2
  | App of (op,term Prims.list) FStar_Pervasives_Native.tuple2
  | Quant of
  (qop,term Prims.list Prims.list,Prims.int FStar_Pervasives_Native.option,
  sort Prims.list,term) FStar_Pervasives_Native.tuple5
  | Let of (term Prims.list,term) FStar_Pervasives_Native.tuple2
  | Labeled of (term,Prims.string,FStar_Range.range)
  FStar_Pervasives_Native.tuple3
  | LblPos of (term,Prims.string) FStar_Pervasives_Native.tuple2[@@deriving
                                                                  show]
and term =
  {
  tm: term';
  freevars:
    (Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list
      FStar_Syntax_Syntax.memo;
  rng: FStar_Range.range;}[@@deriving show]
let uu___is_Integer: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Integer _0 -> true | uu____476 -> false
let __proj__Integer__item___0: term' -> Prims.string =
  fun projectee  -> match projectee with | Integer _0 -> _0
let uu___is_BoundV: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | BoundV _0 -> true | uu____490 -> false
let __proj__BoundV__item___0: term' -> Prims.int =
  fun projectee  -> match projectee with | BoundV _0 -> _0
let uu___is_FreeV: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | FreeV _0 -> true | uu____508 -> false
let __proj__FreeV__item___0:
  term' -> (Prims.string,sort) FStar_Pervasives_Native.tuple2 =
  fun projectee  -> match projectee with | FreeV _0 -> _0
let uu___is_App: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | App _0 -> true | uu____540 -> false
let __proj__App__item___0:
  term' -> (op,term Prims.list) FStar_Pervasives_Native.tuple2 =
  fun projectee  -> match projectee with | App _0 -> _0
let uu___is_Quant: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Quant _0 -> true | uu____590 -> false
let __proj__Quant__item___0:
  term' ->
    (qop,term Prims.list Prims.list,Prims.int FStar_Pervasives_Native.option,
      sort Prims.list,term) FStar_Pervasives_Native.tuple5
  = fun projectee  -> match projectee with | Quant _0 -> _0
let uu___is_Let: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Let _0 -> true | uu____664 -> false
let __proj__Let__item___0:
  term' -> (term Prims.list,term) FStar_Pervasives_Native.tuple2 =
  fun projectee  -> match projectee with | Let _0 -> _0
let uu___is_Labeled: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Labeled _0 -> true | uu____702 -> false
let __proj__Labeled__item___0:
  term' ->
    (term,Prims.string,FStar_Range.range) FStar_Pervasives_Native.tuple3
  = fun projectee  -> match projectee with | Labeled _0 -> _0
let uu___is_LblPos: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | LblPos _0 -> true | uu____738 -> false
let __proj__LblPos__item___0:
  term' -> (term,Prims.string) FStar_Pervasives_Native.tuple2 =
  fun projectee  -> match projectee with | LblPos _0 -> _0
let __proj__Mkterm__item__tm: term -> term' =
  fun projectee  ->
    match projectee with
    | { tm = __fname__tm; freevars = __fname__freevars; rng = __fname__rng;_}
        -> __fname__tm
let __proj__Mkterm__item__freevars:
  term ->
    (Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list
      FStar_Syntax_Syntax.memo
  =
  fun projectee  ->
    match projectee with
    | { tm = __fname__tm; freevars = __fname__freevars; rng = __fname__rng;_}
        -> __fname__freevars
let __proj__Mkterm__item__rng: term -> FStar_Range.range =
  fun projectee  ->
    match projectee with
    | { tm = __fname__tm; freevars = __fname__freevars; rng = __fname__rng;_}
        -> __fname__rng
type pat = term[@@deriving show]
type fv = (Prims.string,sort) FStar_Pervasives_Native.tuple2[@@deriving show]
type fvs = (Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list
[@@deriving show]
type caption = Prims.string FStar_Pervasives_Native.option[@@deriving show]
type binders = (Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list
[@@deriving show]
type constructor_field =
  (Prims.string,sort,Prims.bool) FStar_Pervasives_Native.tuple3[@@deriving
                                                                 show]
type constructor_t =
  (Prims.string,constructor_field Prims.list,sort,Prims.int,Prims.bool)
    FStar_Pervasives_Native.tuple5[@@deriving show]
type constructors = constructor_t Prims.list[@@deriving show]
type fact_db_id =
  | Name of FStar_Ident.lid
  | Namespace of FStar_Ident.lid
  | Tag of Prims.string[@@deriving show]
let uu___is_Name: fact_db_id -> Prims.bool =
  fun projectee  ->
    match projectee with | Name _0 -> true | uu____896 -> false
let __proj__Name__item___0: fact_db_id -> FStar_Ident.lid =
  fun projectee  -> match projectee with | Name _0 -> _0
let uu___is_Namespace: fact_db_id -> Prims.bool =
  fun projectee  ->
    match projectee with | Namespace _0 -> true | uu____910 -> false
let __proj__Namespace__item___0: fact_db_id -> FStar_Ident.lid =
  fun projectee  -> match projectee with | Namespace _0 -> _0
let uu___is_Tag: fact_db_id -> Prims.bool =
  fun projectee  ->
    match projectee with | Tag _0 -> true | uu____924 -> false
let __proj__Tag__item___0: fact_db_id -> Prims.string =
  fun projectee  -> match projectee with | Tag _0 -> _0
type assumption =
  {
  assumption_term: term;
  assumption_caption: caption;
  assumption_name: Prims.string;
  assumption_fact_ids: fact_db_id Prims.list;}[@@deriving show]
let __proj__Mkassumption__item__assumption_term: assumption -> term =
  fun projectee  ->
    match projectee with
    | { assumption_term = __fname__assumption_term;
        assumption_caption = __fname__assumption_caption;
        assumption_name = __fname__assumption_name;
        assumption_fact_ids = __fname__assumption_fact_ids;_} ->
        __fname__assumption_term
let __proj__Mkassumption__item__assumption_caption: assumption -> caption =
  fun projectee  ->
    match projectee with
    | { assumption_term = __fname__assumption_term;
        assumption_caption = __fname__assumption_caption;
        assumption_name = __fname__assumption_name;
        assumption_fact_ids = __fname__assumption_fact_ids;_} ->
        __fname__assumption_caption
let __proj__Mkassumption__item__assumption_name: assumption -> Prims.string =
  fun projectee  ->
    match projectee with
    | { assumption_term = __fname__assumption_term;
        assumption_caption = __fname__assumption_caption;
        assumption_name = __fname__assumption_name;
        assumption_fact_ids = __fname__assumption_fact_ids;_} ->
        __fname__assumption_name
let __proj__Mkassumption__item__assumption_fact_ids:
  assumption -> fact_db_id Prims.list =
  fun projectee  ->
    match projectee with
    | { assumption_term = __fname__assumption_term;
        assumption_caption = __fname__assumption_caption;
        assumption_name = __fname__assumption_name;
        assumption_fact_ids = __fname__assumption_fact_ids;_} ->
        __fname__assumption_fact_ids
type decl =
  | DefPrelude
  | DeclFun of (Prims.string,sort Prims.list,sort,caption)
  FStar_Pervasives_Native.tuple4
  | DefineFun of (Prims.string,sort Prims.list,sort,term,caption)
  FStar_Pervasives_Native.tuple5
  | Assume of assumption
  | Caption of Prims.string
  | Eval of term
  | Echo of Prims.string
  | RetainAssumptions of Prims.string Prims.list
  | Push
  | Pop
  | CheckSat
  | GetUnsatCore
  | SetOption of (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2
  | GetStatistics
  | GetReasonUnknown[@@deriving show]
let uu___is_DefPrelude: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | DefPrelude  -> true | uu____1059 -> false
let uu___is_DeclFun: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | DeclFun _0 -> true | uu____1075 -> false
let __proj__DeclFun__item___0:
  decl ->
    (Prims.string,sort Prims.list,sort,caption)
      FStar_Pervasives_Native.tuple4
  = fun projectee  -> match projectee with | DeclFun _0 -> _0
let uu___is_DefineFun: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | DefineFun _0 -> true | uu____1131 -> false
let __proj__DefineFun__item___0:
  decl ->
    (Prims.string,sort Prims.list,sort,term,caption)
      FStar_Pervasives_Native.tuple5
  = fun projectee  -> match projectee with | DefineFun _0 -> _0
let uu___is_Assume: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | Assume _0 -> true | uu____1181 -> false
let __proj__Assume__item___0: decl -> assumption =
  fun projectee  -> match projectee with | Assume _0 -> _0
let uu___is_Caption: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | Caption _0 -> true | uu____1195 -> false
let __proj__Caption__item___0: decl -> Prims.string =
  fun projectee  -> match projectee with | Caption _0 -> _0
let uu___is_Eval: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | Eval _0 -> true | uu____1209 -> false
let __proj__Eval__item___0: decl -> term =
  fun projectee  -> match projectee with | Eval _0 -> _0
let uu___is_Echo: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | Echo _0 -> true | uu____1223 -> false
let __proj__Echo__item___0: decl -> Prims.string =
  fun projectee  -> match projectee with | Echo _0 -> _0
let uu___is_RetainAssumptions: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | RetainAssumptions _0 -> true | uu____1239 -> false
let __proj__RetainAssumptions__item___0: decl -> Prims.string Prims.list =
  fun projectee  -> match projectee with | RetainAssumptions _0 -> _0
let uu___is_Push: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | Push  -> true | uu____1258 -> false
let uu___is_Pop: decl -> Prims.bool =
  fun projectee  -> match projectee with | Pop  -> true | uu____1263 -> false
let uu___is_CheckSat: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | CheckSat  -> true | uu____1268 -> false
let uu___is_GetUnsatCore: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | GetUnsatCore  -> true | uu____1273 -> false
let uu___is_SetOption: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | SetOption _0 -> true | uu____1283 -> false
let __proj__SetOption__item___0:
  decl -> (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2 =
  fun projectee  -> match projectee with | SetOption _0 -> _0
let uu___is_GetStatistics: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | GetStatistics  -> true | uu____1308 -> false
let uu___is_GetReasonUnknown: decl -> Prims.bool =
  fun projectee  ->
    match projectee with | GetReasonUnknown  -> true | uu____1313 -> false
type decls_t = decl Prims.list[@@deriving show]
type error_label =
  (fv,Prims.string,FStar_Range.range) FStar_Pervasives_Native.tuple3[@@deriving
                                                                    show]
type error_labels = error_label Prims.list[@@deriving show]
let fv_eq: fv -> fv -> Prims.bool =
  fun x  ->
    fun y  ->
      (FStar_Pervasives_Native.fst x) = (FStar_Pervasives_Native.fst y)
let fv_sort:
  'Auu____1338 'Auu____1339 .
    ('Auu____1339,'Auu____1338) FStar_Pervasives_Native.tuple2 ->
      'Auu____1338
  = fun x  -> FStar_Pervasives_Native.snd x
let freevar_eq: term -> term -> Prims.bool =
  fun x  ->
    fun y  ->
      match ((x.tm), (y.tm)) with
      | (FreeV x1,FreeV y1) -> fv_eq x1 y1
      | uu____1370 -> false
let freevar_sort: term -> sort =
  fun uu___107_1378  ->
    match uu___107_1378 with
    | { tm = FreeV x; freevars = uu____1380; rng = uu____1381;_} -> fv_sort x
    | uu____1394 -> failwith "impossible"
let fv_of_term: term -> fv =
  fun uu___108_1398  ->
    match uu___108_1398 with
    | { tm = FreeV fv; freevars = uu____1400; rng = uu____1401;_} -> fv
    | uu____1414 -> failwith "impossible"
let rec freevars:
  term -> (Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list =
  fun t  ->
    match t.tm with
    | Integer uu____1431 -> []
    | BoundV uu____1436 -> []
    | FreeV fv -> [fv]
    | App (uu____1454,tms) -> FStar_List.collect freevars tms
    | Quant (uu____1464,uu____1465,uu____1466,uu____1467,t1) -> freevars t1
    | Labeled (t1,uu____1486,uu____1487) -> freevars t1
    | LblPos (t1,uu____1489) -> freevars t1
    | Let (es,body) -> FStar_List.collect freevars (body :: es)
let free_variables: term -> fvs =
  fun t  ->
    let uu____1504 = FStar_ST.op_Bang t.freevars in
    match uu____1504 with
    | FStar_Pervasives_Native.Some b -> b
    | FStar_Pervasives_Native.None  ->
        let fvs =
          let uu____1597 = freevars t in
          FStar_Util.remove_dups fv_eq uu____1597 in
        (FStar_ST.op_Colon_Equals t.freevars
           (FStar_Pervasives_Native.Some fvs);
         fvs)
let qop_to_string: qop -> Prims.string =
  fun uu___109_1668  ->
    match uu___109_1668 with | Forall  -> "forall" | Exists  -> "exists"
let op_to_string: op -> Prims.string =
  fun uu___110_1672  ->
    match uu___110_1672 with
    | TrueOp  -> "true"
    | FalseOp  -> "false"
    | Not  -> "not"
    | And  -> "and"
    | Or  -> "or"
    | Imp  -> "implies"
    | Iff  -> "iff"
    | Eq  -> "="
    | LT  -> "<"
    | LTE  -> "<="
    | GT  -> ">"
    | GTE  -> ">="
    | Add  -> "+"
    | Sub  -> "-"
    | Div  -> "div"
    | Mul  -> "*"
    | Minus  -> "-"
    | Mod  -> "mod"
    | ITE  -> "ite"
    | BvAnd  -> "bvand"
    | BvXor  -> "bvxor"
    | BvOr  -> "bvor"
    | BvShl  -> "bvshl"
    | BvShr  -> "bvlshr"
    | BvUdiv  -> "bvudiv"
    | BvMod  -> "bvurem"
    | BvMul  -> "bvmul"
    | BvUlt  -> "bvult"
    | BvToNat  -> "bv2int"
    | BvUext n1 ->
        let uu____1674 = FStar_Util.string_of_int n1 in
        FStar_Util.format1 "(_ zero_extend %s)" uu____1674
    | NatToBv n1 ->
        let uu____1676 = FStar_Util.string_of_int n1 in
        FStar_Util.format1 "(_ int2bv %s)" uu____1676
    | Var s -> s
let weightToSmt: Prims.int FStar_Pervasives_Native.option -> Prims.string =
  fun uu___111_1683  ->
    match uu___111_1683 with
    | FStar_Pervasives_Native.None  -> ""
    | FStar_Pervasives_Native.Some i ->
        let uu____1687 = FStar_Util.string_of_int i in
        FStar_Util.format1 ":weight %s\n" uu____1687
let rec hash_of_term': term' -> Prims.string =
  fun t  ->
    match t with
    | Integer i -> i
    | BoundV i ->
        let uu____1695 = FStar_Util.string_of_int i in
        Prims.strcat "@" uu____1695
    | FreeV x ->
        let uu____1701 =
          let uu____1702 = strSort (FStar_Pervasives_Native.snd x) in
          Prims.strcat ":" uu____1702 in
        Prims.strcat (FStar_Pervasives_Native.fst x) uu____1701
    | App (op,tms) ->
        let uu____1709 =
          let uu____1710 = op_to_string op in
          let uu____1711 =
            let uu____1712 =
              let uu____1713 = FStar_List.map hash_of_term tms in
              FStar_All.pipe_right uu____1713 (FStar_String.concat " ") in
            Prims.strcat uu____1712 ")" in
          Prims.strcat uu____1710 uu____1711 in
        Prims.strcat "(" uu____1709
    | Labeled (t1,r1,r2) ->
        let uu____1721 = hash_of_term t1 in
        let uu____1722 =
          let uu____1723 = FStar_Range.string_of_range r2 in
          Prims.strcat r1 uu____1723 in
        Prims.strcat uu____1721 uu____1722
    | LblPos (t1,r) ->
        let uu____1726 =
          let uu____1727 = hash_of_term t1 in
          Prims.strcat uu____1727
            (Prims.strcat " :lblpos " (Prims.strcat r ")")) in
        Prims.strcat "(! " uu____1726
    | Quant (qop,pats,wopt,sorts,body) ->
        let uu____1749 =
          let uu____1750 =
            let uu____1751 =
              let uu____1752 =
                let uu____1753 = FStar_List.map strSort sorts in
                FStar_All.pipe_right uu____1753 (FStar_String.concat " ") in
              let uu____1758 =
                let uu____1759 =
                  let uu____1760 = hash_of_term body in
                  let uu____1761 =
                    let uu____1762 =
                      let uu____1763 = weightToSmt wopt in
                      let uu____1764 =
                        let uu____1765 =
                          let uu____1766 =
                            let uu____1767 =
                              FStar_All.pipe_right pats
                                (FStar_List.map
                                   (fun pats1  ->
                                      let uu____1783 =
                                        FStar_List.map hash_of_term pats1 in
                                      FStar_All.pipe_right uu____1783
                                        (FStar_String.concat " "))) in
                            FStar_All.pipe_right uu____1767
                              (FStar_String.concat "; ") in
                          Prims.strcat uu____1766 "))" in
                        Prims.strcat " " uu____1765 in
                      Prims.strcat uu____1763 uu____1764 in
                    Prims.strcat " " uu____1762 in
                  Prims.strcat uu____1760 uu____1761 in
                Prims.strcat ")(! " uu____1759 in
              Prims.strcat uu____1752 uu____1758 in
            Prims.strcat " (" uu____1751 in
          Prims.strcat (qop_to_string qop) uu____1750 in
        Prims.strcat "(" uu____1749
    | Let (es,body) ->
        let uu____1796 =
          let uu____1797 =
            let uu____1798 = FStar_List.map hash_of_term es in
            FStar_All.pipe_right uu____1798 (FStar_String.concat " ") in
          let uu____1803 =
            let uu____1804 =
              let uu____1805 = hash_of_term body in
              Prims.strcat uu____1805 ")" in
            Prims.strcat ") " uu____1804 in
          Prims.strcat uu____1797 uu____1803 in
        Prims.strcat "(let (" uu____1796
and hash_of_term: term -> Prims.string = fun tm  -> hash_of_term' tm.tm
let mkBoxFunctions:
  Prims.string -> (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2
  = fun s  -> (s, (Prims.strcat s "_proj_0"))
let boxIntFun: (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2 =
  mkBoxFunctions "BoxInt"
let boxBoolFun: (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2 =
  mkBoxFunctions "BoxBool"
let boxStringFun: (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2
  = mkBoxFunctions "BoxString"
let boxBitVecFun:
  Prims.int -> (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2 =
  fun sz  ->
    let uu____1835 =
      let uu____1836 = FStar_Util.string_of_int sz in
      Prims.strcat "BoxBitVec" uu____1836 in
    mkBoxFunctions uu____1835
let isInjective: Prims.string -> Prims.bool =
  fun s  ->
    if (FStar_String.length s) >= (Prims.parse_int "3")
    then
      (let uu____1843 =
         FStar_String.substring s (Prims.parse_int "0") (Prims.parse_int "3") in
       uu____1843 = "Box") &&
        (let uu____1845 =
           let uu____1846 = FStar_String.list_of_string s in
           FStar_List.existsML (fun c  -> c = 46) uu____1846 in
         Prims.op_Negation uu____1845)
    else false
let mk: term' -> FStar_Range.range -> term =
  fun t  ->
    fun r  ->
      let uu____1869 = FStar_Util.mk_ref FStar_Pervasives_Native.None in
      { tm = t; freevars = uu____1869; rng = r }
let mkTrue: FStar_Range.range -> term = fun r  -> mk (App (TrueOp, [])) r
let mkFalse: FStar_Range.range -> term = fun r  -> mk (App (FalseOp, [])) r
let mkInteger: Prims.string -> FStar_Range.range -> term =
  fun i  ->
    fun r  ->
      let uu____1926 =
        let uu____1927 = FStar_Util.ensure_decimal i in Integer uu____1927 in
      mk uu____1926 r
let mkInteger': Prims.int -> FStar_Range.range -> term =
  fun i  ->
    fun r  ->
      let uu____1936 = FStar_Util.string_of_int i in mkInteger uu____1936 r
let mkBoundV: Prims.int -> FStar_Range.range -> term =
  fun i  -> fun r  -> mk (BoundV i) r
let mkFreeV:
  (Prims.string,sort) FStar_Pervasives_Native.tuple2 ->
    FStar_Range.range -> term
  = fun x  -> fun r  -> mk (FreeV x) r
let mkApp':
  (op,term Prims.list) FStar_Pervasives_Native.tuple2 ->
    FStar_Range.range -> term
  = fun f  -> fun r  -> mk (App f) r
let mkApp:
  (Prims.string,term Prims.list) FStar_Pervasives_Native.tuple2 ->
    FStar_Range.range -> term
  =
  fun uu____1993  ->
    fun r  -> match uu____1993 with | (s,args) -> mk (App ((Var s), args)) r
let mkNot: term -> FStar_Range.range -> term =
  fun t  ->
    fun r  ->
      match t.tm with
      | App (TrueOp ,uu____2017) -> mkFalse r
      | App (FalseOp ,uu____2022) -> mkTrue r
      | uu____2027 -> mkApp' (Not, [t]) r
let mkAnd:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  fun uu____2040  ->
    fun r  ->
      match uu____2040 with
      | (t1,t2) ->
          (match ((t1.tm), (t2.tm)) with
           | (App (TrueOp ,uu____2048),uu____2049) -> t2
           | (uu____2054,App (TrueOp ,uu____2055)) -> t1
           | (App (FalseOp ,uu____2060),uu____2061) -> mkFalse r
           | (uu____2066,App (FalseOp ,uu____2067)) -> mkFalse r
           | (App (And ,ts1),App (And ,ts2)) ->
               mkApp' (And, (FStar_List.append ts1 ts2)) r
           | (uu____2084,App (And ,ts2)) -> mkApp' (And, (t1 :: ts2)) r
           | (App (And ,ts1),uu____2093) ->
               mkApp' (And, (FStar_List.append ts1 [t2])) r
           | uu____2100 -> mkApp' (And, [t1; t2]) r)
let mkOr:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  fun uu____2117  ->
    fun r  ->
      match uu____2117 with
      | (t1,t2) ->
          (match ((t1.tm), (t2.tm)) with
           | (App (TrueOp ,uu____2125),uu____2126) -> mkTrue r
           | (uu____2131,App (TrueOp ,uu____2132)) -> mkTrue r
           | (App (FalseOp ,uu____2137),uu____2138) -> t2
           | (uu____2143,App (FalseOp ,uu____2144)) -> t1
           | (App (Or ,ts1),App (Or ,ts2)) ->
               mkApp' (Or, (FStar_List.append ts1 ts2)) r
           | (uu____2161,App (Or ,ts2)) -> mkApp' (Or, (t1 :: ts2)) r
           | (App (Or ,ts1),uu____2170) ->
               mkApp' (Or, (FStar_List.append ts1 [t2])) r
           | uu____2177 -> mkApp' (Or, [t1; t2]) r)
let mkImp:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  fun uu____2194  ->
    fun r  ->
      match uu____2194 with
      | (t1,t2) ->
          (match ((t1.tm), (t2.tm)) with
           | (uu____2202,App (TrueOp ,uu____2203)) -> mkTrue r
           | (App (FalseOp ,uu____2208),uu____2209) -> mkTrue r
           | (App (TrueOp ,uu____2214),uu____2215) -> t2
           | (uu____2220,App (Imp ,t1'::t2'::[])) ->
               let uu____2225 =
                 let uu____2232 =
                   let uu____2235 = mkAnd (t1, t1') r in [uu____2235; t2'] in
                 (Imp, uu____2232) in
               mkApp' uu____2225 r
           | uu____2238 -> mkApp' (Imp, [t1; t2]) r)
let mk_bin_op:
  op ->
    (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term
  =
  fun op  ->
    fun uu____2259  ->
      fun r  -> match uu____2259 with | (t1,t2) -> mkApp' (op, [t1; t2]) r
let mkMinus: term -> FStar_Range.range -> term =
  fun t  -> fun r  -> mkApp' (Minus, [t]) r
let mkNatToBv: Prims.int -> term -> FStar_Range.range -> term =
  fun sz  -> fun t  -> fun r  -> mkApp' ((NatToBv sz), [t]) r
let mkBvUext: Prims.int -> term -> FStar_Range.range -> term =
  fun sz  -> fun t  -> fun r  -> mkApp' ((BvUext sz), [t]) r
let mkBvToNat: term -> FStar_Range.range -> term =
  fun t  -> fun r  -> mkApp' (BvToNat, [t]) r
let mkBvAnd:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op BvAnd
let mkBvXor:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op BvXor
let mkBvOr:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op BvOr
let mkBvShl:
  Prims.int ->
    (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term
  =
  fun sz  ->
    fun uu____2361  ->
      fun r  ->
        match uu____2361 with
        | (t1,t2) ->
            let uu____2369 =
              let uu____2376 =
                let uu____2379 =
                  let uu____2382 = mkNatToBv sz t2 r in [uu____2382] in
                t1 :: uu____2379 in
              (BvShl, uu____2376) in
            mkApp' uu____2369 r
let mkBvShr:
  Prims.int ->
    (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term
  =
  fun sz  ->
    fun uu____2399  ->
      fun r  ->
        match uu____2399 with
        | (t1,t2) ->
            let uu____2407 =
              let uu____2414 =
                let uu____2417 =
                  let uu____2420 = mkNatToBv sz t2 r in [uu____2420] in
                t1 :: uu____2417 in
              (BvShr, uu____2414) in
            mkApp' uu____2407 r
let mkBvUdiv:
  Prims.int ->
    (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term
  =
  fun sz  ->
    fun uu____2437  ->
      fun r  ->
        match uu____2437 with
        | (t1,t2) ->
            let uu____2445 =
              let uu____2452 =
                let uu____2455 =
                  let uu____2458 = mkNatToBv sz t2 r in [uu____2458] in
                t1 :: uu____2455 in
              (BvUdiv, uu____2452) in
            mkApp' uu____2445 r
let mkBvMod:
  Prims.int ->
    (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term
  =
  fun sz  ->
    fun uu____2475  ->
      fun r  ->
        match uu____2475 with
        | (t1,t2) ->
            let uu____2483 =
              let uu____2490 =
                let uu____2493 =
                  let uu____2496 = mkNatToBv sz t2 r in [uu____2496] in
                t1 :: uu____2493 in
              (BvMod, uu____2490) in
            mkApp' uu____2483 r
let mkBvMul:
  Prims.int ->
    (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term
  =
  fun sz  ->
    fun uu____2513  ->
      fun r  ->
        match uu____2513 with
        | (t1,t2) ->
            let uu____2521 =
              let uu____2528 =
                let uu____2531 =
                  let uu____2534 = mkNatToBv sz t2 r in [uu____2534] in
                t1 :: uu____2531 in
              (BvMul, uu____2528) in
            mkApp' uu____2521 r
let mkBvUlt:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op BvUlt
let mkIff:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op Iff
let mkEq:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  fun uu____2567  ->
    fun r  ->
      match uu____2567 with
      | (t1,t2) ->
          (match ((t1.tm), (t2.tm)) with
           | (App (Var f1,s1::[]),App (Var f2,s2::[])) when
               (f1 = f2) && (isInjective f1) -> mk_bin_op Eq (s1, s2) r
           | uu____2583 -> mk_bin_op Eq (t1, t2) r)
let mkLT:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op LT
let mkLTE:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op LTE
let mkGT:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op GT
let mkGTE:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op GTE
let mkAdd:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op Add
let mkSub:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op Sub
let mkDiv:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op Div
let mkMul:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op Mul
let mkMod:
  (term,term) FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term =
  mk_bin_op Mod
let mkITE:
  (term,term,term) FStar_Pervasives_Native.tuple3 ->
    FStar_Range.range -> term
  =
  fun uu____2690  ->
    fun r  ->
      match uu____2690 with
      | (t1,t2,t3) ->
          (match t1.tm with
           | App (TrueOp ,uu____2701) -> t2
           | App (FalseOp ,uu____2706) -> t3
           | uu____2711 ->
               (match ((t2.tm), (t3.tm)) with
                | (App (TrueOp ,uu____2712),App (TrueOp ,uu____2713)) ->
                    mkTrue r
                | (App (TrueOp ,uu____2722),uu____2723) ->
                    let uu____2728 =
                      let uu____2733 = mkNot t1 t1.rng in (uu____2733, t3) in
                    mkImp uu____2728 r
                | (uu____2734,App (TrueOp ,uu____2735)) -> mkImp (t1, t2) r
                | (uu____2740,uu____2741) -> mkApp' (ITE, [t1; t2; t3]) r))
let mkCases: term Prims.list -> FStar_Range.range -> term =
  fun t  ->
    fun r  ->
      match t with
      | [] -> failwith "Impos"
      | hd1::tl1 ->
          FStar_List.fold_left (fun out  -> fun t1  -> mkAnd (out, t1) r) hd1
            tl1
let mkQuant:
  (qop,term Prims.list Prims.list,Prims.int FStar_Pervasives_Native.option,
    sort Prims.list,term) FStar_Pervasives_Native.tuple5 ->
    FStar_Range.range -> term
  =
  fun uu____2788  ->
    fun r  ->
      match uu____2788 with
      | (qop,pats,wopt,vars,body) ->
          if (FStar_List.length vars) = (Prims.parse_int "0")
          then body
          else
            (match body.tm with
             | App (TrueOp ,uu____2830) -> body
             | uu____2835 -> mk (Quant (qop, pats, wopt, vars, body)) r)
let mkLet:
  (term Prims.list,term) FStar_Pervasives_Native.tuple2 ->
    FStar_Range.range -> term
  =
  fun uu____2856  ->
    fun r  ->
      match uu____2856 with
      | (es,body) ->
          if (FStar_List.length es) = (Prims.parse_int "0")
          then body
          else mk (Let (es, body)) r
let abstr: fv Prims.list -> term -> term =
  fun fvs  ->
    fun t  ->
      let nvars = FStar_List.length fvs in
      let index_of fv =
        let uu____2892 = FStar_Util.try_find_index (fv_eq fv) fvs in
        match uu____2892 with
        | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
        | FStar_Pervasives_Native.Some i ->
            FStar_Pervasives_Native.Some
              (nvars - (i + (Prims.parse_int "1"))) in
      let rec aux ix t1 =
        let uu____2911 = FStar_ST.op_Bang t1.freevars in
        match uu____2911 with
        | FStar_Pervasives_Native.Some [] -> t1
        | uu____2992 ->
            (match t1.tm with
             | Integer uu____3001 -> t1
             | BoundV uu____3002 -> t1
             | FreeV x ->
                 let uu____3008 = index_of x in
                 (match uu____3008 with
                  | FStar_Pervasives_Native.None  -> t1
                  | FStar_Pervasives_Native.Some i ->
                      mkBoundV (i + ix) t1.rng)
             | App (op,tms) ->
                 let uu____3018 =
                   let uu____3025 = FStar_List.map (aux ix) tms in
                   (op, uu____3025) in
                 mkApp' uu____3018 t1.rng
             | Labeled (t2,r1,r2) ->
                 let uu____3033 =
                   let uu____3034 =
                     let uu____3041 = aux ix t2 in (uu____3041, r1, r2) in
                   Labeled uu____3034 in
                 mk uu____3033 t2.rng
             | LblPos (t2,r) ->
                 let uu____3044 =
                   let uu____3045 =
                     let uu____3050 = aux ix t2 in (uu____3050, r) in
                   LblPos uu____3045 in
                 mk uu____3044 t2.rng
             | Quant (qop,pats,wopt,vars,body) ->
                 let n1 = FStar_List.length vars in
                 let uu____3073 =
                   let uu____3092 =
                     FStar_All.pipe_right pats
                       (FStar_List.map (FStar_List.map (aux (ix + n1)))) in
                   let uu____3113 = aux (ix + n1) body in
                   (qop, uu____3092, wopt, vars, uu____3113) in
                 mkQuant uu____3073 t1.rng
             | Let (es,body) ->
                 let uu____3132 =
                   FStar_List.fold_left
                     (fun uu____3150  ->
                        fun e  ->
                          match uu____3150 with
                          | (ix1,l) ->
                              let uu____3170 =
                                let uu____3173 = aux ix1 e in uu____3173 :: l in
                              ((ix1 + (Prims.parse_int "1")), uu____3170))
                     (ix, []) es in
                 (match uu____3132 with
                  | (ix1,es_rev) ->
                      let uu____3184 =
                        let uu____3191 = aux ix1 body in
                        ((FStar_List.rev es_rev), uu____3191) in
                      mkLet uu____3184 t1.rng)) in
      aux (Prims.parse_int "0") t
let inst: term Prims.list -> term -> term =
  fun tms  ->
    fun t  ->
      let tms1 = FStar_List.rev tms in
      let n1 = FStar_List.length tms1 in
      let rec aux shift t1 =
        match t1.tm with
        | Integer uu____3217 -> t1
        | FreeV uu____3218 -> t1
        | BoundV i ->
            if ((Prims.parse_int "0") <= (i - shift)) && ((i - shift) < n1)
            then FStar_List.nth tms1 (i - shift)
            else t1
        | App (op,tms2) ->
            let uu____3235 =
              let uu____3242 = FStar_List.map (aux shift) tms2 in
              (op, uu____3242) in
            mkApp' uu____3235 t1.rng
        | Labeled (t2,r1,r2) ->
            let uu____3250 =
              let uu____3251 =
                let uu____3258 = aux shift t2 in (uu____3258, r1, r2) in
              Labeled uu____3251 in
            mk uu____3250 t2.rng
        | LblPos (t2,r) ->
            let uu____3261 =
              let uu____3262 =
                let uu____3267 = aux shift t2 in (uu____3267, r) in
              LblPos uu____3262 in
            mk uu____3261 t2.rng
        | Quant (qop,pats,wopt,vars,body) ->
            let m = FStar_List.length vars in
            let shift1 = shift + m in
            let uu____3295 =
              let uu____3314 =
                FStar_All.pipe_right pats
                  (FStar_List.map (FStar_List.map (aux shift1))) in
              let uu____3331 = aux shift1 body in
              (qop, uu____3314, wopt, vars, uu____3331) in
            mkQuant uu____3295 t1.rng
        | Let (es,body) ->
            let uu____3346 =
              FStar_List.fold_left
                (fun uu____3364  ->
                   fun e  ->
                     match uu____3364 with
                     | (ix,es1) ->
                         let uu____3384 =
                           let uu____3387 = aux shift e in uu____3387 :: es1 in
                         ((shift + (Prims.parse_int "1")), uu____3384))
                (shift, []) es in
            (match uu____3346 with
             | (shift1,es_rev) ->
                 let uu____3398 =
                   let uu____3405 = aux shift1 body in
                   ((FStar_List.rev es_rev), uu____3405) in
                 mkLet uu____3398 t1.rng) in
      aux (Prims.parse_int "0") t
let subst: term -> fv -> term -> term =
  fun t  ->
    fun fv  -> fun s  -> let uu____3420 = abstr [fv] t in inst [s] uu____3420
let mkQuant':
  (qop,term Prims.list Prims.list,Prims.int FStar_Pervasives_Native.option,
    fv Prims.list,term) FStar_Pervasives_Native.tuple5 ->
    FStar_Range.range -> term
  =
  fun uu____3444  ->
    match uu____3444 with
    | (qop,pats,wopt,vars,body) ->
        let uu____3486 =
          let uu____3505 =
            FStar_All.pipe_right pats
              (FStar_List.map (FStar_List.map (abstr vars))) in
          let uu____3522 = FStar_List.map fv_sort vars in
          let uu____3529 = abstr vars body in
          (qop, uu____3505, wopt, uu____3522, uu____3529) in
        mkQuant uu____3486
let mkForall'':
  (pat Prims.list Prims.list,Prims.int FStar_Pervasives_Native.option,
    sort Prims.list,term) FStar_Pervasives_Native.tuple4 ->
    FStar_Range.range -> term
  =
  fun uu____3560  ->
    fun r  ->
      match uu____3560 with
      | (pats,wopt,sorts,body) -> mkQuant (Forall, pats, wopt, sorts, body) r
let mkForall':
  (pat Prims.list Prims.list,Prims.int FStar_Pervasives_Native.option,
    fvs,term) FStar_Pervasives_Native.tuple4 -> FStar_Range.range -> term
  =
  fun uu____3626  ->
    fun r  ->
      match uu____3626 with
      | (pats,wopt,vars,body) ->
          let uu____3658 = mkQuant' (Forall, pats, wopt, vars, body) in
          uu____3658 r
let mkForall:
  (pat Prims.list Prims.list,fvs,term) FStar_Pervasives_Native.tuple3 ->
    FStar_Range.range -> term
  =
  fun uu____3683  ->
    fun r  ->
      match uu____3683 with
      | (pats,vars,body) ->
          let uu____3706 =
            mkQuant' (Forall, pats, FStar_Pervasives_Native.None, vars, body) in
          uu____3706 r
let mkExists:
  (pat Prims.list Prims.list,fvs,term) FStar_Pervasives_Native.tuple3 ->
    FStar_Range.range -> term
  =
  fun uu____3731  ->
    fun r  ->
      match uu____3731 with
      | (pats,vars,body) ->
          let uu____3754 =
            mkQuant' (Exists, pats, FStar_Pervasives_Native.None, vars, body) in
          uu____3754 r
let mkLet':
  ((fv,term) FStar_Pervasives_Native.tuple2 Prims.list,term)
    FStar_Pervasives_Native.tuple2 -> FStar_Range.range -> term
  =
  fun uu____3779  ->
    fun r  ->
      match uu____3779 with
      | (bindings,body) ->
          let uu____3805 = FStar_List.split bindings in
          (match uu____3805 with
           | (vars,es) ->
               let uu____3824 =
                 let uu____3831 = abstr vars body in (es, uu____3831) in
               mkLet uu____3824 r)
let norng: FStar_Range.range = FStar_Range.dummyRange
let mkDefineFun:
  (Prims.string,(Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list,
    sort,term,caption) FStar_Pervasives_Native.tuple5 -> decl
  =
  fun uu____3853  ->
    match uu____3853 with
    | (nm,vars,s,tm,c) ->
        let uu____3887 =
          let uu____3900 = FStar_List.map fv_sort vars in
          let uu____3907 = abstr vars tm in
          (nm, uu____3900, s, uu____3907, c) in
        DefineFun uu____3887
let constr_id_of_sort: sort -> Prims.string =
  fun sort  ->
    let uu____3914 = strSort sort in
    FStar_Util.format1 "%s_constr_id" uu____3914
let fresh_token:
  (Prims.string,sort) FStar_Pervasives_Native.tuple2 -> Prims.int -> decl =
  fun uu____3925  ->
    fun id1  ->
      match uu____3925 with
      | (tok_name,sort) ->
          let a_name = Prims.strcat "fresh_token_" tok_name in
          let a =
            let uu____3935 =
              let uu____3936 =
                let uu____3941 = mkInteger' id1 norng in
                let uu____3942 =
                  let uu____3943 =
                    let uu____3950 = constr_id_of_sort sort in
                    let uu____3951 =
                      let uu____3954 = mkApp (tok_name, []) norng in
                      [uu____3954] in
                    (uu____3950, uu____3951) in
                  mkApp uu____3943 norng in
                (uu____3941, uu____3942) in
              mkEq uu____3936 norng in
            {
              assumption_term = uu____3935;
              assumption_caption =
                (FStar_Pervasives_Native.Some "fresh token");
              assumption_name = a_name;
              assumption_fact_ids = []
            } in
          Assume a
let fresh_constructor:
  (Prims.string,sort Prims.list,sort,Prims.int)
    FStar_Pervasives_Native.tuple4 -> decl
  =
  fun uu____3972  ->
    match uu____3972 with
    | (name,arg_sorts,sort,id1) ->
        let id2 = FStar_Util.string_of_int id1 in
        let bvars =
          FStar_All.pipe_right arg_sorts
            (FStar_List.mapi
               (fun i  ->
                  fun s  ->
                    let uu____4004 =
                      let uu____4009 =
                        let uu____4010 = FStar_Util.string_of_int i in
                        Prims.strcat "x_" uu____4010 in
                      (uu____4009, s) in
                    mkFreeV uu____4004 norng)) in
        let bvar_names = FStar_List.map fv_of_term bvars in
        let capp = mkApp (name, bvars) norng in
        let cid_app =
          let uu____4018 =
            let uu____4025 = constr_id_of_sort sort in (uu____4025, [capp]) in
          mkApp uu____4018 norng in
        let a_name = Prims.strcat "constructor_distinct_" name in
        let a =
          let uu____4030 =
            let uu____4031 =
              let uu____4042 =
                let uu____4043 =
                  let uu____4048 = mkInteger id2 norng in
                  (uu____4048, cid_app) in
                mkEq uu____4043 norng in
              ([[capp]], bvar_names, uu____4042) in
            mkForall uu____4031 norng in
          {
            assumption_term = uu____4030;
            assumption_caption =
              (FStar_Pervasives_Native.Some "Consrtructor distinct");
            assumption_name = a_name;
            assumption_fact_ids = []
          } in
        Assume a
let injective_constructor:
  (Prims.string,constructor_field Prims.list,sort)
    FStar_Pervasives_Native.tuple3 -> decls_t
  =
  fun uu____4070  ->
    match uu____4070 with
    | (name,fields,sort) ->
        let n_bvars = FStar_List.length fields in
        let bvar_name i =
          let uu____4091 = FStar_Util.string_of_int i in
          Prims.strcat "x_" uu____4091 in
        let bvar_index i = n_bvars - (i + (Prims.parse_int "1")) in
        let bvar i s =
          let uu____4111 = let uu____4116 = bvar_name i in (uu____4116, s) in
          mkFreeV uu____4111 in
        let bvars =
          FStar_All.pipe_right fields
            (FStar_List.mapi
               (fun i  ->
                  fun uu____4137  ->
                    match uu____4137 with
                    | (uu____4144,s,uu____4146) ->
                        let uu____4147 = bvar i s in uu____4147 norng)) in
        let bvar_names = FStar_List.map fv_of_term bvars in
        let capp = mkApp (name, bvars) norng in
        let uu____4156 =
          FStar_All.pipe_right fields
            (FStar_List.mapi
               (fun i  ->
                  fun uu____4184  ->
                    match uu____4184 with
                    | (name1,s,projectible) ->
                        let cproj_app = mkApp (name1, [capp]) norng in
                        let proj_name =
                          DeclFun
                            (name1, [sort], s,
                              (FStar_Pervasives_Native.Some "Projector")) in
                        if projectible
                        then
                          let a =
                            let uu____4207 =
                              let uu____4208 =
                                let uu____4219 =
                                  let uu____4220 =
                                    let uu____4225 =
                                      let uu____4226 = bvar i s in
                                      uu____4226 norng in
                                    (cproj_app, uu____4225) in
                                  mkEq uu____4220 norng in
                                ([[capp]], bvar_names, uu____4219) in
                              mkForall uu____4208 norng in
                            {
                              assumption_term = uu____4207;
                              assumption_caption =
                                (FStar_Pervasives_Native.Some
                                   "Projection inverse");
                              assumption_name =
                                (Prims.strcat "projection_inverse_" name1);
                              assumption_fact_ids = []
                            } in
                          [proj_name; Assume a]
                        else [proj_name])) in
        FStar_All.pipe_right uu____4156 FStar_List.flatten
let constructor_to_decl: constructor_t -> decls_t =
  fun uu____4249  ->
    match uu____4249 with
    | (name,fields,sort,id1,injective) ->
        let injective1 = injective || true in
        let field_sorts =
          FStar_All.pipe_right fields
            (FStar_List.map
               (fun uu____4277  ->
                  match uu____4277 with
                  | (uu____4284,sort1,uu____4286) -> sort1)) in
        let cdecl =
          DeclFun
            (name, field_sorts, sort,
              (FStar_Pervasives_Native.Some "Constructor")) in
        let cid = fresh_constructor (name, field_sorts, sort, id1) in
        let disc =
          let disc_name = Prims.strcat "is-" name in
          let xfv = ("x", sort) in
          let xx = mkFreeV xfv norng in
          let disc_eq =
            let uu____4304 =
              let uu____4309 =
                let uu____4310 =
                  let uu____4317 = constr_id_of_sort sort in
                  (uu____4317, [xx]) in
                mkApp uu____4310 norng in
              let uu____4320 =
                let uu____4321 = FStar_Util.string_of_int id1 in
                mkInteger uu____4321 norng in
              (uu____4309, uu____4320) in
            mkEq uu____4304 norng in
          let uu____4322 =
            let uu____4337 =
              FStar_All.pipe_right fields
                (FStar_List.mapi
                   (fun i  ->
                      fun uu____4387  ->
                        match uu____4387 with
                        | (proj,s,projectible) ->
                            if projectible
                            then
                              let uu____4417 = mkApp (proj, [xx]) norng in
                              (uu____4417, [])
                            else
                              (let fi =
                                 let uu____4436 =
                                   let uu____4437 =
                                     FStar_Util.string_of_int i in
                                   Prims.strcat "f_" uu____4437 in
                                 (uu____4436, s) in
                               let uu____4438 = mkFreeV fi norng in
                               (uu____4438, [fi])))) in
            FStar_All.pipe_right uu____4337 FStar_List.split in
          match uu____4322 with
          | (proj_terms,ex_vars) ->
              let ex_vars1 = FStar_List.flatten ex_vars in
              let disc_inv_body =
                let uu____4519 =
                  let uu____4524 = mkApp (name, proj_terms) norng in
                  (xx, uu____4524) in
                mkEq uu____4519 norng in
              let disc_inv_body1 =
                match ex_vars1 with
                | [] -> disc_inv_body
                | uu____4532 -> mkExists ([], ex_vars1, disc_inv_body) norng in
              let disc_ax = mkAnd (disc_eq, disc_inv_body1) norng in
              let def =
                mkDefineFun
                  (disc_name, [xfv], Bool_sort, disc_ax,
                    (FStar_Pervasives_Native.Some "Discriminator definition")) in
              def in
        let projs =
          if injective1
          then injective_constructor (name, fields, sort)
          else [] in
        let uu____4573 =
          let uu____4576 =
            let uu____4577 = FStar_Util.format1 "<start constructor %s>" name in
            Caption uu____4577 in
          uu____4576 :: cdecl :: cid :: projs in
        let uu____4578 =
          let uu____4581 =
            let uu____4584 =
              let uu____4585 =
                FStar_Util.format1 "</end constructor %s>" name in
              Caption uu____4585 in
            [uu____4584] in
          FStar_List.append [disc] uu____4581 in
        FStar_List.append uu____4573 uu____4578
let name_binders_inner:
  Prims.string FStar_Pervasives_Native.option ->
    (Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list ->
      Prims.int ->
        sort Prims.list ->
          ((Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list,
            Prims.string Prims.list,Prims.int) FStar_Pervasives_Native.tuple3
  =
  fun prefix_opt  ->
    fun outer_names  ->
      fun start  ->
        fun sorts  ->
          let uu____4636 =
            FStar_All.pipe_right sorts
              (FStar_List.fold_left
                 (fun uu____4691  ->
                    fun s  ->
                      match uu____4691 with
                      | (names1,binders,n1) ->
                          let prefix1 =
                            match s with
                            | Term_sort  -> "@x"
                            | uu____4741 -> "@u" in
                          let prefix2 =
                            match prefix_opt with
                            | FStar_Pervasives_Native.None  -> prefix1
                            | FStar_Pervasives_Native.Some p ->
                                Prims.strcat p prefix1 in
                          let nm =
                            let uu____4745 = FStar_Util.string_of_int n1 in
                            Prims.strcat prefix2 uu____4745 in
                          let names2 = (nm, s) :: names1 in
                          let b =
                            let uu____4758 = strSort s in
                            FStar_Util.format2 "(%s %s)" nm uu____4758 in
                          (names2, (b :: binders),
                            (n1 + (Prims.parse_int "1"))))
                 (outer_names, [], start)) in
          match uu____4636 with
          | (names1,binders,n1) -> (names1, (FStar_List.rev binders), n1)
let name_macro_binders:
  sort Prims.list ->
    ((Prims.string,sort) FStar_Pervasives_Native.tuple2 Prims.list,Prims.string
                                                                    Prims.list)
      FStar_Pervasives_Native.tuple2
  =
  fun sorts  ->
    let uu____4836 =
      name_binders_inner (FStar_Pervasives_Native.Some "__") []
        (Prims.parse_int "0") sorts in
    match uu____4836 with
    | (names1,binders,n1) -> ((FStar_List.rev names1), binders)
let termToSmt: Prims.bool -> Prims.string -> term -> Prims.string =
  fun print_ranges  ->
    fun enclosing_name  ->
      fun t  ->
        let next_qid =
          let ctr = FStar_Util.mk_ref (Prims.parse_int "0") in
          fun depth  ->
            let n1 = FStar_ST.op_Bang ctr in
            FStar_Util.incr ctr;
            if n1 = (Prims.parse_int "0")
            then enclosing_name
            else
              (let uu____5001 = FStar_Util.string_of_int n1 in
               FStar_Util.format2 "%s.%s" enclosing_name uu____5001) in
        let remove_guard_free pats =
          FStar_All.pipe_right pats
            (FStar_List.map
               (fun ps  ->
                  FStar_All.pipe_right ps
                    (FStar_List.map
                       (fun tm  ->
                          match tm.tm with
                          | App
                              (Var
                               "Prims.guard_free",{ tm = BoundV uu____5043;
                                                    freevars = uu____5044;
                                                    rng = uu____5045;_}::[])
                              -> tm
                          | App (Var "Prims.guard_free",p::[]) -> p
                          | uu____5059 -> tm)))) in
        let rec aux' depth n1 names1 t1 =
          let aux1 = aux (depth + (Prims.parse_int "1")) in
          match t1.tm with
          | Integer i -> i
          | BoundV i ->
              let uu____5099 = FStar_List.nth names1 i in
              FStar_All.pipe_right uu____5099 FStar_Pervasives_Native.fst
          | FreeV x -> FStar_Pervasives_Native.fst x
          | App (op,[]) -> op_to_string op
          | App (op,tms) ->
              let uu____5114 = op_to_string op in
              let uu____5115 =
                let uu____5116 = FStar_List.map (aux1 n1 names1) tms in
                FStar_All.pipe_right uu____5116 (FStar_String.concat "\n") in
              FStar_Util.format2 "(%s %s)" uu____5114 uu____5115
          | Labeled (t2,uu____5122,uu____5123) -> aux1 n1 names1 t2
          | LblPos (t2,s) ->
              let uu____5126 = aux1 n1 names1 t2 in
              FStar_Util.format2 "(! %s :lblpos %s)" uu____5126 s
          | Quant (qop,pats,wopt,sorts,body) ->
              let qid = next_qid () in
              let uu____5149 =
                name_binders_inner FStar_Pervasives_Native.None names1 n1
                  sorts in
              (match uu____5149 with
               | (names2,binders,n2) ->
                   let binders1 =
                     FStar_All.pipe_right binders (FStar_String.concat " ") in
                   let pats1 = remove_guard_free pats in
                   let pats_str =
                     match pats1 with
                     | []::[] -> ";;no pats"
                     | [] -> ";;no pats"
                     | uu____5198 ->
                         let uu____5203 =
                           FStar_All.pipe_right pats1
                             (FStar_List.map
                                (fun pats2  ->
                                   let uu____5219 =
                                     let uu____5220 =
                                       FStar_List.map
                                         (fun p  ->
                                            let uu____5226 = aux1 n2 names2 p in
                                            FStar_Util.format1 "%s"
                                              uu____5226) pats2 in
                                     FStar_String.concat " " uu____5220 in
                                   FStar_Util.format1 "\n:pattern (%s)"
                                     uu____5219)) in
                         FStar_All.pipe_right uu____5203
                           (FStar_String.concat "\n") in
                   let uu____5229 =
                     let uu____5232 =
                       let uu____5235 =
                         let uu____5238 = aux1 n2 names2 body in
                         let uu____5239 =
                           let uu____5242 = weightToSmt wopt in
                           [uu____5242; pats_str; qid] in
                         uu____5238 :: uu____5239 in
                       binders1 :: uu____5235 in
                     (qop_to_string qop) :: uu____5232 in
                   FStar_Util.format "(%s (%s)\n (! %s\n %s\n%s\n:qid %s))"
                     uu____5229)
          | Let (es,body) ->
              let uu____5249 =
                FStar_List.fold_left
                  (fun uu____5286  ->
                     fun e  ->
                       match uu____5286 with
                       | (names0,binders,n0) ->
                           let nm =
                             let uu____5336 = FStar_Util.string_of_int n0 in
                             Prims.strcat "@lb" uu____5336 in
                           let names01 = (nm, Term_sort) :: names0 in
                           let b =
                             let uu____5349 = aux1 n1 names1 e in
                             FStar_Util.format2 "(%s %s)" nm uu____5349 in
                           (names01, (b :: binders),
                             (n0 + (Prims.parse_int "1")))) (names1, [], n1)
                  es in
              (match uu____5249 with
               | (names2,binders,n2) ->
                   let uu____5381 = aux1 n2 names2 body in
                   FStar_Util.format2 "(let (%s)\n%s)"
                     (FStar_String.concat " " binders) uu____5381)
        and aux depth n1 names1 t1 =
          let s = aux' depth n1 names1 t1 in
          if print_ranges && (t1.rng <> norng)
          then
            let uu____5389 = FStar_Range.string_of_range t1.rng in
            let uu____5390 = FStar_Range.string_of_use_range t1.rng in
            FStar_Util.format3 "\n;; def=%s; use=%s\n%s\n" uu____5389
              uu____5390 s
          else s in
        aux (Prims.parse_int "0") (Prims.parse_int "0") [] t
let caption_to_string:
  Prims.string FStar_Pervasives_Native.option -> Prims.string =
  fun uu___112_5397  ->
    match uu___112_5397 with
    | FStar_Pervasives_Native.None  -> ""
    | FStar_Pervasives_Native.Some c ->
        let uu____5401 =
          match FStar_Util.splitlines c with
          | [] -> failwith "Impossible"
          | hd1::[] -> (hd1, "")
          | hd1::uu____5416 -> (hd1, "...") in
        (match uu____5401 with
         | (hd1,suffix) ->
             FStar_Util.format2 ";;;;;;;;;;;;;;;;%s%s\n" hd1 suffix)
let rec declToSmt': Prims.bool -> Prims.string -> decl -> Prims.string =
  fun print_ranges  ->
    fun z3options  ->
      fun decl  ->
        let escape s = FStar_Util.replace_char s 39 95 in
        match decl with
        | DefPrelude  -> mkPrelude z3options
        | Caption c ->
            let uu____5445 = FStar_Options.log_queries () in
            if uu____5445
            then
              let uu____5446 =
                FStar_All.pipe_right (FStar_Util.splitlines c)
                  (fun uu___113_5450  ->
                     match uu___113_5450 with | [] -> "" | h::t -> h) in
              FStar_Util.format1 "\n; %s" uu____5446
            else ""
        | DeclFun (f,argsorts,retsort,c) ->
            let l = FStar_List.map strSort argsorts in
            let uu____5469 = caption_to_string c in
            let uu____5470 = strSort retsort in
            FStar_Util.format4 "%s(declare-fun %s (%s) %s)" uu____5469 f
              (FStar_String.concat " " l) uu____5470
        | DefineFun (f,arg_sorts,retsort,body,c) ->
            let uu____5480 = name_macro_binders arg_sorts in
            (match uu____5480 with
             | (names1,binders) ->
                 let body1 =
                   let uu____5512 =
                     FStar_List.map (fun x  -> mkFreeV x norng) names1 in
                   inst uu____5512 body in
                 let uu____5525 = caption_to_string c in
                 let uu____5526 = strSort retsort in
                 let uu____5527 = termToSmt print_ranges (escape f) body1 in
                 FStar_Util.format5 "%s(define-fun %s (%s) %s\n %s)"
                   uu____5525 f (FStar_String.concat " " binders) uu____5526
                   uu____5527)
        | Assume a ->
            let fact_ids_to_string ids =
              FStar_All.pipe_right ids
                (FStar_List.map
                   (fun uu___114_5545  ->
                      match uu___114_5545 with
                      | Name n1 ->
                          Prims.strcat "Name " (FStar_Ident.text_of_lid n1)
                      | Namespace ns ->
                          Prims.strcat "Namespace "
                            (FStar_Ident.text_of_lid ns)
                      | Tag t -> Prims.strcat "Tag " t)) in
            let fids =
              let uu____5550 = FStar_Options.log_queries () in
              if uu____5550
              then
                let uu____5551 =
                  let uu____5552 = fact_ids_to_string a.assumption_fact_ids in
                  FStar_String.concat "; " uu____5552 in
                FStar_Util.format1 ";;; Fact-ids: %s\n" uu____5551
              else "" in
            let n1 = escape a.assumption_name in
            let uu____5557 = caption_to_string a.assumption_caption in
            let uu____5558 = termToSmt print_ranges n1 a.assumption_term in
            FStar_Util.format4 "%s%s(assert (! %s\n:named %s))" uu____5557
              fids uu____5558 n1
        | Eval t ->
            let uu____5560 = termToSmt print_ranges "eval" t in
            FStar_Util.format1 "(eval %s)" uu____5560
        | Echo s -> FStar_Util.format1 "(echo \"%s\")" s
        | RetainAssumptions uu____5562 -> ""
        | CheckSat  ->
            "(echo \"<result>\")\n(check-sat)\n(echo \"</result>\")"
        | GetUnsatCore  ->
            "(echo \"<unsat-core>\")\n(get-unsat-core)\n(echo \"</unsat-core>\")"
        | Push  -> "(push)"
        | Pop  -> "(pop)"
        | SetOption (s,v1) -> FStar_Util.format2 "(set-option :%s %s)" s v1
        | GetStatistics  ->
            "(echo \"<statistics>\")\n(get-info :all-statistics)\n(echo \"</statistics>\")"
        | GetReasonUnknown  ->
            "(echo \"<reason-unknown>\")\n(get-info :reason-unknown)\n(echo \"</reason-unknown>\")"
and declToSmt: Prims.string -> decl -> Prims.string =
  fun z3options  -> fun decl  -> declToSmt' true z3options decl
and declToSmt_no_caps: Prims.string -> decl -> Prims.string =
  fun z3options  -> fun decl  -> declToSmt' false z3options decl
and mkPrelude: Prims.string -> Prims.string =
  fun z3options  ->
    let basic =
      Prims.strcat z3options
        "(declare-sort FString)\n(declare-fun FString_constr_id (FString) Int)\n\n(declare-sort Term)\n(declare-fun Term_constr_id (Term) Int)\n(declare-datatypes () ((Fuel \n(ZFuel) \n(SFuel (prec Fuel)))))\n(declare-fun MaxIFuel () Fuel)\n(declare-fun MaxFuel () Fuel)\n(declare-fun PreType (Term) Term)\n(declare-fun Valid (Term) Bool)\n(declare-fun HasTypeFuel (Fuel Term Term) Bool)\n(define-fun HasTypeZ ((x Term) (t Term)) Bool\n(HasTypeFuel ZFuel x t))\n(define-fun HasType ((x Term) (t Term)) Bool\n(HasTypeFuel MaxIFuel x t))\n;;fuel irrelevance\n(assert (forall ((f Fuel) (x Term) (t Term))\n(! (= (HasTypeFuel (SFuel f) x t)\n(HasTypeZ x t))\n:pattern ((HasTypeFuel (SFuel f) x t)))))\n(declare-fun NoHoist (Term Bool) Bool)\n;;no-hoist\n(assert (forall ((dummy Term) (b Bool))\n(! (= (NoHoist dummy b)\nb)\n:pattern ((NoHoist dummy b)))))\n(define-fun  IsTyped ((x Term)) Bool\n(exists ((t Term)) (HasTypeZ x t)))\n(declare-fun ApplyTF (Term Fuel) Term)\n(declare-fun ApplyTT (Term Term) Term)\n(declare-fun Rank (Term) Int)\n(declare-fun Closure (Term) Term)\n(declare-fun ConsTerm (Term Term) Term)\n(declare-fun ConsFuel (Fuel Term) Term)\n(declare-fun Precedes (Term Term) Term)\n(declare-fun Tm_uvar (Int) Term)\n(define-fun Reify ((x Term)) Term x)\n(assert (forall ((t Term))\n(! (implies (exists ((e Term)) (HasType e t))\n(Valid t))\n:pattern ((Valid t)))))\n(assert (forall ((t1 Term) (t2 Term))\n(! (iff (Valid (Precedes t1 t2)) \n(< (Rank t1) (Rank t2)))\n:pattern ((Precedes t1 t2)))))\n(define-fun Prims.precedes ((a Term) (b Term) (t1 Term) (t2 Term)) Term\n(Precedes t1 t2))\n(declare-fun Range_const () Term)\n(declare-fun _mul (Int Int) Int)\n(declare-fun _div (Int Int) Int)\n(declare-fun _mod (Int Int) Int)\n(assert (forall ((x Int) (y Int)) (! (= (_mul x y) (* x y)) :pattern ((_mul x y)))))\n(assert (forall ((x Int) (y Int)) (! (= (_div x y) (div x y)) :pattern ((_div x y)))))\n(assert (forall ((x Int) (y Int)) (! (= (_mod x y) (mod x y)) :pattern ((_mod x y)))))" in
    let constrs =
      [("FString_const", [("FString_const_proj_0", Int_sort, true)],
         String_sort, (Prims.parse_int "0"), true);
      ("Tm_type", [], Term_sort, (Prims.parse_int "2"), true);
      ("Tm_arrow", [("Tm_arrow_id", Int_sort, true)], Term_sort,
        (Prims.parse_int "3"), false);
      ("Tm_unit", [], Term_sort, (Prims.parse_int "6"), true);
      ((FStar_Pervasives_Native.fst boxIntFun),
        [((FStar_Pervasives_Native.snd boxIntFun), Int_sort, true)],
        Term_sort, (Prims.parse_int "7"), true);
      ((FStar_Pervasives_Native.fst boxBoolFun),
        [((FStar_Pervasives_Native.snd boxBoolFun), Bool_sort, true)],
        Term_sort, (Prims.parse_int "8"), true);
      ((FStar_Pervasives_Native.fst boxStringFun),
        [((FStar_Pervasives_Native.snd boxStringFun), String_sort, true)],
        Term_sort, (Prims.parse_int "9"), true);
      ("LexCons",
        [("LexCons_0", Term_sort, true); ("LexCons_1", Term_sort, true)],
        Term_sort, (Prims.parse_int "11"), true)] in
    let bcons =
      let uu____5891 =
        let uu____5894 =
          FStar_All.pipe_right constrs
            (FStar_List.collect constructor_to_decl) in
        FStar_All.pipe_right uu____5894
          (FStar_List.map (declToSmt z3options)) in
      FStar_All.pipe_right uu____5891 (FStar_String.concat "\n") in
    let lex_ordering =
      "\n(define-fun is-Prims.LexCons ((t Term)) Bool \n(is-LexCons t))\n(assert (forall ((x1 Term) (x2 Term) (y1 Term) (y2 Term))\n(iff (Valid (Precedes (LexCons x1 x2) (LexCons y1 y2)))\n(or (Valid (Precedes x1 y1))\n(and (= x1 y1)\n(Valid (Precedes x2 y2)))))))\n" in
    Prims.strcat basic (Prims.strcat bcons lex_ordering)
let mkBvConstructor: Prims.int -> decls_t =
  fun sz  ->
    let uu____5910 =
      let uu____5929 =
        let uu____5930 = boxBitVecFun sz in
        FStar_Pervasives_Native.fst uu____5930 in
      let uu____5935 =
        let uu____5944 =
          let uu____5951 =
            let uu____5952 = boxBitVecFun sz in
            FStar_Pervasives_Native.snd uu____5952 in
          (uu____5951, (BitVec_sort sz), true) in
        [uu____5944] in
      (uu____5929, uu____5935, Term_sort, ((Prims.parse_int "12") + sz),
        true) in
    FStar_All.pipe_right uu____5910 constructor_to_decl
let mk_Range_const: term = mkApp ("Range_const", []) norng
let mk_Term_type: term = mkApp ("Tm_type", []) norng
let mk_Term_app: term -> term -> FStar_Range.range -> term =
  fun t1  -> fun t2  -> fun r  -> mkApp ("Tm_app", [t1; t2]) r
let mk_Term_uvar: Prims.int -> FStar_Range.range -> term =
  fun i  ->
    fun r  ->
      let uu____6021 =
        let uu____6028 = let uu____6031 = mkInteger' i norng in [uu____6031] in
        ("Tm_uvar", uu____6028) in
      mkApp uu____6021 r
let mk_Term_unit: term = mkApp ("Tm_unit", []) norng
let elim_box: Prims.bool -> Prims.string -> Prims.string -> term -> term =
  fun cond  ->
    fun u  ->
      fun v1  ->
        fun t  ->
          match t.tm with
          | App (Var v',t1::[]) when (v1 = v') && cond -> t1
          | uu____6056 -> mkApp (u, [t]) t.rng
let maybe_elim_box: Prims.string -> Prims.string -> term -> term =
  fun u  ->
    fun v1  ->
      fun t  ->
        let uu____6071 = FStar_Options.smtencoding_elim_box () in
        elim_box uu____6071 u v1 t
let boxInt: term -> term =
  fun t  ->
    maybe_elim_box (FStar_Pervasives_Native.fst boxIntFun)
      (FStar_Pervasives_Native.snd boxIntFun) t
let unboxInt: term -> term =
  fun t  ->
    maybe_elim_box (FStar_Pervasives_Native.snd boxIntFun)
      (FStar_Pervasives_Native.fst boxIntFun) t
let boxBool: term -> term =
  fun t  ->
    maybe_elim_box (FStar_Pervasives_Native.fst boxBoolFun)
      (FStar_Pervasives_Native.snd boxBoolFun) t
let unboxBool: term -> term =
  fun t  ->
    maybe_elim_box (FStar_Pervasives_Native.snd boxBoolFun)
      (FStar_Pervasives_Native.fst boxBoolFun) t
let boxString: term -> term =
  fun t  ->
    maybe_elim_box (FStar_Pervasives_Native.fst boxStringFun)
      (FStar_Pervasives_Native.snd boxStringFun) t
let unboxString: term -> term =
  fun t  ->
    maybe_elim_box (FStar_Pervasives_Native.snd boxStringFun)
      (FStar_Pervasives_Native.fst boxStringFun) t
let boxBitVec: Prims.int -> term -> term =
  fun sz  ->
    fun t  ->
      let uu____6104 =
        let uu____6105 = boxBitVecFun sz in
        FStar_Pervasives_Native.fst uu____6105 in
      let uu____6110 =
        let uu____6111 = boxBitVecFun sz in
        FStar_Pervasives_Native.snd uu____6111 in
      elim_box true uu____6104 uu____6110 t
let unboxBitVec: Prims.int -> term -> term =
  fun sz  ->
    fun t  ->
      let uu____6124 =
        let uu____6125 = boxBitVecFun sz in
        FStar_Pervasives_Native.snd uu____6125 in
      let uu____6130 =
        let uu____6131 = boxBitVecFun sz in
        FStar_Pervasives_Native.fst uu____6131 in
      elim_box true uu____6124 uu____6130 t
let boxTerm: sort -> term -> term =
  fun sort  ->
    fun t  ->
      match sort with
      | Int_sort  -> boxInt t
      | Bool_sort  -> boxBool t
      | String_sort  -> boxString t
      | BitVec_sort sz -> boxBitVec sz t
      | uu____6145 -> FStar_Exn.raise FStar_Util.Impos
let unboxTerm: sort -> term -> term =
  fun sort  ->
    fun t  ->
      match sort with
      | Int_sort  -> unboxInt t
      | Bool_sort  -> unboxBool t
      | String_sort  -> unboxString t
      | BitVec_sort sz -> unboxBitVec sz t
      | uu____6155 -> FStar_Exn.raise FStar_Util.Impos
let rec print_smt_term: term -> Prims.string =
  fun t  ->
    match t.tm with
    | Integer n1 -> FStar_Util.format1 "(Integer %s)" n1
    | BoundV n1 ->
        let uu____6171 = FStar_Util.string_of_int n1 in
        FStar_Util.format1 "(BoundV %s)" uu____6171
    | FreeV fv ->
        FStar_Util.format1 "(FreeV %s)" (FStar_Pervasives_Native.fst fv)
    | App (op,l) ->
        let uu____6183 = op_to_string op in
        let uu____6184 = print_smt_term_list l in
        FStar_Util.format2 "(%s %s)" uu____6183 uu____6184
    | Labeled (t1,r1,r2) ->
        let uu____6188 = print_smt_term t1 in
        FStar_Util.format2 "(Labeled '%s' %s)" r1 uu____6188
    | LblPos (t1,s) ->
        let uu____6191 = print_smt_term t1 in
        FStar_Util.format2 "(LblPos %s %s)" s uu____6191
    | Quant (qop,l,uu____6194,uu____6195,t1) ->
        let uu____6213 = print_smt_term_list_list l in
        let uu____6214 = print_smt_term t1 in
        FStar_Util.format3 "(%s %s %s)" (qop_to_string qop) uu____6213
          uu____6214
    | Let (es,body) ->
        let uu____6221 = print_smt_term_list es in
        let uu____6222 = print_smt_term body in
        FStar_Util.format2 "(let %s %s)" uu____6221 uu____6222
and print_smt_term_list: term Prims.list -> Prims.string =
  fun l  ->
    let uu____6226 = FStar_List.map print_smt_term l in
    FStar_All.pipe_right uu____6226 (FStar_String.concat " ")
and print_smt_term_list_list: term Prims.list Prims.list -> Prims.string =
  fun l  ->
    FStar_List.fold_left
      (fun s  ->
         fun l1  ->
           let uu____6245 =
             let uu____6246 =
               let uu____6247 = print_smt_term_list l1 in
               Prims.strcat uu____6247 " ] " in
             Prims.strcat "; [ " uu____6246 in
           Prims.strcat s uu____6245) "" l
let getBoxedInteger: term -> Prims.int FStar_Pervasives_Native.option =
  fun t  ->
    match t.tm with
    | App (Var s,t2::[]) when s = (FStar_Pervasives_Native.fst boxIntFun) ->
        (match t2.tm with
         | Integer n1 ->
             let uu____6263 = FStar_Util.int_of_string n1 in
             FStar_Pervasives_Native.Some uu____6263
         | uu____6264 -> FStar_Pervasives_Native.None)
    | uu____6265 -> FStar_Pervasives_Native.None
let mk_PreType: term -> term = fun t  -> mkApp ("PreType", [t]) t.rng
let mk_Valid: term -> term =
  fun t  ->
    match t.tm with
    | App
        (Var
         "Prims.b2t",{
                       tm = App
                         (Var "Prims.op_Equality",uu____6276::t1::t2::[]);
                       freevars = uu____6279; rng = uu____6280;_}::[])
        -> mkEq (t1, t2) t.rng
    | App
        (Var
         "Prims.b2t",{
                       tm = App
                         (Var "Prims.op_disEquality",uu____6293::t1::t2::[]);
                       freevars = uu____6296; rng = uu____6297;_}::[])
        -> let uu____6310 = mkEq (t1, t2) norng in mkNot uu____6310 t.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "Prims.op_LessThanOrEqual",t1::t2::[]);
                       freevars = uu____6313; rng = uu____6314;_}::[])
        ->
        let uu____6327 =
          let uu____6332 = unboxInt t1 in
          let uu____6333 = unboxInt t2 in (uu____6332, uu____6333) in
        mkLTE uu____6327 t.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "Prims.op_LessThan",t1::t2::[]);
                       freevars = uu____6336; rng = uu____6337;_}::[])
        ->
        let uu____6350 =
          let uu____6355 = unboxInt t1 in
          let uu____6356 = unboxInt t2 in (uu____6355, uu____6356) in
        mkLT uu____6350 t.rng
    | App
        (Var
         "Prims.b2t",{
                       tm = App
                         (Var "Prims.op_GreaterThanOrEqual",t1::t2::[]);
                       freevars = uu____6359; rng = uu____6360;_}::[])
        ->
        let uu____6373 =
          let uu____6378 = unboxInt t1 in
          let uu____6379 = unboxInt t2 in (uu____6378, uu____6379) in
        mkGTE uu____6373 t.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "Prims.op_GreaterThan",t1::t2::[]);
                       freevars = uu____6382; rng = uu____6383;_}::[])
        ->
        let uu____6396 =
          let uu____6401 = unboxInt t1 in
          let uu____6402 = unboxInt t2 in (uu____6401, uu____6402) in
        mkGT uu____6396 t.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "Prims.op_AmpAmp",t1::t2::[]);
                       freevars = uu____6405; rng = uu____6406;_}::[])
        ->
        let uu____6419 =
          let uu____6424 = unboxBool t1 in
          let uu____6425 = unboxBool t2 in (uu____6424, uu____6425) in
        mkAnd uu____6419 t.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "Prims.op_BarBar",t1::t2::[]);
                       freevars = uu____6428; rng = uu____6429;_}::[])
        ->
        let uu____6442 =
          let uu____6447 = unboxBool t1 in
          let uu____6448 = unboxBool t2 in (uu____6447, uu____6448) in
        mkOr uu____6442 t.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "Prims.op_Negation",t1::[]);
                       freevars = uu____6450; rng = uu____6451;_}::[])
        -> let uu____6464 = unboxBool t1 in mkNot uu____6464 t1.rng
    | App
        (Var
         "Prims.b2t",{ tm = App (Var "FStar.BV.bvult",t0::t1::t2::[]);
                       freevars = uu____6468; rng = uu____6469;_}::[])
        when
        let uu____6482 = getBoxedInteger t0 in FStar_Util.is_some uu____6482
        ->
        let sz =
          let uu____6486 = getBoxedInteger t0 in
          match uu____6486 with
          | FStar_Pervasives_Native.Some sz -> sz
          | uu____6490 -> failwith "impossible" in
        let uu____6493 =
          let uu____6498 = unboxBitVec sz t1 in
          let uu____6499 = unboxBitVec sz t2 in (uu____6498, uu____6499) in
        mkBvUlt uu____6493 t.rng
    | App
        (Var
         "Prims.equals",uu____6500::{
                                      tm = App
                                        (Var "FStar.BV.bvult",t0::t1::t2::[]);
                                      freevars = uu____6504;
                                      rng = uu____6505;_}::uu____6506::[])
        when
        let uu____6519 = getBoxedInteger t0 in FStar_Util.is_some uu____6519
        ->
        let sz =
          let uu____6523 = getBoxedInteger t0 in
          match uu____6523 with
          | FStar_Pervasives_Native.Some sz -> sz
          | uu____6527 -> failwith "impossible" in
        let uu____6530 =
          let uu____6535 = unboxBitVec sz t1 in
          let uu____6536 = unboxBitVec sz t2 in (uu____6535, uu____6536) in
        mkBvUlt uu____6530 t.rng
    | App (Var "Prims.b2t",t1::[]) ->
        let uu___115_6540 = unboxBool t1 in
        {
          tm = (uu___115_6540.tm);
          freevars = (uu___115_6540.freevars);
          rng = (t.rng)
        }
    | uu____6541 -> mkApp ("Valid", [t]) t.rng
let mk_HasType: term -> term -> term =
  fun v1  -> fun t  -> mkApp ("HasType", [v1; t]) t.rng
let mk_HasTypeZ: term -> term -> term =
  fun v1  -> fun t  -> mkApp ("HasTypeZ", [v1; t]) t.rng
let mk_IsTyped: term -> term = fun v1  -> mkApp ("IsTyped", [v1]) norng
let mk_HasTypeFuel: term -> term -> term -> term =
  fun f  ->
    fun v1  ->
      fun t  ->
        let uu____6582 = FStar_Options.unthrottle_inductives () in
        if uu____6582
        then mk_HasType v1 t
        else mkApp ("HasTypeFuel", [f; v1; t]) t.rng
let mk_HasTypeWithFuel:
  term FStar_Pervasives_Native.option -> term -> term -> term =
  fun f  ->
    fun v1  ->
      fun t  ->
        match f with
        | FStar_Pervasives_Native.None  -> mk_HasType v1 t
        | FStar_Pervasives_Native.Some f1 -> mk_HasTypeFuel f1 v1 t
let mk_NoHoist: term -> term -> term =
  fun dummy  -> fun b  -> mkApp ("NoHoist", [dummy; b]) b.rng
let mk_Destruct: term -> FStar_Range.range -> term =
  fun v1  -> mkApp ("Destruct", [v1])
let mk_Rank: term -> FStar_Range.range -> term =
  fun x  -> mkApp ("Rank", [x])
let mk_tester: Prims.string -> term -> term =
  fun n1  -> fun t  -> mkApp ((Prims.strcat "is-" n1), [t]) t.rng
let mk_ApplyTF: term -> term -> term =
  fun t  -> fun t'  -> mkApp ("ApplyTF", [t; t']) t.rng
let mk_ApplyTT: term -> term -> FStar_Range.range -> term =
  fun t  -> fun t'  -> fun r  -> mkApp ("ApplyTT", [t; t']) r
let mk_String_const: Prims.int -> FStar_Range.range -> term =
  fun i  ->
    fun r  ->
      let uu____6673 =
        let uu____6680 = let uu____6683 = mkInteger' i norng in [uu____6683] in
        ("FString_const", uu____6680) in
      mkApp uu____6673 r
let mk_Precedes: term -> term -> FStar_Range.range -> term =
  fun x1  ->
    fun x2  ->
      fun r  ->
        let uu____6698 = mkApp ("Precedes", [x1; x2]) r in
        FStar_All.pipe_right uu____6698 mk_Valid
let mk_LexCons: term -> term -> FStar_Range.range -> term =
  fun x1  -> fun x2  -> fun r  -> mkApp ("LexCons", [x1; x2]) r
let rec n_fuel: Prims.int -> term =
  fun n1  ->
    if n1 = (Prims.parse_int "0")
    then mkApp ("ZFuel", []) norng
    else
      (let uu____6722 =
         let uu____6729 =
           let uu____6732 = n_fuel (n1 - (Prims.parse_int "1")) in
           [uu____6732] in
         ("SFuel", uu____6729) in
       mkApp uu____6722 norng)
let fuel_2: term = n_fuel (Prims.parse_int "2")
let fuel_100: term = n_fuel (Prims.parse_int "100")
let mk_and_opt:
  term FStar_Pervasives_Native.option ->
    term FStar_Pervasives_Native.option ->
      FStar_Range.range -> term FStar_Pervasives_Native.option
  =
  fun p1  ->
    fun p2  ->
      fun r  ->
        match (p1, p2) with
        | (FStar_Pervasives_Native.Some p11,FStar_Pervasives_Native.Some p21)
            ->
            let uu____6769 = mkAnd (p11, p21) r in
            FStar_Pervasives_Native.Some uu____6769
        | (FStar_Pervasives_Native.Some p,FStar_Pervasives_Native.None ) ->
            FStar_Pervasives_Native.Some p
        | (FStar_Pervasives_Native.None ,FStar_Pervasives_Native.Some p) ->
            FStar_Pervasives_Native.Some p
        | (FStar_Pervasives_Native.None ,FStar_Pervasives_Native.None ) ->
            FStar_Pervasives_Native.None
let mk_and_opt_l:
  term FStar_Pervasives_Native.option Prims.list ->
    FStar_Range.range -> term FStar_Pervasives_Native.option
  =
  fun pl  ->
    fun r  ->
      FStar_List.fold_right (fun p  -> fun out  -> mk_and_opt p out r) pl
        FStar_Pervasives_Native.None
let mk_and_l: term Prims.list -> FStar_Range.range -> term =
  fun l  ->
    fun r  ->
      let uu____6826 = mkTrue r in
      FStar_List.fold_right (fun p1  -> fun p2  -> mkAnd (p1, p2) r) l
        uu____6826
let mk_or_l: term Prims.list -> FStar_Range.range -> term =
  fun l  ->
    fun r  ->
      let uu____6843 = mkFalse r in
      FStar_List.fold_right (fun p1  -> fun p2  -> mkOr (p1, p2) r) l
        uu____6843
let mk_haseq: term -> term =
  fun t  ->
    let uu____6852 = mkApp ("Prims.hasEq", [t]) t.rng in mk_Valid uu____6852