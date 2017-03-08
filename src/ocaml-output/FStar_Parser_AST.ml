open Prims
let old_mk_tuple_lid: Prims.int -> FStar_Range.range -> FStar_Ident.lident =
  fun n  ->
    fun r  ->
      let t =
        let uu____8 = FStar_Util.string_of_int n in
        FStar_Util.format1 "Tuple%s" uu____8 in
      let uu____9 = FStar_Syntax_Const.pconst t in
      FStar_Ident.set_lid_range uu____9 r
let old_mk_tuple_data_lid:
  Prims.int -> FStar_Range.range -> FStar_Ident.lident =
  fun n  ->
    fun r  ->
      let t =
        let uu____17 = FStar_Util.string_of_int n in
        FStar_Util.format1 "MkTuple%s" uu____17 in
      let uu____18 = FStar_Syntax_Const.pconst t in
      FStar_Ident.set_lid_range uu____18 r
let old_mk_dtuple_lid: Prims.int -> FStar_Range.range -> FStar_Ident.lident =
  fun n  ->
    fun r  ->
      let t =
        let uu____26 = FStar_Util.string_of_int n in
        FStar_Util.format1 "DTuple%s" uu____26 in
      let uu____27 = FStar_Syntax_Const.pconst t in
      FStar_Ident.set_lid_range uu____27 r
let old_mk_dtuple_data_lid:
  Prims.int -> FStar_Range.range -> FStar_Ident.lident =
  fun n  ->
    fun r  ->
      let t =
        let uu____35 = FStar_Util.string_of_int n in
        FStar_Util.format1 "MkDTuple%s" uu____35 in
      let uu____36 = FStar_Syntax_Const.pconst t in
      FStar_Ident.set_lid_range uu____36 r
type level =
  | Un
  | Expr
  | Type_level
  | Kind
  | Formula
let uu___is_Un: level -> Prims.bool =
  fun projectee  -> match projectee with | Un  -> true | uu____40 -> false
let uu___is_Expr: level -> Prims.bool =
  fun projectee  -> match projectee with | Expr  -> true | uu____44 -> false
let uu___is_Type_level: level -> Prims.bool =
  fun projectee  ->
    match projectee with | Type_level  -> true | uu____48 -> false
let uu___is_Kind: level -> Prims.bool =
  fun projectee  -> match projectee with | Kind  -> true | uu____52 -> false
let uu___is_Formula: level -> Prims.bool =
  fun projectee  ->
    match projectee with | Formula  -> true | uu____56 -> false
type imp =
  | FsTypApp
  | Hash
  | UnivApp
  | Nothing
let uu___is_FsTypApp: imp -> Prims.bool =
  fun projectee  ->
    match projectee with | FsTypApp  -> true | uu____60 -> false
let uu___is_Hash: imp -> Prims.bool =
  fun projectee  -> match projectee with | Hash  -> true | uu____64 -> false
let uu___is_UnivApp: imp -> Prims.bool =
  fun projectee  ->
    match projectee with | UnivApp  -> true | uu____68 -> false
let uu___is_Nothing: imp -> Prims.bool =
  fun projectee  ->
    match projectee with | Nothing  -> true | uu____72 -> false
type arg_qualifier =
  | Implicit
  | Equality
let uu___is_Implicit: arg_qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Implicit  -> true | uu____76 -> false
let uu___is_Equality: arg_qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Equality  -> true | uu____80 -> false
type aqual = arg_qualifier Prims.option
type let_qualifier =
  | NoLetQualifier
  | Rec
  | Mutable
let uu___is_NoLetQualifier: let_qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | NoLetQualifier  -> true | uu____85 -> false
let uu___is_Rec: let_qualifier -> Prims.bool =
  fun projectee  -> match projectee with | Rec  -> true | uu____89 -> false
let uu___is_Mutable: let_qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Mutable  -> true | uu____93 -> false
type term' =
  | Wild
  | Const of FStar_Const.sconst
  | Op of (Prims.string* term Prims.list)
  | Tvar of FStar_Ident.ident
  | Uvar of FStar_Ident.ident
  | Var of FStar_Ident.lid
  | Name of FStar_Ident.lid
  | Projector of (FStar_Ident.lid* FStar_Ident.ident)
  | Construct of (FStar_Ident.lid* (term* imp) Prims.list)
  | Abs of (pattern Prims.list* term)
  | App of (term* term* imp)
  | Let of (let_qualifier* (pattern* term) Prims.list* term)
  | LetOpen of (FStar_Ident.lid* term)
  | Seq of (term* term)
  | If of (term* term* term)
  | Match of (term* (pattern* term Prims.option* term) Prims.list)
  | TryWith of (term* (pattern* term Prims.option* term) Prims.list)
  | Ascribed of (term* term)
  | Record of (term Prims.option* (FStar_Ident.lid* term) Prims.list)
  | Project of (term* FStar_Ident.lid)
  | Product of (binder Prims.list* term)
  | Sum of (binder Prims.list* term)
  | QForall of (binder Prims.list* term Prims.list Prims.list* term)
  | QExists of (binder Prims.list* term Prims.list Prims.list* term)
  | Refine of (binder* term)
  | NamedTyp of (FStar_Ident.ident* term)
  | Paren of term
  | Requires of (term* Prims.string Prims.option)
  | Ensures of (term* Prims.string Prims.option)
  | Labeled of (term* Prims.string* Prims.bool)
  | Assign of (FStar_Ident.ident* term)
  | Discrim of FStar_Ident.lid
  | Attributes of term Prims.list
and term = {
  tm: term';
  range: FStar_Range.range;
  level: level;}
and binder' =
  | Variable of FStar_Ident.ident
  | TVariable of FStar_Ident.ident
  | Annotated of (FStar_Ident.ident* term)
  | TAnnotated of (FStar_Ident.ident* term)
  | NoName of term
and binder =
  {
  b: binder';
  brange: FStar_Range.range;
  blevel: level;
  aqual: aqual;}
and pattern' =
  | PatWild
  | PatConst of FStar_Const.sconst
  | PatApp of (pattern* pattern Prims.list)
  | PatVar of (FStar_Ident.ident* arg_qualifier Prims.option)
  | PatName of FStar_Ident.lid
  | PatTvar of (FStar_Ident.ident* arg_qualifier Prims.option)
  | PatList of pattern Prims.list
  | PatTuple of (pattern Prims.list* Prims.bool)
  | PatRecord of (FStar_Ident.lid* pattern) Prims.list
  | PatAscribed of (pattern* term)
  | PatOr of pattern Prims.list
  | PatOp of Prims.string
and pattern = {
  pat: pattern';
  prange: FStar_Range.range;}
let uu___is_Wild: term' -> Prims.bool =
  fun projectee  -> match projectee with | Wild  -> true | uu____378 -> false
let uu___is_Const: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Const _0 -> true | uu____383 -> false
let __proj__Const__item___0: term' -> FStar_Const.sconst =
  fun projectee  -> match projectee with | Const _0 -> _0
let uu___is_Op: term' -> Prims.bool =
  fun projectee  -> match projectee with | Op _0 -> true | uu____398 -> false
let __proj__Op__item___0: term' -> (Prims.string* term Prims.list) =
  fun projectee  -> match projectee with | Op _0 -> _0
let uu___is_Tvar: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tvar _0 -> true | uu____419 -> false
let __proj__Tvar__item___0: term' -> FStar_Ident.ident =
  fun projectee  -> match projectee with | Tvar _0 -> _0
let uu___is_Uvar: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Uvar _0 -> true | uu____431 -> false
let __proj__Uvar__item___0: term' -> FStar_Ident.ident =
  fun projectee  -> match projectee with | Uvar _0 -> _0
let uu___is_Var: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Var _0 -> true | uu____443 -> false
let __proj__Var__item___0: term' -> FStar_Ident.lid =
  fun projectee  -> match projectee with | Var _0 -> _0
let uu___is_Name: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Name _0 -> true | uu____455 -> false
let __proj__Name__item___0: term' -> FStar_Ident.lid =
  fun projectee  -> match projectee with | Name _0 -> _0
let uu___is_Projector: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Projector _0 -> true | uu____469 -> false
let __proj__Projector__item___0:
  term' -> (FStar_Ident.lid* FStar_Ident.ident) =
  fun projectee  -> match projectee with | Projector _0 -> _0
let uu___is_Construct: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Construct _0 -> true | uu____492 -> false
let __proj__Construct__item___0:
  term' -> (FStar_Ident.lid* (term* imp) Prims.list) =
  fun projectee  -> match projectee with | Construct _0 -> _0
let uu___is_Abs: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Abs _0 -> true | uu____522 -> false
let __proj__Abs__item___0: term' -> (pattern Prims.list* term) =
  fun projectee  -> match projectee with | Abs _0 -> _0
let uu___is_App: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | App _0 -> true | uu____546 -> false
let __proj__App__item___0: term' -> (term* term* imp) =
  fun projectee  -> match projectee with | App _0 -> _0
let uu___is_Let: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Let _0 -> true | uu____573 -> false
let __proj__Let__item___0:
  term' -> (let_qualifier* (pattern* term) Prims.list* term) =
  fun projectee  -> match projectee with | Let _0 -> _0
let uu___is_LetOpen: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | LetOpen _0 -> true | uu____605 -> false
let __proj__LetOpen__item___0: term' -> (FStar_Ident.lid* term) =
  fun projectee  -> match projectee with | LetOpen _0 -> _0
let uu___is_Seq: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Seq _0 -> true | uu____625 -> false
let __proj__Seq__item___0: term' -> (term* term) =
  fun projectee  -> match projectee with | Seq _0 -> _0
let uu___is_If: term' -> Prims.bool =
  fun projectee  -> match projectee with | If _0 -> true | uu____646 -> false
let __proj__If__item___0: term' -> (term* term* term) =
  fun projectee  -> match projectee with | If _0 -> _0
let uu___is_Match: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Match _0 -> true | uu____674 -> false
let __proj__Match__item___0:
  term' -> (term* (pattern* term Prims.option* term) Prims.list) =
  fun projectee  -> match projectee with | Match _0 -> _0
let uu___is_TryWith: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | TryWith _0 -> true | uu____714 -> false
let __proj__TryWith__item___0:
  term' -> (term* (pattern* term Prims.option* term) Prims.list) =
  fun projectee  -> match projectee with | TryWith _0 -> _0
let uu___is_Ascribed: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Ascribed _0 -> true | uu____749 -> false
let __proj__Ascribed__item___0: term' -> (term* term) =
  fun projectee  -> match projectee with | Ascribed _0 -> _0
let uu___is_Record: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Record _0 -> true | uu____773 -> false
let __proj__Record__item___0:
  term' -> (term Prims.option* (FStar_Ident.lid* term) Prims.list) =
  fun projectee  -> match projectee with | Record _0 -> _0
let uu___is_Project: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Project _0 -> true | uu____805 -> false
let __proj__Project__item___0: term' -> (term* FStar_Ident.lid) =
  fun projectee  -> match projectee with | Project _0 -> _0
let uu___is_Product: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Product _0 -> true | uu____826 -> false
let __proj__Product__item___0: term' -> (binder Prims.list* term) =
  fun projectee  -> match projectee with | Product _0 -> _0
let uu___is_Sum: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Sum _0 -> true | uu____850 -> false
let __proj__Sum__item___0: term' -> (binder Prims.list* term) =
  fun projectee  -> match projectee with | Sum _0 -> _0
let uu___is_QForall: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | QForall _0 -> true | uu____877 -> false
let __proj__QForall__item___0:
  term' -> (binder Prims.list* term Prims.list Prims.list* term) =
  fun projectee  -> match projectee with | QForall _0 -> _0
let uu___is_QExists: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | QExists _0 -> true | uu____913 -> false
let __proj__QExists__item___0:
  term' -> (binder Prims.list* term Prims.list Prims.list* term) =
  fun projectee  -> match projectee with | QExists _0 -> _0
let uu___is_Refine: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Refine _0 -> true | uu____945 -> false
let __proj__Refine__item___0: term' -> (binder* term) =
  fun projectee  -> match projectee with | Refine _0 -> _0
let uu___is_NamedTyp: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | NamedTyp _0 -> true | uu____965 -> false
let __proj__NamedTyp__item___0: term' -> (FStar_Ident.ident* term) =
  fun projectee  -> match projectee with | NamedTyp _0 -> _0
let uu___is_Paren: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Paren _0 -> true | uu____983 -> false
let __proj__Paren__item___0: term' -> term =
  fun projectee  -> match projectee with | Paren _0 -> _0
let uu___is_Requires: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Requires _0 -> true | uu____998 -> false
let __proj__Requires__item___0: term' -> (term* Prims.string Prims.option) =
  fun projectee  -> match projectee with | Requires _0 -> _0
let uu___is_Ensures: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Ensures _0 -> true | uu____1022 -> false
let __proj__Ensures__item___0: term' -> (term* Prims.string Prims.option) =
  fun projectee  -> match projectee with | Ensures _0 -> _0
let uu___is_Labeled: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Labeled _0 -> true | uu____1046 -> false
let __proj__Labeled__item___0: term' -> (term* Prims.string* Prims.bool) =
  fun projectee  -> match projectee with | Labeled _0 -> _0
let uu___is_Assign: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Assign _0 -> true | uu____1069 -> false
let __proj__Assign__item___0: term' -> (FStar_Ident.ident* term) =
  fun projectee  -> match projectee with | Assign _0 -> _0
let uu___is_Discrim: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Discrim _0 -> true | uu____1087 -> false
let __proj__Discrim__item___0: term' -> FStar_Ident.lid =
  fun projectee  -> match projectee with | Discrim _0 -> _0
let uu___is_Attributes: term' -> Prims.bool =
  fun projectee  ->
    match projectee with | Attributes _0 -> true | uu____1100 -> false
let __proj__Attributes__item___0: term' -> term Prims.list =
  fun projectee  -> match projectee with | Attributes _0 -> _0
let uu___is_Variable: binder' -> Prims.bool =
  fun projectee  ->
    match projectee with | Variable _0 -> true | uu____1127 -> false
let __proj__Variable__item___0: binder' -> FStar_Ident.ident =
  fun projectee  -> match projectee with | Variable _0 -> _0
let uu___is_TVariable: binder' -> Prims.bool =
  fun projectee  ->
    match projectee with | TVariable _0 -> true | uu____1139 -> false
let __proj__TVariable__item___0: binder' -> FStar_Ident.ident =
  fun projectee  -> match projectee with | TVariable _0 -> _0
let uu___is_Annotated: binder' -> Prims.bool =
  fun projectee  ->
    match projectee with | Annotated _0 -> true | uu____1153 -> false
let __proj__Annotated__item___0: binder' -> (FStar_Ident.ident* term) =
  fun projectee  -> match projectee with | Annotated _0 -> _0
let uu___is_TAnnotated: binder' -> Prims.bool =
  fun projectee  ->
    match projectee with | TAnnotated _0 -> true | uu____1173 -> false
let __proj__TAnnotated__item___0: binder' -> (FStar_Ident.ident* term) =
  fun projectee  -> match projectee with | TAnnotated _0 -> _0
let uu___is_NoName: binder' -> Prims.bool =
  fun projectee  ->
    match projectee with | NoName _0 -> true | uu____1191 -> false
let __proj__NoName__item___0: binder' -> term =
  fun projectee  -> match projectee with | NoName _0 -> _0
let uu___is_PatWild: pattern' -> Prims.bool =
  fun projectee  ->
    match projectee with | PatWild  -> true | uu____1218 -> false
let uu___is_PatConst: pattern' -> Prims.bool =
  fun projectee  ->
    match projectee with | PatConst _0 -> true | uu____1223 -> false
let __proj__PatConst__item___0: pattern' -> FStar_Const.sconst =
  fun projectee  -> match projectee with | PatConst _0 -> _0
let uu___is_PatApp: pattern' -> Prims.bool =
  fun projectee  ->
    match projectee with | PatApp _0 -> true | uu____1238 -> false
let __proj__PatApp__item___0: pattern' -> (pattern* pattern Prims.list) =
  fun projectee  -> match projectee with | PatApp _0 -> _0
let uu___is_PatVar: pattern' -> Prims.bool =
  fun projectee  ->
    match projectee with | PatVar _0 -> true | uu____1262 -> false
let __proj__PatVar__item___0:
  pattern' -> (FStar_Ident.ident* arg_qualifier Prims.option) =
  fun projectee  -> match projectee with | PatVar _0 -> _0
let uu___is_PatName: pattern' -> Prims.bool =
  fun projectee  ->
    match projectee with | PatName _0 -> true | uu____1283 -> false
let __proj__PatName__item___0: pattern' -> FStar_Ident.lid =
  fun projectee  -> match projectee with | PatName _0 -> _0
let uu___is_PatTvar: pattern' -> Prims.bool =
  fun projectee  ->
    match projectee with | PatTvar _0 -> true | uu____1298 -> false
let __proj__PatTvar__item___0:
  pattern' -> (FStar_Ident.ident* arg_qualifier Prims.option) =
  fun projectee  -> match projectee with | PatTvar _0 -> _0
let uu___is_PatList: pattern' -> Prims.bool =
  fun projectee  ->
    match projectee with | PatList _0 -> true | uu____1320 -> false
let __proj__PatList__item___0: pattern' -> pattern Prims.list =
  fun projectee  -> match projectee with | PatList _0 -> _0
let uu___is_PatTuple: pattern' -> Prims.bool =
  fun projectee  ->
    match projectee with | PatTuple _0 -> true | uu____1338 -> false
let __proj__PatTuple__item___0: pattern' -> (pattern Prims.list* Prims.bool)
  = fun projectee  -> match projectee with | PatTuple _0 -> _0
let uu___is_PatRecord: pattern' -> Prims.bool =
  fun projectee  ->
    match projectee with | PatRecord _0 -> true | uu____1362 -> false
let __proj__PatRecord__item___0:
  pattern' -> (FStar_Ident.lid* pattern) Prims.list =
  fun projectee  -> match projectee with | PatRecord _0 -> _0
let uu___is_PatAscribed: pattern' -> Prims.bool =
  fun projectee  ->
    match projectee with | PatAscribed _0 -> true | uu____1385 -> false
let __proj__PatAscribed__item___0: pattern' -> (pattern* term) =
  fun projectee  -> match projectee with | PatAscribed _0 -> _0
let uu___is_PatOr: pattern' -> Prims.bool =
  fun projectee  ->
    match projectee with | PatOr _0 -> true | uu____1404 -> false
let __proj__PatOr__item___0: pattern' -> pattern Prims.list =
  fun projectee  -> match projectee with | PatOr _0 -> _0
let uu___is_PatOp: pattern' -> Prims.bool =
  fun projectee  ->
    match projectee with | PatOp _0 -> true | uu____1419 -> false
let __proj__PatOp__item___0: pattern' -> Prims.string =
  fun projectee  -> match projectee with | PatOp _0 -> _0
type branch = (pattern* term Prims.option* term)
type knd = term
type typ = term
type expr = term
type fsdoc = (Prims.string* (Prims.string* Prims.string) Prims.list)
type tycon =
  | TyconAbstract of (FStar_Ident.ident* binder Prims.list* knd
  Prims.option)
  | TyconAbbrev of (FStar_Ident.ident* binder Prims.list* knd Prims.option*
  term)
  | TyconRecord of (FStar_Ident.ident* binder Prims.list* knd Prims.option*
  (FStar_Ident.ident* term* fsdoc Prims.option) Prims.list)
  | TyconVariant of (FStar_Ident.ident* binder Prims.list* knd Prims.option*
  (FStar_Ident.ident* term Prims.option* fsdoc Prims.option* Prims.bool)
  Prims.list)
let uu___is_TyconAbstract: tycon -> Prims.bool =
  fun projectee  ->
    match projectee with | TyconAbstract _0 -> true | uu____1500 -> false
let __proj__TyconAbstract__item___0:
  tycon -> (FStar_Ident.ident* binder Prims.list* knd Prims.option) =
  fun projectee  -> match projectee with | TyconAbstract _0 -> _0
let uu___is_TyconAbbrev: tycon -> Prims.bool =
  fun projectee  ->
    match projectee with | TyconAbbrev _0 -> true | uu____1533 -> false
let __proj__TyconAbbrev__item___0:
  tycon -> (FStar_Ident.ident* binder Prims.list* knd Prims.option* term) =
  fun projectee  -> match projectee with | TyconAbbrev _0 -> _0
let uu___is_TyconRecord: tycon -> Prims.bool =
  fun projectee  ->
    match projectee with | TyconRecord _0 -> true | uu____1574 -> false
let __proj__TyconRecord__item___0:
  tycon ->
    (FStar_Ident.ident* binder Prims.list* knd Prims.option*
      (FStar_Ident.ident* term* fsdoc Prims.option) Prims.list)
  = fun projectee  -> match projectee with | TyconRecord _0 -> _0
let uu___is_TyconVariant: tycon -> Prims.bool =
  fun projectee  ->
    match projectee with | TyconVariant _0 -> true | uu____1632 -> false
let __proj__TyconVariant__item___0:
  tycon ->
    (FStar_Ident.ident* binder Prims.list* knd Prims.option*
      (FStar_Ident.ident* term Prims.option* fsdoc Prims.option* Prims.bool)
      Prims.list)
  = fun projectee  -> match projectee with | TyconVariant _0 -> _0
type qualifier =
  | Private
  | Abstract
  | Noeq
  | Unopteq
  | Assumption
  | DefaultEffect
  | TotalEffect
  | Effect_qual
  | New
  | Inline
  | Visible
  | Unfold_for_unification_and_vcgen
  | Inline_for_extraction
  | Irreducible
  | NoExtract
  | Reifiable
  | Reflectable
  | Opaque
  | Logic
let uu___is_Private: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Private  -> true | uu____1682 -> false
let uu___is_Abstract: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Abstract  -> true | uu____1686 -> false
let uu___is_Noeq: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Noeq  -> true | uu____1690 -> false
let uu___is_Unopteq: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Unopteq  -> true | uu____1694 -> false
let uu___is_Assumption: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Assumption  -> true | uu____1698 -> false
let uu___is_DefaultEffect: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | DefaultEffect  -> true | uu____1702 -> false
let uu___is_TotalEffect: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | TotalEffect  -> true | uu____1706 -> false
let uu___is_Effect_qual: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Effect_qual  -> true | uu____1710 -> false
let uu___is_New: qualifier -> Prims.bool =
  fun projectee  -> match projectee with | New  -> true | uu____1714 -> false
let uu___is_Inline: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Inline  -> true | uu____1718 -> false
let uu___is_Visible: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Visible  -> true | uu____1722 -> false
let uu___is_Unfold_for_unification_and_vcgen: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with
    | Unfold_for_unification_and_vcgen  -> true
    | uu____1726 -> false
let uu___is_Inline_for_extraction: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with
    | Inline_for_extraction  -> true
    | uu____1730 -> false
let uu___is_Irreducible: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Irreducible  -> true | uu____1734 -> false
let uu___is_NoExtract: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | NoExtract  -> true | uu____1738 -> false
let uu___is_Reifiable: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Reifiable  -> true | uu____1742 -> false
let uu___is_Reflectable: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Reflectable  -> true | uu____1746 -> false
let uu___is_Opaque: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Opaque  -> true | uu____1750 -> false
let uu___is_Logic: qualifier -> Prims.bool =
  fun projectee  ->
    match projectee with | Logic  -> true | uu____1754 -> false
type qualifiers = qualifier Prims.list
type attributes_ = term Prims.list
type decoration =
  | Qualifier of qualifier
  | DeclAttributes of term Prims.list
  | Doc of fsdoc
let uu___is_Qualifier: decoration -> Prims.bool =
  fun projectee  ->
    match projectee with | Qualifier _0 -> true | uu____1771 -> false
let __proj__Qualifier__item___0: decoration -> qualifier =
  fun projectee  -> match projectee with | Qualifier _0 -> _0
let uu___is_DeclAttributes: decoration -> Prims.bool =
  fun projectee  ->
    match projectee with | DeclAttributes _0 -> true | uu____1784 -> false
let __proj__DeclAttributes__item___0: decoration -> term Prims.list =
  fun projectee  -> match projectee with | DeclAttributes _0 -> _0
let uu___is_Doc: decoration -> Prims.bool =
  fun projectee  ->
    match projectee with | Doc _0 -> true | uu____1799 -> false
let __proj__Doc__item___0: decoration -> fsdoc =
  fun projectee  -> match projectee with | Doc _0 -> _0
type lift_op =
  | NonReifiableLift of term
  | ReifiableLift of (term* term)
  | LiftForFree of term
let uu___is_NonReifiableLift: lift_op -> Prims.bool =
  fun projectee  ->
    match projectee with | NonReifiableLift _0 -> true | uu____1822 -> false
let __proj__NonReifiableLift__item___0: lift_op -> term =
  fun projectee  -> match projectee with | NonReifiableLift _0 -> _0
let uu___is_ReifiableLift: lift_op -> Prims.bool =
  fun projectee  ->
    match projectee with | ReifiableLift _0 -> true | uu____1836 -> false
let __proj__ReifiableLift__item___0: lift_op -> (term* term) =
  fun projectee  -> match projectee with | ReifiableLift _0 -> _0
let uu___is_LiftForFree: lift_op -> Prims.bool =
  fun projectee  ->
    match projectee with | LiftForFree _0 -> true | uu____1854 -> false
let __proj__LiftForFree__item___0: lift_op -> term =
  fun projectee  -> match projectee with | LiftForFree _0 -> _0
type lift =
  {
  msource: FStar_Ident.lid;
  mdest: FStar_Ident.lid;
  lift_op: lift_op;}
type pragma =
  | SetOptions of Prims.string
  | ResetOptions of Prims.string Prims.option
  | LightOff
let uu___is_SetOptions: pragma -> Prims.bool =
  fun projectee  ->
    match projectee with | SetOptions _0 -> true | uu____1894 -> false
let __proj__SetOptions__item___0: pragma -> Prims.string =
  fun projectee  -> match projectee with | SetOptions _0 -> _0
let uu___is_ResetOptions: pragma -> Prims.bool =
  fun projectee  ->
    match projectee with | ResetOptions _0 -> true | uu____1907 -> false
let __proj__ResetOptions__item___0: pragma -> Prims.string Prims.option =
  fun projectee  -> match projectee with | ResetOptions _0 -> _0
let uu___is_LightOff: pragma -> Prims.bool =
  fun projectee  ->
    match projectee with | LightOff  -> true | uu____1921 -> false
type decl' =
  | TopLevelModule of FStar_Ident.lid
  | Open of FStar_Ident.lid
  | Include of FStar_Ident.lid
  | ModuleAbbrev of (FStar_Ident.ident* FStar_Ident.lid)
  | TopLevelLet of (let_qualifier* (pattern* term) Prims.list)
  | Main of term
  | Tycon of (Prims.bool* (tycon* fsdoc Prims.option) Prims.list)
  | Val of (FStar_Ident.ident* term)
  | Exception of (FStar_Ident.ident* term Prims.option)
  | NewEffect of effect_decl
  | NewEffectForFree of effect_decl
  | SubEffect of lift
  | Pragma of pragma
  | Fsdoc of fsdoc
  | Assume of (FStar_Ident.ident* term)
and decl =
  {
  d: decl';
  drange: FStar_Range.range;
  doc: fsdoc Prims.option;
  quals: qualifiers;
  attrs: attributes_;}
and effect_decl =
  | DefineEffect of (FStar_Ident.ident* binder Prims.list* term* decl
  Prims.list)
  | RedefineEffect of (FStar_Ident.ident* binder Prims.list* term)
let uu___is_TopLevelModule: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | TopLevelModule _0 -> true | uu____2023 -> false
let __proj__TopLevelModule__item___0: decl' -> FStar_Ident.lid =
  fun projectee  -> match projectee with | TopLevelModule _0 -> _0
let uu___is_Open: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | Open _0 -> true | uu____2035 -> false
let __proj__Open__item___0: decl' -> FStar_Ident.lid =
  fun projectee  -> match projectee with | Open _0 -> _0
let uu___is_Include: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | Include _0 -> true | uu____2047 -> false
let __proj__Include__item___0: decl' -> FStar_Ident.lid =
  fun projectee  -> match projectee with | Include _0 -> _0
let uu___is_ModuleAbbrev: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | ModuleAbbrev _0 -> true | uu____2061 -> false
let __proj__ModuleAbbrev__item___0:
  decl' -> (FStar_Ident.ident* FStar_Ident.lid) =
  fun projectee  -> match projectee with | ModuleAbbrev _0 -> _0
let uu___is_TopLevelLet: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | TopLevelLet _0 -> true | uu____2084 -> false
let __proj__TopLevelLet__item___0:
  decl' -> (let_qualifier* (pattern* term) Prims.list) =
  fun projectee  -> match projectee with | TopLevelLet _0 -> _0
let uu___is_Main: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | Main _0 -> true | uu____2111 -> false
let __proj__Main__item___0: decl' -> term =
  fun projectee  -> match projectee with | Main _0 -> _0
let uu___is_Tycon: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | Tycon _0 -> true | uu____2129 -> false
let __proj__Tycon__item___0:
  decl' -> (Prims.bool* (tycon* fsdoc Prims.option) Prims.list) =
  fun projectee  -> match projectee with | Tycon _0 -> _0
let uu___is_Val: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | Val _0 -> true | uu____2161 -> false
let __proj__Val__item___0: decl' -> (FStar_Ident.ident* term) =
  fun projectee  -> match projectee with | Val _0 -> _0
let uu___is_Exception: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | Exception _0 -> true | uu____2182 -> false
let __proj__Exception__item___0:
  decl' -> (FStar_Ident.ident* term Prims.option) =
  fun projectee  -> match projectee with | Exception _0 -> _0
let uu___is_NewEffect: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | NewEffect _0 -> true | uu____2203 -> false
let __proj__NewEffect__item___0: decl' -> effect_decl =
  fun projectee  -> match projectee with | NewEffect _0 -> _0
let uu___is_NewEffectForFree: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | NewEffectForFree _0 -> true | uu____2215 -> false
let __proj__NewEffectForFree__item___0: decl' -> effect_decl =
  fun projectee  -> match projectee with | NewEffectForFree _0 -> _0
let uu___is_SubEffect: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | SubEffect _0 -> true | uu____2227 -> false
let __proj__SubEffect__item___0: decl' -> lift =
  fun projectee  -> match projectee with | SubEffect _0 -> _0
let uu___is_Pragma: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | Pragma _0 -> true | uu____2239 -> false
let __proj__Pragma__item___0: decl' -> pragma =
  fun projectee  -> match projectee with | Pragma _0 -> _0
let uu___is_Fsdoc: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | Fsdoc _0 -> true | uu____2251 -> false
let __proj__Fsdoc__item___0: decl' -> fsdoc =
  fun projectee  -> match projectee with | Fsdoc _0 -> _0
let uu___is_Assume: decl' -> Prims.bool =
  fun projectee  ->
    match projectee with | Assume _0 -> true | uu____2265 -> false
let __proj__Assume__item___0: decl' -> (FStar_Ident.ident* term) =
  fun projectee  -> match projectee with | Assume _0 -> _0
let uu___is_DefineEffect: effect_decl -> Prims.bool =
  fun projectee  ->
    match projectee with | DefineEffect _0 -> true | uu____2311 -> false
let __proj__DefineEffect__item___0:
  effect_decl ->
    (FStar_Ident.ident* binder Prims.list* term* decl Prims.list)
  = fun projectee  -> match projectee with | DefineEffect _0 -> _0
let uu___is_RedefineEffect: effect_decl -> Prims.bool =
  fun projectee  ->
    match projectee with | RedefineEffect _0 -> true | uu____2345 -> false
let __proj__RedefineEffect__item___0:
  effect_decl -> (FStar_Ident.ident* binder Prims.list* term) =
  fun projectee  -> match projectee with | RedefineEffect _0 -> _0
type modul =
  | Module of (FStar_Ident.lid* decl Prims.list)
  | Interface of (FStar_Ident.lid* decl Prims.list* Prims.bool)
let uu___is_Module: modul -> Prims.bool =
  fun projectee  ->
    match projectee with | Module _0 -> true | uu____2385 -> false
let __proj__Module__item___0: modul -> (FStar_Ident.lid* decl Prims.list) =
  fun projectee  -> match projectee with | Module _0 -> _0
let uu___is_Interface: modul -> Prims.bool =
  fun projectee  ->
    match projectee with | Interface _0 -> true | uu____2410 -> false
let __proj__Interface__item___0:
  modul -> (FStar_Ident.lid* decl Prims.list* Prims.bool) =
  fun projectee  -> match projectee with | Interface _0 -> _0
type file = modul Prims.list
type inputFragment = (file,decl Prims.list) FStar_Util.either
let check_id: FStar_Ident.ident -> Prims.unit =
  fun id  ->
    let first_char =
      FStar_String.substring id.FStar_Ident.idText (Prims.parse_int "0")
        (Prims.parse_int "1") in
    if (FStar_String.lowercase first_char) = first_char
    then ()
    else
      (let uu____2439 =
         let uu____2440 =
           let uu____2443 =
             FStar_Util.format1
               "Invalid identifer '%s'; expected a symbol that begins with a lower-case character"
               id.FStar_Ident.idText in
           (uu____2443, (id.FStar_Ident.idRange)) in
         FStar_Errors.Error uu____2440 in
       Prims.raise uu____2439)
let at_most_one s r l =
  match l with
  | x::[] -> Some x
  | [] -> None
  | uu____2465 ->
      let uu____2467 =
        let uu____2468 =
          let uu____2471 =
            FStar_Util.format1 "At most one %s is allowed on declarations" s in
          (uu____2471, r) in
        FStar_Errors.Error uu____2468 in
      Prims.raise uu____2467
let mk_decl: decl' -> FStar_Range.range -> decoration Prims.list -> decl =
  fun d  ->
    fun r  ->
      fun decorations  ->
        let doc =
          let uu____2486 =
            FStar_List.choose
              (fun uu___104_2488  ->
                 match uu___104_2488 with
                 | Doc d -> Some d
                 | uu____2491 -> None) decorations in
          at_most_one "fsdoc" r uu____2486 in
        let attributes_ =
          let uu____2495 =
            FStar_List.choose
              (fun uu___105_2499  ->
                 match uu___105_2499 with
                 | DeclAttributes a -> Some a
                 | uu____2505 -> None) decorations in
          at_most_one "attribute set" r uu____2495 in
        let attributes_ = FStar_Util.dflt [] attributes_ in
        let qualifiers =
          FStar_List.choose
            (fun uu___106_2513  ->
               match uu___106_2513 with
               | Qualifier q -> Some q
               | uu____2516 -> None) decorations in
        { d; drange = r; doc; quals = qualifiers; attrs = attributes_ }
let mk_binder: binder' -> FStar_Range.range -> level -> aqual -> binder =
  fun b  ->
    fun r  -> fun l  -> fun i  -> { b; brange = r; blevel = l; aqual = i }
let mk_term: term' -> FStar_Range.range -> level -> term =
  fun t  -> fun r  -> fun l  -> { tm = t; range = r; level = l }
let mk_uminus: term -> FStar_Range.range -> level -> term =
  fun t  ->
    fun r  ->
      fun l  ->
        let t =
          match t.tm with
          | Const (FStar_Const.Const_int
              (s,Some (FStar_Const.Signed ,width))) ->
              Const
                (FStar_Const.Const_int
                   ((Prims.strcat "-" s), (Some (FStar_Const.Signed, width))))
          | uu____2560 -> Op ("-", [t]) in
        mk_term t r l
let mk_pattern: pattern' -> FStar_Range.range -> pattern =
  fun p  -> fun r  -> { pat = p; prange = r }
let un_curry_abs: pattern Prims.list -> term -> term' =
  fun ps  ->
    fun body  ->
      match body.tm with
      | Abs (p',body') -> Abs ((FStar_List.append ps p'), body')
      | uu____2581 -> Abs (ps, body)
let mk_function:
  (pattern* term Prims.option* term) Prims.list ->
    FStar_Range.range -> FStar_Range.range -> term
  =
  fun branches  ->
    fun r1  ->
      fun r2  ->
        let x = let i = FStar_Syntax_Syntax.next_id () in FStar_Ident.gen r1 in
        let uu____2604 =
          let uu____2605 =
            let uu____2609 =
              let uu____2610 =
                let uu____2611 =
                  let uu____2619 =
                    let uu____2620 =
                      let uu____2621 = FStar_Ident.lid_of_ids [x] in
                      Var uu____2621 in
                    mk_term uu____2620 r1 Expr in
                  (uu____2619, branches) in
                Match uu____2611 in
              mk_term uu____2610 r2 Expr in
            ([mk_pattern (PatVar (x, None)) r1], uu____2609) in
          Abs uu____2605 in
        mk_term uu____2604 r2 Expr
let un_function: pattern -> term -> (pattern* term) Prims.option =
  fun p  ->
    fun tm  ->
      match ((p.pat), (tm.tm)) with
      | (PatVar uu____2641,Abs (pats,body)) ->
          Some ((mk_pattern (PatApp (p, pats)) p.prange), body)
      | uu____2652 -> None
let lid_with_range:
  FStar_Ident.lident -> FStar_Range.range -> FStar_Ident.lident =
  fun lid  ->
    fun r  ->
      let uu____2663 = FStar_Ident.path_of_lid lid in
      FStar_Ident.lid_of_path uu____2663 r
let consPat: FStar_Range.range -> pattern -> pattern -> pattern' =
  fun r  ->
    fun hd  ->
      fun tl  ->
        PatApp
          ((mk_pattern (PatName FStar_Syntax_Const.cons_lid) r), [hd; tl])
let consTerm: FStar_Range.range -> term -> term -> term =
  fun r  ->
    fun hd  ->
      fun tl  ->
        mk_term
          (Construct
             (FStar_Syntax_Const.cons_lid, [(hd, Nothing); (tl, Nothing)])) r
          Expr
let lexConsTerm: FStar_Range.range -> term -> term -> term =
  fun r  ->
    fun hd  ->
      fun tl  ->
        mk_term
          (Construct
             (FStar_Syntax_Const.lexcons_lid, [(hd, Nothing); (tl, Nothing)]))
          r Expr
let mkConsList: FStar_Range.range -> term Prims.list -> term =
  fun r  ->
    fun elts  ->
      let nil = mk_term (Construct (FStar_Syntax_Const.nil_lid, [])) r Expr in
      FStar_List.fold_right (fun e  -> fun tl  -> consTerm r e tl) elts nil
let mkLexList: FStar_Range.range -> term Prims.list -> term =
  fun r  ->
    fun elts  ->
      let nil =
        mk_term (Construct (FStar_Syntax_Const.lextop_lid, [])) r Expr in
      FStar_List.fold_right (fun e  -> fun tl  -> lexConsTerm r e tl) elts
        nil
let ml_comp: term -> term =
  fun t  ->
    let ml = mk_term (Name FStar_Syntax_Const.effect_ML_lid) t.range Expr in
    let t = mk_term (App (ml, t, Nothing)) t.range Expr in t
let tot_comp: term -> term =
  fun t  ->
    let ml = mk_term (Name FStar_Syntax_Const.effect_Tot_lid) t.range Expr in
    let t = mk_term (App (ml, t, Nothing)) t.range Expr in t
let mkApp: term -> (term* imp) Prims.list -> FStar_Range.range -> term =
  fun t  ->
    fun args  ->
      fun r  ->
        match args with
        | [] -> t
        | uu____2770 ->
            (match t.tm with
             | Name s -> mk_term (Construct (s, args)) r Un
             | uu____2778 ->
                 FStar_List.fold_left
                   (fun t  ->
                      fun uu____2782  ->
                        match uu____2782 with
                        | (a,imp) -> mk_term (App (t, a, imp)) r Un) t args)
let mkRefSet: FStar_Range.range -> term Prims.list -> term =
  fun r  ->
    fun elts  ->
      let uu____2795 =
        (FStar_Syntax_Const.tset_empty, FStar_Syntax_Const.tset_singleton,
          FStar_Syntax_Const.tset_union) in
      match uu____2795 with
      | (empty_lid,singleton_lid,union_lid) ->
          let empty =
            mk_term (Var (FStar_Ident.set_lid_range empty_lid r)) r Expr in
          let ref_constr =
            mk_term
              (Var (FStar_Ident.set_lid_range FStar_Syntax_Const.heap_ref r))
              r Expr in
          let singleton =
            mk_term (Var (FStar_Ident.set_lid_range singleton_lid r)) r Expr in
          let union =
            mk_term (Var (FStar_Ident.set_lid_range union_lid r)) r Expr in
          FStar_List.fold_right
            (fun e  ->
               fun tl  ->
                 let e = mkApp ref_constr [(e, Nothing)] r in
                 let single_e = mkApp singleton [(e, Nothing)] r in
                 mkApp union [(single_e, Nothing); (tl, Nothing)] r) elts
            empty
let mkExplicitApp: term -> term Prims.list -> FStar_Range.range -> term =
  fun t  ->
    fun args  ->
      fun r  ->
        match args with
        | [] -> t
        | uu____2835 ->
            (match t.tm with
             | Name s ->
                 let uu____2838 =
                   let uu____2839 =
                     let uu____2845 =
                       FStar_List.map (fun a  -> (a, Nothing)) args in
                     (s, uu____2845) in
                   Construct uu____2839 in
                 mk_term uu____2838 r Un
             | uu____2855 ->
                 FStar_List.fold_left
                   (fun t  -> fun a  -> mk_term (App (t, a, Nothing)) r Un) t
                   args)
let mkAdmitMagic: FStar_Range.range -> term =
  fun r  ->
    let unit_const = mk_term (Const FStar_Const.Const_unit) r Expr in
    let admit =
      let admit_name =
        mk_term
          (Var (FStar_Ident.set_lid_range FStar_Syntax_Const.admit_lid r)) r
          Expr in
      mkExplicitApp admit_name [unit_const] r in
    let magic =
      let magic_name =
        mk_term
          (Var (FStar_Ident.set_lid_range FStar_Syntax_Const.magic_lid r)) r
          Expr in
      mkExplicitApp magic_name [unit_const] r in
    let admit_magic = mk_term (Seq (admit, magic)) r Expr in admit_magic
let mkWildAdmitMagic r =
  let uu____2878 = mkAdmitMagic r in
  ((mk_pattern PatWild r), None, uu____2878)
let focusBranches branches r =
  let should_filter = FStar_Util.for_some Prims.fst branches in
  if should_filter
  then
    (FStar_Errors.warn r "Focusing on only some cases";
     (let focussed =
        let uu____2934 = FStar_List.filter Prims.fst branches in
        FStar_All.pipe_right uu____2934 (FStar_List.map Prims.snd) in
      let uu____2978 = let uu____2984 = mkWildAdmitMagic r in [uu____2984] in
      FStar_List.append focussed uu____2978))
  else FStar_All.pipe_right branches (FStar_List.map Prims.snd)
let focusLetBindings lbs r =
  let should_filter = FStar_Util.for_some Prims.fst lbs in
  if should_filter
  then
    (FStar_Errors.warn r
       "Focusing on only some cases in this (mutually) recursive definition";
     FStar_List.map
       (fun uu____3070  ->
          match uu____3070 with
          | (f,lb) ->
              if f
              then lb
              else
                (let uu____3086 = mkAdmitMagic r in
                 ((Prims.fst lb), uu____3086))) lbs)
  else FStar_All.pipe_right lbs (FStar_List.map Prims.snd)
let mkFsTypApp: term -> term Prims.list -> FStar_Range.range -> term =
  fun t  ->
    fun args  ->
      fun r  ->
        let uu____3115 = FStar_List.map (fun a  -> (a, FsTypApp)) args in
        mkApp t uu____3115 r
let mkTuple: term Prims.list -> FStar_Range.range -> term =
  fun args  ->
    fun r  ->
      let cons =
        FStar_Syntax_Util.mk_tuple_data_lid (FStar_List.length args) r in
      let uu____3134 = FStar_List.map (fun x  -> (x, Nothing)) args in
      mkApp (mk_term (Name cons) r Expr) uu____3134 r
let mkDTuple: term Prims.list -> FStar_Range.range -> term =
  fun args  ->
    fun r  ->
      let cons =
        FStar_Syntax_Util.mk_dtuple_data_lid (FStar_List.length args) r in
      let uu____3153 = FStar_List.map (fun x  -> (x, Nothing)) args in
      mkApp (mk_term (Name cons) r Expr) uu____3153 r
let mkRefinedBinder:
  FStar_Ident.ident ->
    term ->
      Prims.bool -> term Prims.option -> FStar_Range.range -> aqual -> binder
  =
  fun id  ->
    fun t  ->
      fun should_bind_var  ->
        fun refopt  ->
          fun m  ->
            fun implicit  ->
              let b = mk_binder (Annotated (id, t)) m Type_level implicit in
              match refopt with
              | None  -> b
              | Some phi ->
                  if should_bind_var
                  then
                    mk_binder
                      (Annotated
                         (id, (mk_term (Refine (b, phi)) m Type_level))) m
                      Type_level implicit
                  else
                    (let x = FStar_Ident.gen t.range in
                     let b =
                       mk_binder (Annotated (x, t)) m Type_level implicit in
                     mk_binder
                       (Annotated
                          (id, (mk_term (Refine (b, phi)) m Type_level))) m
                       Type_level implicit)
let mkRefinedPattern:
  pattern ->
    term ->
      Prims.bool ->
        term Prims.option ->
          FStar_Range.range -> FStar_Range.range -> pattern
  =
  fun pat  ->
    fun t  ->
      fun should_bind_pat  ->
        fun phi_opt  ->
          fun t_range  ->
            fun range  ->
              let t =
                match phi_opt with
                | None  -> t
                | Some phi ->
                    if should_bind_pat
                    then
                      (match pat.pat with
                       | PatVar (x,uu____3208) ->
                           mk_term
                             (Refine
                                ((mk_binder (Annotated (x, t)) t_range
                                    Type_level None), phi)) range Type_level
                       | uu____3211 ->
                           let x = FStar_Ident.gen t_range in
                           let phi =
                             let x_var =
                               let uu____3215 =
                                 let uu____3216 = FStar_Ident.lid_of_ids [x] in
                                 Var uu____3216 in
                               mk_term uu____3215 phi.range Formula in
                             let pat_branch = (pat, None, phi) in
                             let otherwise_branch =
                               let uu____3228 =
                                 let uu____3229 =
                                   let uu____3230 =
                                     FStar_Ident.lid_of_path ["False"]
                                       phi.range in
                                   Name uu____3230 in
                                 mk_term uu____3229 phi.range Formula in
                               ((mk_pattern PatWild phi.range), None,
                                 uu____3228) in
                             mk_term
                               (Match (x_var, [pat_branch; otherwise_branch]))
                               phi.range Formula in
                           mk_term
                             (Refine
                                ((mk_binder (Annotated (x, t)) t_range
                                    Type_level None), phi)) range Type_level)
                    else
                      (let x = FStar_Ident.gen t.range in
                       mk_term
                         (Refine
                            ((mk_binder (Annotated (x, t)) t_range Type_level
                                None), phi)) range Type_level) in
              mk_pattern (PatAscribed (pat, t)) range
let rec extract_named_refinement:
  term -> (FStar_Ident.ident* term* term Prims.option) Prims.option =
  fun t1  ->
    match t1.tm with
    | NamedTyp (x,t) -> Some (x, t, None)
    | Refine
        ({ b = Annotated (x,t); brange = uu____3273; blevel = uu____3274;
           aqual = uu____3275;_},t')
        -> Some (x, t, (Some t'))
    | Paren t -> extract_named_refinement t
    | uu____3283 -> None
let rec as_mlist:
  modul Prims.list ->
    ((FStar_Ident.lid* decl)* decl Prims.list) ->
      decl Prims.list -> modul Prims.list
  =
  fun out  ->
    fun cur  ->
      fun ds  ->
        let uu____3313 = cur in
        match uu____3313 with
        | ((m_name,m_decl),cur) ->
            (match ds with
             | [] ->
                 FStar_List.rev
                   ((Module (m_name, (m_decl :: (FStar_List.rev cur)))) ::
                   out)
             | d::ds ->
                 (match d.d with
                  | TopLevelModule m' ->
                      as_mlist
                        ((Module (m_name, (m_decl :: (FStar_List.rev cur))))
                        :: out) ((m', d), []) ds
                  | uu____3338 ->
                      as_mlist out ((m_name, m_decl), (d :: cur)) ds))
let as_frag:
  Prims.bool ->
    FStar_Range.range ->
      decl ->
        decl Prims.list ->
          (modul Prims.list,decl Prims.list) FStar_Util.either
  =
  fun is_light  ->
    fun light_range  ->
      fun d  ->
        fun ds  ->
          match d.d with
          | TopLevelModule m ->
              let ds =
                if is_light
                then
                  let uu____3372 = mk_decl (Pragma LightOff) light_range [] in
                  uu____3372 :: ds
                else ds in
              let ms = as_mlist [] ((m, d), []) ds in
              ((let uu____3380 = FStar_List.tl ms in
                match uu____3380 with
                | (Module (m',uu____3383))::uu____3384 ->
                    let msg =
                      "Support for more than one module in a file is deprecated" in
                    let uu____3389 =
                      FStar_Range.string_of_range
                        (FStar_Ident.range_of_lid m') in
                    FStar_Util.print2_warning "%s (Warning): %s\n" uu____3389
                      msg
                | uu____3390 -> ());
               FStar_Util.Inl ms)
          | uu____3394 ->
              let ds = d :: ds in
              (FStar_List.iter
                 (fun uu___107_3398  ->
                    match uu___107_3398 with
                    | { d = TopLevelModule uu____3399; drange = r;
                        doc = uu____3401; quals = uu____3402;
                        attrs = uu____3403;_} ->
                        Prims.raise
                          (FStar_Errors.Error
                             ("Unexpected module declaration", r))
                    | uu____3405 -> ()) ds;
               FStar_Util.Inr ds)
let compile_op: Prims.int -> Prims.string -> Prims.string =
  fun arity  ->
    fun s  ->
      let name_of_char uu___108_3417 =
        match uu___108_3417 with
        | '&' -> "Amp"
        | '@' -> "At"
        | '+' -> "Plus"
        | '-' when arity = (Prims.parse_int "1") -> "Minus"
        | '-' -> "Subtraction"
        | '/' -> "Slash"
        | '<' -> "Less"
        | '=' -> "Equals"
        | '>' -> "Greater"
        | '_' -> "Underscore"
        | '|' -> "Bar"
        | '!' -> "Bang"
        | '^' -> "Hat"
        | '%' -> "Percent"
        | '*' -> "Star"
        | '?' -> "Question"
        | ':' -> "Colon"
        | uu____3418 -> "UNKNOWN" in
      match s with
      | ".[]<-" -> "op_String_Assignment"
      | ".()<-" -> "op_Array_Assignment"
      | ".[]" -> "op_String_Access"
      | ".()" -> "op_Array_Access"
      | uu____3419 ->
          let uu____3420 =
            let uu____3421 =
              let uu____3423 = FStar_String.list_of_string s in
              FStar_List.map name_of_char uu____3423 in
            FStar_String.concat "_" uu____3421 in
          Prims.strcat "op_" uu____3420
let compile_op': Prims.string -> Prims.string =
  fun s  -> compile_op (- (Prims.parse_int "1")) s
let string_of_fsdoc:
  (Prims.string* (Prims.string* Prims.string) Prims.list) -> Prims.string =
  fun uu____3435  ->
    match uu____3435 with
    | (comment,keywords) ->
        let uu____3449 =
          let uu____3450 =
            FStar_List.map
              (fun uu____3454  ->
                 match uu____3454 with
                 | (k,v) -> Prims.strcat k (Prims.strcat "->" v)) keywords in
          FStar_String.concat "," uu____3450 in
        Prims.strcat comment uu____3449
let string_of_let_qualifier: let_qualifier -> Prims.string =
  fun uu___109_3461  ->
    match uu___109_3461 with
    | NoLetQualifier  -> ""
    | Rec  -> "rec"
    | Mutable  -> "mutable"
let to_string_l sep f l =
  let uu____3486 = FStar_List.map f l in FStar_String.concat sep uu____3486
let imp_to_string: imp -> Prims.string =
  fun uu___110_3490  ->
    match uu___110_3490 with | Hash  -> "#" | uu____3491 -> ""
let rec term_to_string: term -> Prims.string =
  fun x  ->
    match x.tm with
    | Wild  -> "_"
    | Requires (t,uu____3502) ->
        let uu____3505 = term_to_string t in
        FStar_Util.format1 "(requires %s)" uu____3505
    | Ensures (t,uu____3507) ->
        let uu____3510 = term_to_string t in
        FStar_Util.format1 "(ensures %s)" uu____3510
    | Labeled (t,l,uu____3513) ->
        let uu____3514 = term_to_string t in
        FStar_Util.format2 "(labeled %s %s)" l uu____3514
    | Const c -> FStar_Syntax_Print.const_to_string c
    | Op (s,xs) ->
        let uu____3520 =
          let uu____3521 =
            FStar_List.map (fun x  -> FStar_All.pipe_right x term_to_string)
              xs in
          FStar_String.concat ", " uu____3521 in
        FStar_Util.format2 "%s(%s)" s uu____3520
    | Tvar id|Uvar id -> id.FStar_Ident.idText
    | Var l|Name l -> l.FStar_Ident.str
    | Construct (l,args) ->
        let uu____3534 =
          to_string_l " "
            (fun uu____3537  ->
               match uu____3537 with
               | (a,imp) ->
                   let uu____3542 = term_to_string a in
                   FStar_Util.format2 "%s%s" (imp_to_string imp) uu____3542)
            args in
        FStar_Util.format2 "(%s %s)" l.FStar_Ident.str uu____3534
    | Abs (pats,t) ->
        let uu____3547 = to_string_l " " pat_to_string pats in
        let uu____3548 = FStar_All.pipe_right t term_to_string in
        FStar_Util.format2 "(fun %s -> %s)" uu____3547 uu____3548
    | App (t1,t2,imp) ->
        let uu____3552 = FStar_All.pipe_right t1 term_to_string in
        let uu____3553 = FStar_All.pipe_right t2 term_to_string in
        FStar_Util.format3 "%s %s%s" uu____3552 (imp_to_string imp)
          uu____3553
    | Let (Rec ,lbs,body) ->
        let uu____3562 =
          to_string_l " and "
            (fun uu____3565  ->
               match uu____3565 with
               | (p,b) ->
                   let uu____3570 = FStar_All.pipe_right p pat_to_string in
                   let uu____3571 = FStar_All.pipe_right b term_to_string in
                   FStar_Util.format2 "%s=%s" uu____3570 uu____3571) lbs in
        let uu____3572 = FStar_All.pipe_right body term_to_string in
        FStar_Util.format2 "let rec %s in %s" uu____3562 uu____3572
    | Let (q,(pat,tm)::[],body) ->
        let uu____3584 = FStar_All.pipe_right pat pat_to_string in
        let uu____3585 = FStar_All.pipe_right tm term_to_string in
        let uu____3586 = FStar_All.pipe_right body term_to_string in
        FStar_Util.format4 "let %s %s = %s in %s" (string_of_let_qualifier q)
          uu____3584 uu____3585 uu____3586
    | Seq (t1,t2) ->
        let uu____3589 = FStar_All.pipe_right t1 term_to_string in
        let uu____3590 = FStar_All.pipe_right t2 term_to_string in
        FStar_Util.format2 "%s; %s" uu____3589 uu____3590
    | If (t1,t2,t3) ->
        let uu____3594 = FStar_All.pipe_right t1 term_to_string in
        let uu____3595 = FStar_All.pipe_right t2 term_to_string in
        let uu____3596 = FStar_All.pipe_right t3 term_to_string in
        FStar_Util.format3 "if %s then %s else %s" uu____3594 uu____3595
          uu____3596
    | Match (t,branches) ->
        let uu____3609 = FStar_All.pipe_right t term_to_string in
        let uu____3610 =
          to_string_l " | "
            (fun uu____3615  ->
               match uu____3615 with
               | (p,w,e) ->
                   let uu____3625 = FStar_All.pipe_right p pat_to_string in
                   let uu____3626 =
                     match w with
                     | None  -> ""
                     | Some e ->
                         let uu____3628 = term_to_string e in
                         FStar_Util.format1 "when %s" uu____3628 in
                   let uu____3629 = FStar_All.pipe_right e term_to_string in
                   FStar_Util.format3 "%s %s -> %s" uu____3625 uu____3626
                     uu____3629) branches in
        FStar_Util.format2 "match %s with %s" uu____3609 uu____3610
    | Ascribed (t1,t2) ->
        let uu____3632 = FStar_All.pipe_right t1 term_to_string in
        let uu____3633 = FStar_All.pipe_right t2 term_to_string in
        FStar_Util.format2 "(%s : %s)" uu____3632 uu____3633
    | Record (Some e,fields) ->
        let uu____3643 = FStar_All.pipe_right e term_to_string in
        let uu____3644 =
          to_string_l " "
            (fun uu____3647  ->
               match uu____3647 with
               | (l,e) ->
                   let uu____3652 = FStar_All.pipe_right e term_to_string in
                   FStar_Util.format2 "%s=%s" l.FStar_Ident.str uu____3652)
            fields in
        FStar_Util.format2 "{%s with %s}" uu____3643 uu____3644
    | Record (None ,fields) ->
        let uu____3661 =
          to_string_l " "
            (fun uu____3664  ->
               match uu____3664 with
               | (l,e) ->
                   let uu____3669 = FStar_All.pipe_right e term_to_string in
                   FStar_Util.format2 "%s=%s" l.FStar_Ident.str uu____3669)
            fields in
        FStar_Util.format1 "{%s}" uu____3661
    | Project (e,l) ->
        let uu____3672 = FStar_All.pipe_right e term_to_string in
        FStar_Util.format2 "%s.%s" uu____3672 l.FStar_Ident.str
    | Product ([],t) -> term_to_string t
    | Product (b::hd::tl,t) ->
        term_to_string
          (mk_term
             (Product
                ([b], (mk_term (Product ((hd :: tl), t)) x.range x.level)))
             x.range x.level)
    | Product (b::[],t) when x.level = Type_level ->
        let uu____3686 = FStar_All.pipe_right b binder_to_string in
        let uu____3687 = FStar_All.pipe_right t term_to_string in
        FStar_Util.format2 "%s -> %s" uu____3686 uu____3687
    | Product (b::[],t) when x.level = Kind ->
        let uu____3691 = FStar_All.pipe_right b binder_to_string in
        let uu____3692 = FStar_All.pipe_right t term_to_string in
        FStar_Util.format2 "%s => %s" uu____3691 uu____3692
    | Sum (binders,t) ->
        let uu____3697 =
          let uu____3698 =
            FStar_All.pipe_right binders (FStar_List.map binder_to_string) in
          FStar_All.pipe_right uu____3698 (FStar_String.concat " * ") in
        let uu____3703 = FStar_All.pipe_right t term_to_string in
        FStar_Util.format2 "%s * %s" uu____3697 uu____3703
    | QForall (bs,pats,t) ->
        let uu____3713 = to_string_l " " binder_to_string bs in
        let uu____3714 =
          to_string_l " \\/ " (to_string_l "; " term_to_string) pats in
        let uu____3716 = FStar_All.pipe_right t term_to_string in
        FStar_Util.format3 "forall %s.{:pattern %s} %s" uu____3713 uu____3714
          uu____3716
    | QExists (bs,pats,t) ->
        let uu____3726 = to_string_l " " binder_to_string bs in
        let uu____3727 =
          to_string_l " \\/ " (to_string_l "; " term_to_string) pats in
        let uu____3729 = FStar_All.pipe_right t term_to_string in
        FStar_Util.format3 "exists %s.{:pattern %s} %s" uu____3726 uu____3727
          uu____3729
    | Refine (b,t) ->
        let uu____3732 = FStar_All.pipe_right b binder_to_string in
        let uu____3733 = FStar_All.pipe_right t term_to_string in
        FStar_Util.format2 "%s:{%s}" uu____3732 uu____3733
    | NamedTyp (x,t) ->
        let uu____3736 = FStar_All.pipe_right t term_to_string in
        FStar_Util.format2 "%s:%s" x.FStar_Ident.idText uu____3736
    | Paren t ->
        let uu____3738 = FStar_All.pipe_right t term_to_string in
        FStar_Util.format1 "(%s)" uu____3738
    | Product (bs,t) ->
        let uu____3743 =
          let uu____3744 =
            FStar_All.pipe_right bs (FStar_List.map binder_to_string) in
          FStar_All.pipe_right uu____3744 (FStar_String.concat ",") in
        let uu____3749 = FStar_All.pipe_right t term_to_string in
        FStar_Util.format2 "Unidentified product: [%s] %s" uu____3743
          uu____3749
    | t -> "_"
and binder_to_string: binder -> Prims.string =
  fun x  ->
    let s =
      match x.b with
      | Variable i -> i.FStar_Ident.idText
      | TVariable i -> FStar_Util.format1 "%s:_" i.FStar_Ident.idText
      | TAnnotated (i,t)|Annotated (i,t) ->
          let uu____3757 = FStar_All.pipe_right t term_to_string in
          FStar_Util.format2 "%s:%s" i.FStar_Ident.idText uu____3757
      | NoName t -> FStar_All.pipe_right t term_to_string in
    let uu____3759 = aqual_to_string x.aqual in
    FStar_Util.format2 "%s%s" uu____3759 s
and aqual_to_string: aqual -> Prims.string =
  fun uu___111_3760  ->
    match uu___111_3760 with
    | Some (Equality ) -> "$"
    | Some (Implicit ) -> "#"
    | uu____3761 -> ""
and pat_to_string: pattern -> Prims.string =
  fun x  ->
    match x.pat with
    | PatWild  -> "_"
    | PatConst c -> FStar_Syntax_Print.const_to_string c
    | PatApp (p,ps) ->
        let uu____3768 = FStar_All.pipe_right p pat_to_string in
        let uu____3769 = to_string_l " " pat_to_string ps in
        FStar_Util.format2 "(%s %s)" uu____3768 uu____3769
    | PatTvar (i,aq)|PatVar (i,aq) ->
        let uu____3776 = aqual_to_string aq in
        FStar_Util.format2 "%s%s" uu____3776 i.FStar_Ident.idText
    | PatName l -> l.FStar_Ident.str
    | PatList l ->
        let uu____3780 = to_string_l "; " pat_to_string l in
        FStar_Util.format1 "[%s]" uu____3780
    | PatTuple (l,false ) ->
        let uu____3784 = to_string_l ", " pat_to_string l in
        FStar_Util.format1 "(%s)" uu____3784
    | PatTuple (l,true ) ->
        let uu____3788 = to_string_l ", " pat_to_string l in
        FStar_Util.format1 "(|%s|)" uu____3788
    | PatRecord l ->
        let uu____3793 =
          to_string_l "; "
            (fun uu____3796  ->
               match uu____3796 with
               | (f,e) ->
                   let uu____3801 = FStar_All.pipe_right e pat_to_string in
                   FStar_Util.format2 "%s=%s" f.FStar_Ident.str uu____3801) l in
        FStar_Util.format1 "{%s}" uu____3793
    | PatOr l -> to_string_l "|\n " pat_to_string l
    | PatOp op -> FStar_Util.format1 "(%s)" op
    | PatAscribed (p,t) ->
        let uu____3807 = FStar_All.pipe_right p pat_to_string in
        let uu____3808 = FStar_All.pipe_right t term_to_string in
        FStar_Util.format2 "(%s:%s)" uu____3807 uu____3808
let rec head_id_of_pat: pattern -> FStar_Ident.lid Prims.list =
  fun p  ->
    match p.pat with
    | PatName l -> [l]
    | PatVar (i,uu____3816) ->
        let uu____3819 = FStar_Ident.lid_of_ids [i] in [uu____3819]
    | PatApp (p,uu____3821) -> head_id_of_pat p
    | PatAscribed (p,uu____3825) -> head_id_of_pat p
    | uu____3826 -> []
let lids_of_let defs =
  FStar_All.pipe_right defs
    (FStar_List.collect
       (fun uu____3847  ->
          match uu____3847 with | (p,uu____3852) -> head_id_of_pat p))
let id_of_tycon: tycon -> Prims.string =
  fun uu___112_3855  ->
    match uu___112_3855 with
    | TyconAbstract (i,_,_)
      |TyconAbbrev (i,_,_,_)|TyconRecord (i,_,_,_)|TyconVariant (i,_,_,_) ->
        i.FStar_Ident.idText
let decl_to_string: decl -> Prims.string =
  fun d  ->
    match d.d with
    | TopLevelModule l -> Prims.strcat "module " l.FStar_Ident.str
    | Open l -> Prims.strcat "open " l.FStar_Ident.str
    | Include l -> Prims.strcat "include " l.FStar_Ident.str
    | ModuleAbbrev (i,l) ->
        FStar_Util.format2 "module %s = %s" i.FStar_Ident.idText
          l.FStar_Ident.str
    | TopLevelLet (uu____3896,pats) ->
        let uu____3904 =
          let uu____3905 =
            let uu____3907 = lids_of_let pats in
            FStar_All.pipe_right uu____3907
              (FStar_List.map (fun l  -> l.FStar_Ident.str)) in
          FStar_All.pipe_right uu____3905 (FStar_String.concat ", ") in
        Prims.strcat "let " uu____3904
    | Main uu____3913 -> "main ..."
    | Assume (i,uu____3915) -> Prims.strcat "assume " i.FStar_Ident.idText
    | Tycon (uu____3916,tys) ->
        let uu____3926 =
          let uu____3927 =
            FStar_All.pipe_right tys
              (FStar_List.map
                 (fun uu____3937  ->
                    match uu____3937 with | (x,uu____3942) -> id_of_tycon x)) in
          FStar_All.pipe_right uu____3927 (FStar_String.concat ", ") in
        Prims.strcat "type " uu____3926
    | Val (i,uu____3947) -> Prims.strcat "val " i.FStar_Ident.idText
    | Exception (i,uu____3949) ->
        Prims.strcat "exception " i.FStar_Ident.idText
    | NewEffect (DefineEffect (i,_,_,_))|NewEffect (RedefineEffect (i,_,_))
        -> Prims.strcat "new_effect " i.FStar_Ident.idText
    | NewEffectForFree (DefineEffect (i,_,_,_))|NewEffectForFree
      (RedefineEffect (i,_,_)) ->
        Prims.strcat "new_effect_for_free " i.FStar_Ident.idText
    | SubEffect uu____3970 -> "sub_effect"
    | Pragma uu____3971 -> "pragma"
    | Fsdoc uu____3972 -> "fsdoc"
let modul_to_string: modul -> Prims.string =
  fun m  ->
    match m with
    | Module (_,decls)|Interface (_,decls,_) ->
        let uu____3984 =
          FStar_All.pipe_right decls (FStar_List.map decl_to_string) in
        FStar_All.pipe_right uu____3984 (FStar_String.concat "\n")
let error msg tm r =
  let tm = FStar_All.pipe_right tm term_to_string in
  let tm =
    if (FStar_String.length tm) >= (Prims.parse_int "80")
    then
      let uu____4011 =
        FStar_Util.substring tm (Prims.parse_int "0") (Prims.parse_int "77") in
      Prims.strcat uu____4011 "..."
    else tm in
  Prims.raise
    (FStar_Errors.Error ((Prims.strcat msg (Prims.strcat "\n" tm)), r))