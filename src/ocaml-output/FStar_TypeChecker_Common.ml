open Prims
type rel =
  | EQ 
  | SUB 
  | SUBINV 
let uu___is_EQ : rel -> Prims.bool =
  fun projectee  -> match projectee with | EQ  -> true | uu____4 -> false 
let uu___is_SUB : rel -> Prims.bool =
  fun projectee  -> match projectee with | SUB  -> true | uu____8 -> false 
let uu___is_SUBINV : rel -> Prims.bool =
  fun projectee  ->
    match projectee with | SUBINV  -> true | uu____12 -> false
  
type ('a,'b) problem =
  {
  pid: Prims.int ;
  lhs: 'a ;
  relation: rel ;
  rhs: 'a ;
  element: 'b Prims.option ;
  logical_guard: (FStar_Syntax_Syntax.term* FStar_Syntax_Syntax.term) ;
  scope: FStar_Syntax_Syntax.binders ;
  reason: Prims.string Prims.list ;
  loc: FStar_Range.range ;
  rank: Prims.int Prims.option }
type prob =
  | TProb of (FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.term) problem 
  | CProb of (FStar_Syntax_Syntax.comp,Prims.unit) problem 
let uu___is_TProb : prob -> Prims.bool =
  fun projectee  ->
    match projectee with | TProb _0 -> true | uu____240 -> false
  
let __proj__TProb__item___0 :
  prob -> (FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.term) problem =
  fun projectee  -> match projectee with | TProb _0 -> _0 
let uu___is_CProb : prob -> Prims.bool =
  fun projectee  ->
    match projectee with | CProb _0 -> true | uu____260 -> false
  
let __proj__CProb__item___0 :
  prob -> (FStar_Syntax_Syntax.comp,Prims.unit) problem =
  fun projectee  -> match projectee with | CProb _0 -> _0 
type probs = prob Prims.list
type guard_formula =
  | Trivial 
  | NonTrivial of FStar_Syntax_Syntax.formula 
let uu___is_Trivial : guard_formula -> Prims.bool =
  fun projectee  ->
    match projectee with | Trivial  -> true | uu____281 -> false
  
let uu___is_NonTrivial : guard_formula -> Prims.bool =
  fun projectee  ->
    match projectee with | NonTrivial _0 -> true | uu____286 -> false
  
let __proj__NonTrivial__item___0 :
  guard_formula -> FStar_Syntax_Syntax.formula =
  fun projectee  -> match projectee with | NonTrivial _0 -> _0 
type deferred = (Prims.string* prob) Prims.list
type univ_ineq = (FStar_Syntax_Syntax.universe* FStar_Syntax_Syntax.universe)
let tconst :
  FStar_Ident.lident ->
    (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax
  =
  fun l  ->
    (FStar_Syntax_Syntax.mk
       (FStar_Syntax_Syntax.Tm_fvar
          (FStar_Syntax_Syntax.lid_as_fv l FStar_Syntax_Syntax.Delta_constant
             None))) (Some (FStar_Syntax_Util.ktype0.FStar_Syntax_Syntax.n))
      FStar_Range.dummyRange
  
let tabbrev :
  FStar_Ident.lident ->
    (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax
  =
  fun l  ->
    (FStar_Syntax_Syntax.mk
       (FStar_Syntax_Syntax.Tm_fvar
          (FStar_Syntax_Syntax.lid_as_fv l
             (FStar_Syntax_Syntax.Delta_defined_at_level
                (Prims.parse_int "1")) None)))
      (Some (FStar_Syntax_Util.ktype0.FStar_Syntax_Syntax.n))
      FStar_Range.dummyRange
  
let t_unit :
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tconst FStar_Syntax_Const.unit_lid 
let t_bool :
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tconst FStar_Syntax_Const.bool_lid 
let t_int :
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tconst FStar_Syntax_Const.int_lid 
let t_string :
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tconst FStar_Syntax_Const.string_lid 
let t_float :
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tconst FStar_Syntax_Const.float_lid 
let t_char :
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tabbrev FStar_Syntax_Const.char_lid 
let t_range :
  (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
    FStar_Syntax_Syntax.syntax
  = tconst FStar_Syntax_Const.range_lid 
let rec delta_depth_greater_than :
  FStar_Syntax_Syntax.delta_depth ->
    FStar_Syntax_Syntax.delta_depth -> Prims.bool
  =
  fun l  ->
    fun m  ->
      match (l, m) with
      | (FStar_Syntax_Syntax.Delta_constant ,uu____345) -> false
      | (FStar_Syntax_Syntax.Delta_equational ,uu____346) -> true
      | (uu____347,FStar_Syntax_Syntax.Delta_equational ) -> false
      | (FStar_Syntax_Syntax.Delta_defined_at_level
         i,FStar_Syntax_Syntax.Delta_defined_at_level j) -> i > j
      | (FStar_Syntax_Syntax.Delta_defined_at_level
         uu____350,FStar_Syntax_Syntax.Delta_constant ) -> true
      | (FStar_Syntax_Syntax.Delta_abstract d,uu____352) ->
          delta_depth_greater_than d m
      | (uu____353,FStar_Syntax_Syntax.Delta_abstract d) ->
          delta_depth_greater_than l d
  
let rec decr_delta_depth :
  FStar_Syntax_Syntax.delta_depth ->
    FStar_Syntax_Syntax.delta_depth Prims.option
  =
  fun uu___92_358  ->
    match uu___92_358 with
    | FStar_Syntax_Syntax.Delta_constant 
      |FStar_Syntax_Syntax.Delta_equational  -> None
    | FStar_Syntax_Syntax.Delta_defined_at_level _0_169 when
        _0_169 = (Prims.parse_int "1") ->
        Some FStar_Syntax_Syntax.Delta_constant
    | FStar_Syntax_Syntax.Delta_defined_at_level i ->
        Some
          (FStar_Syntax_Syntax.Delta_defined_at_level
             (i - (Prims.parse_int "1")))
    | FStar_Syntax_Syntax.Delta_abstract d -> decr_delta_depth d
  