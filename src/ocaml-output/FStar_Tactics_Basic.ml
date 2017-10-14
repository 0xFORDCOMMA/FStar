open Prims
type name = FStar_Syntax_Syntax.bv[@@deriving show]
type env = FStar_TypeChecker_Env.env[@@deriving show]
type implicits = FStar_TypeChecker_Env.implicits[@@deriving show]
let normalize:
  FStar_TypeChecker_Normalize.step Prims.list ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  =
  fun s  ->
    fun e  ->
      fun t  ->
        FStar_TypeChecker_Normalize.normalize_with_primitive_steps
          FStar_Reflection_Interpreter.reflection_primops s e t
let bnorm:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  = fun e  -> fun t  -> normalize [] e t
type 'a tac =
  {
  tac_f: FStar_Tactics_Types.proofstate -> 'a FStar_Tactics_Result.__result;}
[@@deriving show]
let __proj__Mktac__item__tac_f:
  'a .
    'a tac ->
      FStar_Tactics_Types.proofstate -> 'a FStar_Tactics_Result.__result
  =
  fun projectee  ->
    match projectee with | { tac_f = __fname__tac_f;_} -> __fname__tac_f
let mk_tac:
  'a .
    (FStar_Tactics_Types.proofstate -> 'a FStar_Tactics_Result.__result) ->
      'a tac
  = fun f  -> { tac_f = f }
let run:
  'Auu____88 .
    'Auu____88 tac ->
      FStar_Tactics_Types.proofstate ->
        'Auu____88 FStar_Tactics_Result.__result
  = fun t  -> fun p  -> t.tac_f p
let ret: 'a . 'a -> 'a tac =
  fun x  -> mk_tac (fun p  -> FStar_Tactics_Result.Success (x, p))
let bind: 'a 'b . 'a tac -> ('a -> 'b tac) -> 'b tac =
  fun t1  ->
    fun t2  ->
      mk_tac
        (fun p  ->
           let uu____155 = run t1 p in
           match uu____155 with
           | FStar_Tactics_Result.Success (a,q) ->
               let uu____162 = t2 a in run uu____162 q
           | FStar_Tactics_Result.Failed (msg,q) ->
               FStar_Tactics_Result.Failed (msg, q))
let idtac: Prims.unit tac = ret ()
let goal_to_string: FStar_Tactics_Types.goal -> Prims.string =
  fun g  ->
    let g_binders =
      let uu____174 =
        FStar_TypeChecker_Env.all_binders g.FStar_Tactics_Types.context in
      FStar_All.pipe_right uu____174
        (FStar_Syntax_Print.binders_to_string ", ") in
    let w = bnorm g.FStar_Tactics_Types.context g.FStar_Tactics_Types.witness in
    let t = bnorm g.FStar_Tactics_Types.context g.FStar_Tactics_Types.goal_ty in
    let uu____177 =
      FStar_TypeChecker_Normalize.term_to_string
        g.FStar_Tactics_Types.context w in
    let uu____178 =
      FStar_TypeChecker_Normalize.term_to_string
        g.FStar_Tactics_Types.context t in
    FStar_Util.format3 "%s |- %s : %s" g_binders uu____177 uu____178
let tacprint: Prims.string -> Prims.unit =
  fun s  -> FStar_Util.print1 "TAC>> %s\n" s
let tacprint1: Prims.string -> Prims.string -> Prims.unit =
  fun s  ->
    fun x  ->
      let uu____191 = FStar_Util.format1 s x in
      FStar_Util.print1 "TAC>> %s\n" uu____191
let tacprint2: Prims.string -> Prims.string -> Prims.string -> Prims.unit =
  fun s  ->
    fun x  ->
      fun y  ->
        let uu____204 = FStar_Util.format2 s x y in
        FStar_Util.print1 "TAC>> %s\n" uu____204
let tacprint3:
  Prims.string -> Prims.string -> Prims.string -> Prims.string -> Prims.unit
  =
  fun s  ->
    fun x  ->
      fun y  ->
        fun z  ->
          let uu____221 = FStar_Util.format3 s x y z in
          FStar_Util.print1 "TAC>> %s\n" uu____221
let comp_to_typ: FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.typ =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total (t,uu____227) -> t
    | FStar_Syntax_Syntax.GTotal (t,uu____237) -> t
    | FStar_Syntax_Syntax.Comp ct -> ct.FStar_Syntax_Syntax.result_typ
let is_irrelevant: FStar_Tactics_Types.goal -> Prims.bool =
  fun g  ->
    let uu____251 =
      let uu____256 =
        FStar_TypeChecker_Normalize.unfold_whnf g.FStar_Tactics_Types.context
          g.FStar_Tactics_Types.goal_ty in
      FStar_Syntax_Util.un_squash uu____256 in
    match uu____251 with
    | FStar_Pervasives_Native.Some t -> true
    | uu____262 -> false
let dump_goal:
  'Auu____273 . 'Auu____273 -> FStar_Tactics_Types.goal -> Prims.unit =
  fun ps  ->
    fun goal  -> let uu____283 = goal_to_string goal in tacprint uu____283
let dump_cur: FStar_Tactics_Types.proofstate -> Prims.string -> Prims.unit =
  fun ps  ->
    fun msg  ->
      match ps.FStar_Tactics_Types.goals with
      | [] -> tacprint1 "No more goals (%s)" msg
      | h::uu____293 ->
          (tacprint1 "Current goal (%s):" msg;
           (let uu____297 = FStar_List.hd ps.FStar_Tactics_Types.goals in
            dump_goal ps uu____297))
let ps_to_string:
  (Prims.string,FStar_Tactics_Types.proofstate)
    FStar_Pervasives_Native.tuple2 -> Prims.string
  =
  fun uu____305  ->
    match uu____305 with
    | (msg,ps) ->
        let uu____312 = FStar_Util.string_of_int ps.FStar_Tactics_Types.depth in
        let uu____313 =
          FStar_Util.string_of_int
            (FStar_List.length ps.FStar_Tactics_Types.goals) in
        let uu____314 =
          let uu____315 =
            FStar_List.map goal_to_string ps.FStar_Tactics_Types.goals in
          FStar_String.concat "\n" uu____315 in
        let uu____318 =
          FStar_Util.string_of_int
            (FStar_List.length ps.FStar_Tactics_Types.smt_goals) in
        let uu____319 =
          let uu____320 =
            FStar_List.map goal_to_string ps.FStar_Tactics_Types.smt_goals in
          FStar_String.concat "\n" uu____320 in
        FStar_Util.format6
          "State dump @ depth %s(%s):\nACTIVE goals (%s):\n%s\nSMT goals (%s):\n%s"
          uu____312 msg uu____313 uu____314 uu____318 uu____319
let goal_to_json: FStar_Tactics_Types.goal -> FStar_Util.json =
  fun g  ->
    let g_binders =
      let uu____328 =
        FStar_TypeChecker_Env.all_binders g.FStar_Tactics_Types.context in
      FStar_All.pipe_right uu____328 FStar_Syntax_Print.binders_to_json in
    let uu____329 =
      let uu____336 =
        let uu____343 =
          let uu____348 =
            let uu____349 =
              let uu____356 =
                let uu____361 =
                  let uu____362 =
                    FStar_TypeChecker_Normalize.term_to_string
                      g.FStar_Tactics_Types.context
                      g.FStar_Tactics_Types.witness in
                  FStar_Util.JsonStr uu____362 in
                ("witness", uu____361) in
              let uu____363 =
                let uu____370 =
                  let uu____375 =
                    let uu____376 =
                      FStar_TypeChecker_Normalize.term_to_string
                        g.FStar_Tactics_Types.context
                        g.FStar_Tactics_Types.goal_ty in
                    FStar_Util.JsonStr uu____376 in
                  ("type", uu____375) in
                [uu____370] in
              uu____356 :: uu____363 in
            FStar_Util.JsonAssoc uu____349 in
          ("goal", uu____348) in
        [uu____343] in
      ("hyps", g_binders) :: uu____336 in
    FStar_Util.JsonAssoc uu____329
let ps_to_json:
  (Prims.string,FStar_Tactics_Types.proofstate)
    FStar_Pervasives_Native.tuple2 -> FStar_Util.json
  =
  fun uu____408  ->
    match uu____408 with
    | (msg,ps) ->
        let uu____415 =
          let uu____422 =
            let uu____429 =
              let uu____434 =
                let uu____435 =
                  FStar_List.map goal_to_json ps.FStar_Tactics_Types.goals in
                FStar_Util.JsonList uu____435 in
              ("goals", uu____434) in
            let uu____438 =
              let uu____445 =
                let uu____450 =
                  let uu____451 =
                    FStar_List.map goal_to_json
                      ps.FStar_Tactics_Types.smt_goals in
                  FStar_Util.JsonList uu____451 in
                ("smt-goals", uu____450) in
              [uu____445] in
            uu____429 :: uu____438 in
          ("label", (FStar_Util.JsonStr msg)) :: uu____422 in
        FStar_Util.JsonAssoc uu____415
let dump_proofstate:
  FStar_Tactics_Types.proofstate -> Prims.string -> Prims.unit =
  fun ps  ->
    fun msg  ->
      FStar_Options.with_saved_options
        (fun uu____480  ->
           FStar_Options.set_option "print_effect_args"
             (FStar_Options.Bool true);
           FStar_Util.print_generic "proof-state" ps_to_string ps_to_json
             (msg, ps))
let print_proof_state1: Prims.string -> Prims.unit tac =
  fun msg  ->
    mk_tac
      (fun ps  ->
         let psc = ps.FStar_Tactics_Types.psc in
         let subst1 = FStar_TypeChecker_Normalize.psc_subst psc in
         (let uu____502 = FStar_Tactics_Types.subst_proof_state subst1 ps in
          dump_cur uu____502 msg);
         FStar_Tactics_Result.Success ((), ps))
let print_proof_state: Prims.string -> Prims.unit tac =
  fun msg  ->
    mk_tac
      (fun ps  ->
         let psc = ps.FStar_Tactics_Types.psc in
         let subst1 = FStar_TypeChecker_Normalize.psc_subst psc in
         (let uu____519 = FStar_Tactics_Types.subst_proof_state subst1 ps in
          dump_proofstate uu____519 msg);
         FStar_Tactics_Result.Success ((), ps))
let get: FStar_Tactics_Types.proofstate tac =
  mk_tac (fun p  -> FStar_Tactics_Result.Success (p, p))
let tac_verb_dbg: Prims.bool FStar_Pervasives_Native.option FStar_ST.ref =
  FStar_Util.mk_ref FStar_Pervasives_Native.None
let rec log:
  FStar_Tactics_Types.proofstate -> (Prims.unit -> Prims.unit) -> Prims.unit
  =
  fun ps  ->
    fun f  ->
      let uu____550 = FStar_ST.op_Bang tac_verb_dbg in
      match uu____550 with
      | FStar_Pervasives_Native.None  ->
          ((let uu____604 =
              let uu____607 =
                FStar_TypeChecker_Env.debug
                  ps.FStar_Tactics_Types.main_context
                  (FStar_Options.Other "TacVerbose") in
              FStar_Pervasives_Native.Some uu____607 in
            FStar_ST.op_Colon_Equals tac_verb_dbg uu____604);
           log ps f)
      | FStar_Pervasives_Native.Some (true ) -> f ()
      | FStar_Pervasives_Native.Some (false ) -> ()
let mlog: 'a . (Prims.unit -> Prims.unit) -> (Prims.unit -> 'a tac) -> 'a tac
  = fun f  -> fun cont  -> bind get (fun ps  -> log ps f; cont ())
let fail: 'Auu____697 . Prims.string -> 'Auu____697 tac =
  fun msg  ->
    mk_tac
      (fun ps  ->
         (let uu____708 =
            FStar_TypeChecker_Env.debug ps.FStar_Tactics_Types.main_context
              (FStar_Options.Other "TacFail") in
          if uu____708
          then dump_proofstate ps (Prims.strcat "TACTING FAILING: " msg)
          else ());
         FStar_Tactics_Result.Failed (msg, ps))
let fail1: 'Auu____716 . Prims.string -> Prims.string -> 'Auu____716 tac =
  fun msg  ->
    fun x  -> let uu____727 = FStar_Util.format1 msg x in fail uu____727
let fail2:
  'Auu____736 .
    Prims.string -> Prims.string -> Prims.string -> 'Auu____736 tac
  =
  fun msg  ->
    fun x  ->
      fun y  -> let uu____751 = FStar_Util.format2 msg x y in fail uu____751
let fail3:
  'Auu____762 .
    Prims.string ->
      Prims.string -> Prims.string -> Prims.string -> 'Auu____762 tac
  =
  fun msg  ->
    fun x  ->
      fun y  ->
        fun z  ->
          let uu____781 = FStar_Util.format3 msg x y z in fail uu____781
let trytac: 'a . 'a tac -> 'a FStar_Pervasives_Native.option tac =
  fun t  ->
    mk_tac
      (fun ps  ->
         let tx = FStar_Syntax_Unionfind.new_transaction () in
         let uu____809 = run t ps in
         match uu____809 with
         | FStar_Tactics_Result.Success (a,q) ->
             (FStar_Syntax_Unionfind.commit tx;
              FStar_Tactics_Result.Success
                ((FStar_Pervasives_Native.Some a), q))
         | FStar_Tactics_Result.Failed (uu____823,uu____824) ->
             (FStar_Syntax_Unionfind.rollback tx;
              FStar_Tactics_Result.Success (FStar_Pervasives_Native.None, ps)))
let wrap_err: 'a . Prims.string -> 'a tac -> 'a tac =
  fun pref  ->
    fun t  ->
      mk_tac
        (fun ps  ->
           let uu____856 = run t ps in
           match uu____856 with
           | FStar_Tactics_Result.Success (a,q) ->
               FStar_Tactics_Result.Success (a, q)
           | FStar_Tactics_Result.Failed (msg,q) ->
               FStar_Tactics_Result.Failed
                 ((Prims.strcat pref (Prims.strcat ": " msg)), q))
let set: FStar_Tactics_Types.proofstate -> Prims.unit tac =
  fun p  -> mk_tac (fun uu____874  -> FStar_Tactics_Result.Success ((), p))
let do_unify:
  env -> FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> Prims.bool =
  fun env  ->
    fun t1  ->
      fun t2  ->
        try FStar_TypeChecker_Rel.teq_nosmt env t1 t2
        with | uu____892 -> false
let trysolve:
  FStar_Tactics_Types.goal -> FStar_Syntax_Syntax.term -> Prims.bool =
  fun goal  ->
    fun solution  ->
      do_unify goal.FStar_Tactics_Types.context solution
        goal.FStar_Tactics_Types.witness
let dismiss: Prims.unit tac =
  bind get
    (fun p  ->
       let uu____906 =
         let uu___127_907 = p in
         let uu____908 = FStar_List.tl p.FStar_Tactics_Types.goals in
         {
           FStar_Tactics_Types.main_context =
             (uu___127_907.FStar_Tactics_Types.main_context);
           FStar_Tactics_Types.main_goal =
             (uu___127_907.FStar_Tactics_Types.main_goal);
           FStar_Tactics_Types.all_implicits =
             (uu___127_907.FStar_Tactics_Types.all_implicits);
           FStar_Tactics_Types.goals = uu____908;
           FStar_Tactics_Types.smt_goals =
             (uu___127_907.FStar_Tactics_Types.smt_goals);
           FStar_Tactics_Types.depth =
             (uu___127_907.FStar_Tactics_Types.depth);
           FStar_Tactics_Types.__dump =
             (uu___127_907.FStar_Tactics_Types.__dump);
           FStar_Tactics_Types.psc = (uu___127_907.FStar_Tactics_Types.psc)
         } in
       set uu____906)
let solve:
  FStar_Tactics_Types.goal -> FStar_Syntax_Syntax.term -> Prims.unit tac =
  fun goal  ->
    fun solution  ->
      let uu____923 = trysolve goal solution in
      if uu____923
      then dismiss
      else
        (let uu____927 =
           let uu____928 =
             FStar_TypeChecker_Normalize.term_to_string
               goal.FStar_Tactics_Types.context solution in
           let uu____929 =
             FStar_TypeChecker_Normalize.term_to_string
               goal.FStar_Tactics_Types.context
               goal.FStar_Tactics_Types.witness in
           let uu____930 =
             FStar_TypeChecker_Normalize.term_to_string
               goal.FStar_Tactics_Types.context
               goal.FStar_Tactics_Types.goal_ty in
           FStar_Util.format3 "%s does not solve %s : %s" uu____928 uu____929
             uu____930 in
         fail uu____927)
let dismiss_all: Prims.unit tac =
  bind get
    (fun p  ->
       set
         (let uu___128_937 = p in
          {
            FStar_Tactics_Types.main_context =
              (uu___128_937.FStar_Tactics_Types.main_context);
            FStar_Tactics_Types.main_goal =
              (uu___128_937.FStar_Tactics_Types.main_goal);
            FStar_Tactics_Types.all_implicits =
              (uu___128_937.FStar_Tactics_Types.all_implicits);
            FStar_Tactics_Types.goals = [];
            FStar_Tactics_Types.smt_goals =
              (uu___128_937.FStar_Tactics_Types.smt_goals);
            FStar_Tactics_Types.depth =
              (uu___128_937.FStar_Tactics_Types.depth);
            FStar_Tactics_Types.__dump =
              (uu___128_937.FStar_Tactics_Types.__dump);
            FStar_Tactics_Types.psc = (uu___128_937.FStar_Tactics_Types.psc)
          }))
let add_goals: FStar_Tactics_Types.goal Prims.list -> Prims.unit tac =
  fun gs  ->
    bind get
      (fun p  ->
         set
           (let uu___129_954 = p in
            {
              FStar_Tactics_Types.main_context =
                (uu___129_954.FStar_Tactics_Types.main_context);
              FStar_Tactics_Types.main_goal =
                (uu___129_954.FStar_Tactics_Types.main_goal);
              FStar_Tactics_Types.all_implicits =
                (uu___129_954.FStar_Tactics_Types.all_implicits);
              FStar_Tactics_Types.goals =
                (FStar_List.append gs p.FStar_Tactics_Types.goals);
              FStar_Tactics_Types.smt_goals =
                (uu___129_954.FStar_Tactics_Types.smt_goals);
              FStar_Tactics_Types.depth =
                (uu___129_954.FStar_Tactics_Types.depth);
              FStar_Tactics_Types.__dump =
                (uu___129_954.FStar_Tactics_Types.__dump);
              FStar_Tactics_Types.psc =
                (uu___129_954.FStar_Tactics_Types.psc)
            }))
let add_smt_goals: FStar_Tactics_Types.goal Prims.list -> Prims.unit tac =
  fun gs  ->
    bind get
      (fun p  ->
         set
           (let uu___130_971 = p in
            {
              FStar_Tactics_Types.main_context =
                (uu___130_971.FStar_Tactics_Types.main_context);
              FStar_Tactics_Types.main_goal =
                (uu___130_971.FStar_Tactics_Types.main_goal);
              FStar_Tactics_Types.all_implicits =
                (uu___130_971.FStar_Tactics_Types.all_implicits);
              FStar_Tactics_Types.goals =
                (uu___130_971.FStar_Tactics_Types.goals);
              FStar_Tactics_Types.smt_goals =
                (FStar_List.append gs p.FStar_Tactics_Types.smt_goals);
              FStar_Tactics_Types.depth =
                (uu___130_971.FStar_Tactics_Types.depth);
              FStar_Tactics_Types.__dump =
                (uu___130_971.FStar_Tactics_Types.__dump);
              FStar_Tactics_Types.psc =
                (uu___130_971.FStar_Tactics_Types.psc)
            }))
let push_goals: FStar_Tactics_Types.goal Prims.list -> Prims.unit tac =
  fun gs  ->
    bind get
      (fun p  ->
         set
           (let uu___131_988 = p in
            {
              FStar_Tactics_Types.main_context =
                (uu___131_988.FStar_Tactics_Types.main_context);
              FStar_Tactics_Types.main_goal =
                (uu___131_988.FStar_Tactics_Types.main_goal);
              FStar_Tactics_Types.all_implicits =
                (uu___131_988.FStar_Tactics_Types.all_implicits);
              FStar_Tactics_Types.goals =
                (FStar_List.append p.FStar_Tactics_Types.goals gs);
              FStar_Tactics_Types.smt_goals =
                (uu___131_988.FStar_Tactics_Types.smt_goals);
              FStar_Tactics_Types.depth =
                (uu___131_988.FStar_Tactics_Types.depth);
              FStar_Tactics_Types.__dump =
                (uu___131_988.FStar_Tactics_Types.__dump);
              FStar_Tactics_Types.psc =
                (uu___131_988.FStar_Tactics_Types.psc)
            }))
let push_smt_goals: FStar_Tactics_Types.goal Prims.list -> Prims.unit tac =
  fun gs  ->
    bind get
      (fun p  ->
         set
           (let uu___132_1005 = p in
            {
              FStar_Tactics_Types.main_context =
                (uu___132_1005.FStar_Tactics_Types.main_context);
              FStar_Tactics_Types.main_goal =
                (uu___132_1005.FStar_Tactics_Types.main_goal);
              FStar_Tactics_Types.all_implicits =
                (uu___132_1005.FStar_Tactics_Types.all_implicits);
              FStar_Tactics_Types.goals =
                (uu___132_1005.FStar_Tactics_Types.goals);
              FStar_Tactics_Types.smt_goals =
                (FStar_List.append p.FStar_Tactics_Types.smt_goals gs);
              FStar_Tactics_Types.depth =
                (uu___132_1005.FStar_Tactics_Types.depth);
              FStar_Tactics_Types.__dump =
                (uu___132_1005.FStar_Tactics_Types.__dump);
              FStar_Tactics_Types.psc =
                (uu___132_1005.FStar_Tactics_Types.psc)
            }))
let replace_cur: FStar_Tactics_Types.goal -> Prims.unit tac =
  fun g  -> bind dismiss (fun uu____1015  -> add_goals [g])
let add_implicits: implicits -> Prims.unit tac =
  fun i  ->
    bind get
      (fun p  ->
         set
           (let uu___133_1028 = p in
            {
              FStar_Tactics_Types.main_context =
                (uu___133_1028.FStar_Tactics_Types.main_context);
              FStar_Tactics_Types.main_goal =
                (uu___133_1028.FStar_Tactics_Types.main_goal);
              FStar_Tactics_Types.all_implicits =
                (FStar_List.append i p.FStar_Tactics_Types.all_implicits);
              FStar_Tactics_Types.goals =
                (uu___133_1028.FStar_Tactics_Types.goals);
              FStar_Tactics_Types.smt_goals =
                (uu___133_1028.FStar_Tactics_Types.smt_goals);
              FStar_Tactics_Types.depth =
                (uu___133_1028.FStar_Tactics_Types.depth);
              FStar_Tactics_Types.__dump =
                (uu___133_1028.FStar_Tactics_Types.__dump);
              FStar_Tactics_Types.psc =
                (uu___133_1028.FStar_Tactics_Types.psc)
            }))
let new_uvar:
  Prims.string ->
    env -> FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.term tac
  =
  fun reason  ->
    fun env  ->
      fun typ  ->
        let uu____1057 =
          FStar_TypeChecker_Util.new_implicit_var reason
            typ.FStar_Syntax_Syntax.pos env typ in
        match uu____1057 with
        | (u,uu____1073,g_u) ->
            let uu____1087 =
              add_implicits g_u.FStar_TypeChecker_Env.implicits in
            bind uu____1087 (fun uu____1091  -> ret u)
let is_true: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____1096 = FStar_Syntax_Util.un_squash t in
    match uu____1096 with
    | FStar_Pervasives_Native.Some t' ->
        let uu____1106 =
          let uu____1107 = FStar_Syntax_Subst.compress t' in
          uu____1107.FStar_Syntax_Syntax.n in
        (match uu____1106 with
         | FStar_Syntax_Syntax.Tm_fvar fv ->
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.true_lid
         | uu____1111 -> false)
    | uu____1112 -> false
let is_false: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let uu____1121 = FStar_Syntax_Util.un_squash t in
    match uu____1121 with
    | FStar_Pervasives_Native.Some t' ->
        let uu____1131 =
          let uu____1132 = FStar_Syntax_Subst.compress t' in
          uu____1132.FStar_Syntax_Syntax.n in
        (match uu____1131 with
         | FStar_Syntax_Syntax.Tm_fvar fv ->
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.false_lid
         | uu____1136 -> false)
    | uu____1137 -> false
let cur_goal: FStar_Tactics_Types.goal tac =
  bind get
    (fun p  ->
       match p.FStar_Tactics_Types.goals with
       | [] -> fail "No more goals (1)"
       | hd1::tl1 -> ret hd1)
let mk_irrelevant_goal:
  Prims.string ->
    env ->
      FStar_Syntax_Syntax.typ ->
        FStar_Options.optionstate -> FStar_Tactics_Types.goal tac
  =
  fun reason  ->
    fun env  ->
      fun phi  ->
        fun opts  ->
          let typ = FStar_Syntax_Util.mk_squash phi in
          let uu____1175 = new_uvar reason env typ in
          bind uu____1175
            (fun u  ->
               let goal =
                 {
                   FStar_Tactics_Types.context = env;
                   FStar_Tactics_Types.witness = u;
                   FStar_Tactics_Types.goal_ty = typ;
                   FStar_Tactics_Types.opts = opts;
                   FStar_Tactics_Types.is_guard = false
                 } in
               ret goal)
let __tc:
  env ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.typ,FStar_TypeChecker_Env.guard_t)
        FStar_Pervasives_Native.tuple3 tac
  =
  fun e  ->
    fun t  ->
      bind get
        (fun ps  ->
           try
             let uu____1233 =
               (ps.FStar_Tactics_Types.main_context).FStar_TypeChecker_Env.type_of
                 e t in
             ret uu____1233
           with | e1 -> fail "not typeable")
let tc: FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.typ tac =
  fun t  ->
    let uu____1272 =
      bind cur_goal
        (fun goal  ->
           let uu____1278 = __tc goal.FStar_Tactics_Types.context t in
           bind uu____1278
             (fun uu____1298  ->
                match uu____1298 with
                | (t1,typ,guard) ->
                    let uu____1310 =
                      let uu____1311 =
                        let uu____1312 =
                          FStar_TypeChecker_Rel.discharge_guard
                            goal.FStar_Tactics_Types.context guard in
                        FStar_All.pipe_left FStar_TypeChecker_Rel.is_trivial
                          uu____1312 in
                      Prims.op_Negation uu____1311 in
                    if uu____1310
                    then fail "got non-trivial guard"
                    else ret typ)) in
    FStar_All.pipe_left (wrap_err "tc") uu____1272
let add_irrelevant_goal:
  Prims.string ->
    env ->
      FStar_Syntax_Syntax.typ -> FStar_Options.optionstate -> Prims.unit tac
  =
  fun reason  ->
    fun env  ->
      fun phi  ->
        fun opts  ->
          let uu____1340 = mk_irrelevant_goal reason env phi opts in
          bind uu____1340 (fun goal  -> add_goals [goal])
let istrivial: env -> FStar_Syntax_Syntax.term -> Prims.bool =
  fun e  ->
    fun t  ->
      let steps =
        [FStar_TypeChecker_Normalize.Reify;
        FStar_TypeChecker_Normalize.UnfoldUntil
          FStar_Syntax_Syntax.Delta_constant;
        FStar_TypeChecker_Normalize.Primops;
        FStar_TypeChecker_Normalize.Simplify;
        FStar_TypeChecker_Normalize.UnfoldTac;
        FStar_TypeChecker_Normalize.Unmeta] in
      let t1 = normalize steps e t in is_true t1
let trivial: Prims.unit tac =
  bind cur_goal
    (fun goal  ->
       let uu____1362 =
         istrivial goal.FStar_Tactics_Types.context
           goal.FStar_Tactics_Types.goal_ty in
       if uu____1362
       then solve goal FStar_Syntax_Util.exp_unit
       else
         (let uu____1366 =
            FStar_TypeChecker_Normalize.term_to_string
              goal.FStar_Tactics_Types.context
              goal.FStar_Tactics_Types.goal_ty in
          fail1 "Not a trivial goal: %s" uu____1366))
let add_goal_from_guard:
  Prims.string ->
    env ->
      FStar_TypeChecker_Env.guard_t ->
        FStar_Options.optionstate -> Prims.unit tac
  =
  fun reason  ->
    fun e  ->
      fun g  ->
        fun opts  ->
          let uu____1387 =
            let uu____1388 = FStar_TypeChecker_Rel.simplify_guard e g in
            uu____1388.FStar_TypeChecker_Env.guard_f in
          match uu____1387 with
          | FStar_TypeChecker_Common.Trivial  -> ret ()
          | FStar_TypeChecker_Common.NonTrivial f ->
              let uu____1392 = istrivial e f in
              if uu____1392
              then ret ()
              else
                (let uu____1396 = mk_irrelevant_goal reason e f opts in
                 bind uu____1396
                   (fun goal  ->
                      let goal1 =
                        let uu___136_1403 = goal in
                        {
                          FStar_Tactics_Types.context =
                            (uu___136_1403.FStar_Tactics_Types.context);
                          FStar_Tactics_Types.witness =
                            (uu___136_1403.FStar_Tactics_Types.witness);
                          FStar_Tactics_Types.goal_ty =
                            (uu___136_1403.FStar_Tactics_Types.goal_ty);
                          FStar_Tactics_Types.opts =
                            (uu___136_1403.FStar_Tactics_Types.opts);
                          FStar_Tactics_Types.is_guard = true
                        } in
                      push_goals [goal1]))
let smt: Prims.unit tac =
  bind cur_goal
    (fun g  ->
       let uu____1409 = is_irrelevant g in
       if uu____1409
       then bind dismiss (fun uu____1413  -> add_smt_goals [g])
       else
         (let uu____1415 =
            FStar_TypeChecker_Normalize.term_to_string
              g.FStar_Tactics_Types.context g.FStar_Tactics_Types.goal_ty in
          fail1 "goal is not irrelevant: cannot dispatch to smt (%s)"
            uu____1415))
let divide:
  'a 'b .
    Prims.int ->
      'a tac -> 'b tac -> ('a,'b) FStar_Pervasives_Native.tuple2 tac
  =
  fun n1  ->
    fun l  ->
      fun r  ->
        bind get
          (fun p  ->
             let uu____1461 =
               try
                 let uu____1495 =
                   FStar_List.splitAt n1 p.FStar_Tactics_Types.goals in
                 ret uu____1495
               with | uu____1525 -> fail "divide: not enough goals" in
             bind uu____1461
               (fun uu____1552  ->
                  match uu____1552 with
                  | (lgs,rgs) ->
                      let lp =
                        let uu___137_1578 = p in
                        {
                          FStar_Tactics_Types.main_context =
                            (uu___137_1578.FStar_Tactics_Types.main_context);
                          FStar_Tactics_Types.main_goal =
                            (uu___137_1578.FStar_Tactics_Types.main_goal);
                          FStar_Tactics_Types.all_implicits =
                            (uu___137_1578.FStar_Tactics_Types.all_implicits);
                          FStar_Tactics_Types.goals = lgs;
                          FStar_Tactics_Types.smt_goals = [];
                          FStar_Tactics_Types.depth =
                            (uu___137_1578.FStar_Tactics_Types.depth);
                          FStar_Tactics_Types.__dump =
                            (uu___137_1578.FStar_Tactics_Types.__dump);
                          FStar_Tactics_Types.psc =
                            (uu___137_1578.FStar_Tactics_Types.psc)
                        } in
                      let rp =
                        let uu___138_1580 = p in
                        {
                          FStar_Tactics_Types.main_context =
                            (uu___138_1580.FStar_Tactics_Types.main_context);
                          FStar_Tactics_Types.main_goal =
                            (uu___138_1580.FStar_Tactics_Types.main_goal);
                          FStar_Tactics_Types.all_implicits =
                            (uu___138_1580.FStar_Tactics_Types.all_implicits);
                          FStar_Tactics_Types.goals = rgs;
                          FStar_Tactics_Types.smt_goals = [];
                          FStar_Tactics_Types.depth =
                            (uu___138_1580.FStar_Tactics_Types.depth);
                          FStar_Tactics_Types.__dump =
                            (uu___138_1580.FStar_Tactics_Types.__dump);
                          FStar_Tactics_Types.psc =
                            (uu___138_1580.FStar_Tactics_Types.psc)
                        } in
                      let uu____1581 = set lp in
                      bind uu____1581
                        (fun uu____1589  ->
                           bind l
                             (fun a  ->
                                bind get
                                  (fun lp'  ->
                                     let uu____1603 = set rp in
                                     bind uu____1603
                                       (fun uu____1611  ->
                                          bind r
                                            (fun b  ->
                                               bind get
                                                 (fun rp'  ->
                                                    let p' =
                                                      let uu___139_1627 = p in
                                                      {
                                                        FStar_Tactics_Types.main_context
                                                          =
                                                          (uu___139_1627.FStar_Tactics_Types.main_context);
                                                        FStar_Tactics_Types.main_goal
                                                          =
                                                          (uu___139_1627.FStar_Tactics_Types.main_goal);
                                                        FStar_Tactics_Types.all_implicits
                                                          =
                                                          (uu___139_1627.FStar_Tactics_Types.all_implicits);
                                                        FStar_Tactics_Types.goals
                                                          =
                                                          (FStar_List.append
                                                             lp'.FStar_Tactics_Types.goals
                                                             rp'.FStar_Tactics_Types.goals);
                                                        FStar_Tactics_Types.smt_goals
                                                          =
                                                          (FStar_List.append
                                                             lp'.FStar_Tactics_Types.smt_goals
                                                             (FStar_List.append
                                                                rp'.FStar_Tactics_Types.smt_goals
                                                                p.FStar_Tactics_Types.smt_goals));
                                                        FStar_Tactics_Types.depth
                                                          =
                                                          (uu___139_1627.FStar_Tactics_Types.depth);
                                                        FStar_Tactics_Types.__dump
                                                          =
                                                          (uu___139_1627.FStar_Tactics_Types.__dump);
                                                        FStar_Tactics_Types.psc
                                                          =
                                                          (uu___139_1627.FStar_Tactics_Types.psc)
                                                      } in
                                                    let uu____1628 = set p' in
                                                    bind uu____1628
                                                      (fun uu____1636  ->
                                                         ret (a, b))))))))))
let focus: 'a . 'a tac -> 'a tac =
  fun f  ->
    let uu____1656 = divide (Prims.parse_int "1") f idtac in
    bind uu____1656
      (fun uu____1669  -> match uu____1669 with | (a,()) -> ret a)
let rec map: 'a . 'a tac -> 'a Prims.list tac =
  fun tau  ->
    bind get
      (fun p  ->
         match p.FStar_Tactics_Types.goals with
         | [] -> ret []
         | uu____1704::uu____1705 ->
             let uu____1708 =
               let uu____1717 = map tau in
               divide (Prims.parse_int "1") tau uu____1717 in
             bind uu____1708
               (fun uu____1735  ->
                  match uu____1735 with | (h,t) -> ret (h :: t)))
let seq: Prims.unit tac -> Prims.unit tac -> Prims.unit tac =
  fun t1  ->
    fun t2  ->
      let uu____1774 =
        bind t1
          (fun uu____1779  ->
             let uu____1780 = map t2 in
             bind uu____1780 (fun uu____1788  -> ret ())) in
      focus uu____1774
let intro: FStar_Syntax_Syntax.binder tac =
  bind cur_goal
    (fun goal  ->
       let uu____1799 =
         FStar_Syntax_Util.arrow_one goal.FStar_Tactics_Types.goal_ty in
       match uu____1799 with
       | FStar_Pervasives_Native.Some (b,c) ->
           let uu____1814 =
             let uu____1815 = FStar_Syntax_Util.is_total_comp c in
             Prims.op_Negation uu____1815 in
           if uu____1814
           then fail "Codomain is effectful"
           else
             (let env' =
                FStar_TypeChecker_Env.push_binders
                  goal.FStar_Tactics_Types.context [b] in
              let typ' = comp_to_typ c in
              let uu____1821 = new_uvar "intro" env' typ' in
              bind uu____1821
                (fun u  ->
                   let uu____1828 =
                     let uu____1829 =
                       FStar_Syntax_Util.abs [b] u
                         FStar_Pervasives_Native.None in
                     trysolve goal uu____1829 in
                   if uu____1828
                   then
                     let uu____1832 =
                       let uu____1835 =
                         let uu___142_1836 = goal in
                         let uu____1837 = bnorm env' u in
                         let uu____1838 = bnorm env' typ' in
                         {
                           FStar_Tactics_Types.context = env';
                           FStar_Tactics_Types.witness = uu____1837;
                           FStar_Tactics_Types.goal_ty = uu____1838;
                           FStar_Tactics_Types.opts =
                             (uu___142_1836.FStar_Tactics_Types.opts);
                           FStar_Tactics_Types.is_guard =
                             (uu___142_1836.FStar_Tactics_Types.is_guard)
                         } in
                       replace_cur uu____1835 in
                     bind uu____1832 (fun uu____1840  -> ret b)
                   else fail "intro: unification failed"))
       | FStar_Pervasives_Native.None  ->
           let uu____1846 =
             FStar_TypeChecker_Normalize.term_to_string
               goal.FStar_Tactics_Types.context
               goal.FStar_Tactics_Types.goal_ty in
           fail1 "intro: goal is not an arrow (%s)" uu____1846)
let intro_rec:
  (FStar_Syntax_Syntax.binder,FStar_Syntax_Syntax.binder)
    FStar_Pervasives_Native.tuple2 tac
  =
  bind cur_goal
    (fun goal  ->
       FStar_Util.print_string
         "WARNING (intro_rec): calling this is known to cause normalizer loops\n";
       FStar_Util.print_string
         "WARNING (intro_rec): proceed at your own risk...\n";
       (let uu____1867 =
          FStar_Syntax_Util.arrow_one goal.FStar_Tactics_Types.goal_ty in
        match uu____1867 with
        | FStar_Pervasives_Native.Some (b,c) ->
            let uu____1886 =
              let uu____1887 = FStar_Syntax_Util.is_total_comp c in
              Prims.op_Negation uu____1887 in
            if uu____1886
            then fail "Codomain is effectful"
            else
              (let bv =
                 FStar_Syntax_Syntax.gen_bv "__recf"
                   FStar_Pervasives_Native.None
                   goal.FStar_Tactics_Types.goal_ty in
               let bs =
                 let uu____1903 = FStar_Syntax_Syntax.mk_binder bv in
                 [uu____1903; b] in
               let env' =
                 FStar_TypeChecker_Env.push_binders
                   goal.FStar_Tactics_Types.context bs in
               let uu____1905 =
                 let uu____1908 = comp_to_typ c in
                 new_uvar "intro_rec" env' uu____1908 in
               bind uu____1905
                 (fun u  ->
                    let lb =
                      let uu____1924 =
                        FStar_Syntax_Util.abs [b] u
                          FStar_Pervasives_Native.None in
                      FStar_Syntax_Util.mk_letbinding (FStar_Util.Inl bv) []
                        goal.FStar_Tactics_Types.goal_ty
                        FStar_Parser_Const.effect_Tot_lid uu____1924 in
                    let body = FStar_Syntax_Syntax.bv_to_name bv in
                    let uu____1928 =
                      FStar_Syntax_Subst.close_let_rec [lb] body in
                    match uu____1928 with
                    | (lbs,body1) ->
                        let tm =
                          FStar_Syntax_Syntax.mk
                            (FStar_Syntax_Syntax.Tm_let ((true, lbs), body1))
                            FStar_Pervasives_Native.None
                            (goal.FStar_Tactics_Types.witness).FStar_Syntax_Syntax.pos in
                        let res = trysolve goal tm in
                        if res
                        then
                          let uu____1965 =
                            let uu____1968 =
                              let uu___143_1969 = goal in
                              let uu____1970 = bnorm env' u in
                              let uu____1971 =
                                let uu____1972 = comp_to_typ c in
                                bnorm env' uu____1972 in
                              {
                                FStar_Tactics_Types.context = env';
                                FStar_Tactics_Types.witness = uu____1970;
                                FStar_Tactics_Types.goal_ty = uu____1971;
                                FStar_Tactics_Types.opts =
                                  (uu___143_1969.FStar_Tactics_Types.opts);
                                FStar_Tactics_Types.is_guard =
                                  (uu___143_1969.FStar_Tactics_Types.is_guard)
                              } in
                            replace_cur uu____1968 in
                          bind uu____1965
                            (fun uu____1979  ->
                               let uu____1980 =
                                 let uu____1985 =
                                   FStar_Syntax_Syntax.mk_binder bv in
                                 (uu____1985, b) in
                               ret uu____1980)
                        else fail "intro_rec: unification failed"))
        | FStar_Pervasives_Native.None  ->
            let uu____1999 =
              FStar_TypeChecker_Normalize.term_to_string
                goal.FStar_Tactics_Types.context
                goal.FStar_Tactics_Types.goal_ty in
            fail1 "intro_rec: goal is not an arrow (%s)" uu____1999))
let norm: FStar_Syntax_Embeddings.norm_step Prims.list -> Prims.unit tac =
  fun s  ->
    bind cur_goal
      (fun goal  ->
         let steps =
           let uu____2024 = FStar_TypeChecker_Normalize.tr_norm_steps s in
           FStar_List.append
             [FStar_TypeChecker_Normalize.Reify;
             FStar_TypeChecker_Normalize.UnfoldTac] uu____2024 in
         let w =
           normalize steps goal.FStar_Tactics_Types.context
             goal.FStar_Tactics_Types.witness in
         let t =
           normalize steps goal.FStar_Tactics_Types.context
             goal.FStar_Tactics_Types.goal_ty in
         replace_cur
           (let uu___144_2031 = goal in
            {
              FStar_Tactics_Types.context =
                (uu___144_2031.FStar_Tactics_Types.context);
              FStar_Tactics_Types.witness = w;
              FStar_Tactics_Types.goal_ty = t;
              FStar_Tactics_Types.opts =
                (uu___144_2031.FStar_Tactics_Types.opts);
              FStar_Tactics_Types.is_guard =
                (uu___144_2031.FStar_Tactics_Types.is_guard)
            }))
let norm_term_env:
  env ->
    FStar_Syntax_Embeddings.norm_step Prims.list ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term tac
  =
  fun e  ->
    fun s  ->
      fun t  ->
        let uu____2052 =
          bind get
            (fun ps  ->
               let uu____2058 = __tc e t in
               bind uu____2058
                 (fun uu____2080  ->
                    match uu____2080 with
                    | (t1,uu____2090,guard) ->
                        (FStar_TypeChecker_Rel.force_trivial_guard e guard;
                         (let steps =
                            let uu____2096 =
                              FStar_TypeChecker_Normalize.tr_norm_steps s in
                            FStar_List.append
                              [FStar_TypeChecker_Normalize.Reify;
                              FStar_TypeChecker_Normalize.UnfoldTac]
                              uu____2096 in
                          let t2 =
                            normalize steps
                              ps.FStar_Tactics_Types.main_context t1 in
                          ret t2)))) in
        FStar_All.pipe_left (wrap_err "norm_term") uu____2052
let __exact: FStar_Syntax_Syntax.term -> Prims.unit tac =
  fun t  ->
    bind cur_goal
      (fun goal  ->
         let uu____2115 = __tc goal.FStar_Tactics_Types.context t in
         bind uu____2115
           (fun uu____2135  ->
              match uu____2135 with
              | (t1,typ,guard) ->
                  let uu____2147 =
                    let uu____2148 =
                      let uu____2149 =
                        FStar_TypeChecker_Rel.discharge_guard
                          goal.FStar_Tactics_Types.context guard in
                      FStar_All.pipe_left FStar_TypeChecker_Rel.is_trivial
                        uu____2149 in
                    Prims.op_Negation uu____2148 in
                  if uu____2147
                  then fail "got non-trivial guard"
                  else
                    (let uu____2153 =
                       do_unify goal.FStar_Tactics_Types.context typ
                         goal.FStar_Tactics_Types.goal_ty in
                     if uu____2153
                     then solve goal t1
                     else
                       (let uu____2157 =
                          FStar_TypeChecker_Normalize.term_to_string
                            goal.FStar_Tactics_Types.context t1 in
                        let uu____2158 =
                          let uu____2159 =
                            bnorm goal.FStar_Tactics_Types.context typ in
                          FStar_TypeChecker_Normalize.term_to_string
                            goal.FStar_Tactics_Types.context uu____2159 in
                        let uu____2160 =
                          FStar_TypeChecker_Normalize.term_to_string
                            goal.FStar_Tactics_Types.context
                            goal.FStar_Tactics_Types.goal_ty in
                        fail3 "%s : %s does not exactly solve the goal %s"
                          uu____2157 uu____2158 uu____2160))))
let exact: FStar_Syntax_Syntax.term -> Prims.unit tac =
  fun tm  ->
    let uu____2169 =
      mlog
        (fun uu____2174  ->
           let uu____2175 = FStar_Syntax_Print.term_to_string tm in
           FStar_Util.print1 "exact: tm = %s\n" uu____2175)
        (fun uu____2178  -> let uu____2179 = __exact tm in focus uu____2179) in
    FStar_All.pipe_left (wrap_err "exact") uu____2169
let uvar_free_in_goal:
  FStar_Syntax_Syntax.uvar -> FStar_Tactics_Types.goal -> Prims.bool =
  fun u  ->
    fun g  ->
      if g.FStar_Tactics_Types.is_guard
      then false
      else
        (let free_uvars =
           let uu____2198 =
             let uu____2205 =
               FStar_Syntax_Free.uvars g.FStar_Tactics_Types.goal_ty in
             FStar_Util.set_elements uu____2205 in
           FStar_List.map FStar_Pervasives_Native.fst uu____2198 in
         FStar_List.existsML (FStar_Syntax_Unionfind.equiv u) free_uvars)
let uvar_free:
  FStar_Syntax_Syntax.uvar -> FStar_Tactics_Types.proofstate -> Prims.bool =
  fun u  ->
    fun ps  ->
      FStar_List.existsML (uvar_free_in_goal u) ps.FStar_Tactics_Types.goals
exception NoUnif
let uu___is_NoUnif: Prims.exn -> Prims.bool =
  fun projectee  ->
    match projectee with | NoUnif  -> true | uu____2232 -> false
let rec __apply:
  Prims.bool ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.typ -> Prims.unit tac
  =
  fun uopt  ->
    fun tm  ->
      fun typ  ->
        bind cur_goal
          (fun goal  ->
             let uu____2252 =
               let uu____2257 = __exact tm in trytac uu____2257 in
             bind uu____2252
               (fun r  ->
                  match r with
                  | FStar_Pervasives_Native.Some r1 -> ret ()
                  | FStar_Pervasives_Native.None  ->
                      let uu____2270 = FStar_Syntax_Util.arrow_one typ in
                      (match uu____2270 with
                       | FStar_Pervasives_Native.None  ->
                           FStar_Exn.raise NoUnif
                       | FStar_Pervasives_Native.Some ((bv,aq),c) ->
                           mlog
                             (fun uu____2302  ->
                                let uu____2303 =
                                  FStar_Syntax_Print.binder_to_string
                                    (bv, aq) in
                                FStar_Util.print1
                                  "__apply: pushing binder %s\n" uu____2303)
                             (fun uu____2306  ->
                                let uu____2307 =
                                  let uu____2308 =
                                    FStar_Syntax_Util.is_total_comp c in
                                  Prims.op_Negation uu____2308 in
                                if uu____2307
                                then fail "apply: not total codomain"
                                else
                                  (let uu____2312 =
                                     new_uvar "apply"
                                       goal.FStar_Tactics_Types.context
                                       bv.FStar_Syntax_Syntax.sort in
                                   bind uu____2312
                                     (fun u  ->
                                        let tm' =
                                          FStar_Syntax_Syntax.mk_Tm_app tm
                                            [(u, aq)]
                                            FStar_Pervasives_Native.None
                                            (goal.FStar_Tactics_Types.context).FStar_TypeChecker_Env.range in
                                        let typ' =
                                          let uu____2332 = comp_to_typ c in
                                          FStar_All.pipe_left
                                            (FStar_Syntax_Subst.subst
                                               [FStar_Syntax_Syntax.NT
                                                  (bv, u)]) uu____2332 in
                                        let uu____2333 =
                                          __apply uopt tm' typ' in
                                        bind uu____2333
                                          (fun uu____2341  ->
                                             let u1 =
                                               bnorm
                                                 goal.FStar_Tactics_Types.context
                                                 u in
                                             let uu____2343 =
                                               let uu____2344 =
                                                 let uu____2347 =
                                                   let uu____2348 =
                                                     FStar_Syntax_Util.head_and_args
                                                       u1 in
                                                   FStar_Pervasives_Native.fst
                                                     uu____2348 in
                                                 FStar_Syntax_Subst.compress
                                                   uu____2347 in
                                               uu____2344.FStar_Syntax_Syntax.n in
                                             match uu____2343 with
                                             | FStar_Syntax_Syntax.Tm_uvar
                                                 (uvar,uu____2376) ->
                                                 bind get
                                                   (fun ps  ->
                                                      let uu____2404 =
                                                        uopt &&
                                                          (uvar_free uvar ps) in
                                                      if uu____2404
                                                      then ret ()
                                                      else
                                                        (let uu____2408 =
                                                           let uu____2411 =
                                                             let uu___145_2412
                                                               = goal in
                                                             let uu____2413 =
                                                               bnorm
                                                                 goal.FStar_Tactics_Types.context
                                                                 u1 in
                                                             let uu____2414 =
                                                               bnorm
                                                                 goal.FStar_Tactics_Types.context
                                                                 bv.FStar_Syntax_Syntax.sort in
                                                             {
                                                               FStar_Tactics_Types.context
                                                                 =
                                                                 (uu___145_2412.FStar_Tactics_Types.context);
                                                               FStar_Tactics_Types.witness
                                                                 = uu____2413;
                                                               FStar_Tactics_Types.goal_ty
                                                                 = uu____2414;
                                                               FStar_Tactics_Types.opts
                                                                 =
                                                                 (uu___145_2412.FStar_Tactics_Types.opts);
                                                               FStar_Tactics_Types.is_guard
                                                                 = false
                                                             } in
                                                           [uu____2411] in
                                                         add_goals uu____2408))
                                             | t -> ret ())))))))
let try_unif: 'a . 'a tac -> 'a tac -> 'a tac =
  fun t  ->
    fun t'  -> mk_tac (fun ps  -> try run t ps with | NoUnif  -> run t' ps)
let apply: Prims.bool -> FStar_Syntax_Syntax.term -> Prims.unit tac =
  fun uopt  ->
    fun tm  ->
      let uu____2465 =
        mlog
          (fun uu____2470  ->
             let uu____2471 = FStar_Syntax_Print.term_to_string tm in
             FStar_Util.print1 "apply: tm = %s\n" uu____2471)
          (fun uu____2473  ->
             bind cur_goal
               (fun goal  ->
                  let uu____2477 = __tc goal.FStar_Tactics_Types.context tm in
                  bind uu____2477
                    (fun uu____2498  ->
                       match uu____2498 with
                       | (tm1,typ,guard) ->
                           let uu____2510 =
                             let uu____2513 =
                               let uu____2516 = __apply uopt tm1 typ in
                               bind uu____2516
                                 (fun uu____2520  ->
                                    add_goal_from_guard "apply guard"
                                      goal.FStar_Tactics_Types.context guard
                                      goal.FStar_Tactics_Types.opts) in
                             focus uu____2513 in
                           let uu____2521 =
                             let uu____2524 =
                               FStar_TypeChecker_Normalize.term_to_string
                                 goal.FStar_Tactics_Types.context tm1 in
                             let uu____2525 =
                               FStar_TypeChecker_Normalize.term_to_string
                                 goal.FStar_Tactics_Types.context typ in
                             let uu____2526 =
                               FStar_TypeChecker_Normalize.term_to_string
                                 goal.FStar_Tactics_Types.context
                                 goal.FStar_Tactics_Types.goal_ty in
                             fail3
                               "Cannot instantiate %s (of type %s) to match goal (%s)"
                               uu____2524 uu____2525 uu____2526 in
                           try_unif uu____2510 uu____2521))) in
      FStar_All.pipe_left (wrap_err "apply") uu____2465
let apply_lemma: FStar_Syntax_Syntax.term -> Prims.unit tac =
  fun tm  ->
    let uu____2539 =
      let uu____2542 =
        mlog
          (fun uu____2547  ->
             let uu____2548 = FStar_Syntax_Print.term_to_string tm in
             FStar_Util.print1 "apply_lemma: tm = %s\n" uu____2548)
          (fun uu____2551  ->
             let is_unit_t t =
               let uu____2556 =
                 let uu____2557 = FStar_Syntax_Subst.compress t in
                 uu____2557.FStar_Syntax_Syntax.n in
               match uu____2556 with
               | FStar_Syntax_Syntax.Tm_fvar fv when
                   FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.unit_lid
                   -> true
               | uu____2561 -> false in
             bind cur_goal
               (fun goal  ->
                  let uu____2565 = __tc goal.FStar_Tactics_Types.context tm in
                  bind uu____2565
                    (fun uu____2587  ->
                       match uu____2587 with
                       | (tm1,t,guard) ->
                           let uu____2599 =
                             FStar_Syntax_Util.arrow_formals_comp t in
                           (match uu____2599 with
                            | (bs,comp) ->
                                if
                                  Prims.op_Negation
                                    (FStar_Syntax_Util.is_lemma_comp comp)
                                then fail "not a lemma"
                                else
                                  (let uu____2629 =
                                     FStar_List.fold_left
                                       (fun uu____2675  ->
                                          fun uu____2676  ->
                                            match (uu____2675, uu____2676)
                                            with
                                            | ((uvs,guard1,subst1),(b,aq)) ->
                                                let b_t =
                                                  FStar_Syntax_Subst.subst
                                                    subst1
                                                    b.FStar_Syntax_Syntax.sort in
                                                let uu____2779 =
                                                  is_unit_t b_t in
                                                if uu____2779
                                                then
                                                  (((FStar_Syntax_Util.exp_unit,
                                                      aq) :: uvs), guard1,
                                                    ((FStar_Syntax_Syntax.NT
                                                        (b,
                                                          FStar_Syntax_Util.exp_unit))
                                                    :: subst1))
                                                else
                                                  (let uu____2817 =
                                                     FStar_TypeChecker_Util.new_implicit_var
                                                       "apply_lemma"
                                                       (goal.FStar_Tactics_Types.goal_ty).FStar_Syntax_Syntax.pos
                                                       goal.FStar_Tactics_Types.context
                                                       b_t in
                                                   match uu____2817 with
                                                   | (u,uu____2847,g_u) ->
                                                       let uu____2861 =
                                                         FStar_TypeChecker_Rel.conj_guard
                                                           guard1 g_u in
                                                       (((u, aq) :: uvs),
                                                         uu____2861,
                                                         ((FStar_Syntax_Syntax.NT
                                                             (b, u)) ::
                                                         subst1))))
                                       ([], guard, []) bs in
                                   match uu____2629 with
                                   | (uvs,implicits,subst1) ->
                                       let uvs1 = FStar_List.rev uvs in
                                       let comp1 =
                                         FStar_Syntax_Subst.subst_comp subst1
                                           comp in
                                       let uu____2931 =
                                         let uu____2940 =
                                           let uu____2949 =
                                             FStar_Syntax_Util.comp_to_comp_typ
                                               comp1 in
                                           uu____2949.FStar_Syntax_Syntax.effect_args in
                                         match uu____2940 with
                                         | pre::post::uu____2960 ->
                                             ((FStar_Pervasives_Native.fst
                                                 pre),
                                               (FStar_Pervasives_Native.fst
                                                  post))
                                         | uu____3001 ->
                                             failwith
                                               "apply_lemma: impossible: not a lemma" in
                                       (match uu____2931 with
                                        | (pre,post) ->
                                            let uu____3030 =
                                              let uu____3031 =
                                                let uu____3032 =
                                                  FStar_Syntax_Util.mk_squash
                                                    post in
                                                do_unify
                                                  goal.FStar_Tactics_Types.context
                                                  uu____3032
                                                  goal.FStar_Tactics_Types.goal_ty in
                                              Prims.op_Negation uu____3031 in
                                            if uu____3030
                                            then
                                              let uu____3035 =
                                                FStar_TypeChecker_Normalize.term_to_string
                                                  goal.FStar_Tactics_Types.context
                                                  tm1 in
                                              let uu____3036 =
                                                let uu____3037 =
                                                  FStar_Syntax_Util.mk_squash
                                                    post in
                                                FStar_TypeChecker_Normalize.term_to_string
                                                  goal.FStar_Tactics_Types.context
                                                  uu____3037 in
                                              let uu____3038 =
                                                FStar_TypeChecker_Normalize.term_to_string
                                                  goal.FStar_Tactics_Types.context
                                                  goal.FStar_Tactics_Types.goal_ty in
                                              fail3
                                                "Cannot instantiate lemma %s (with postcondition: %s) to match goal (%s)"
                                                uu____3035 uu____3036
                                                uu____3038
                                            else
                                              (let solution =
                                                 let uu____3041 =
                                                   FStar_Syntax_Syntax.mk_Tm_app
                                                     tm1 uvs1
                                                     FStar_Pervasives_Native.None
                                                     (goal.FStar_Tactics_Types.context).FStar_TypeChecker_Env.range in
                                                 FStar_TypeChecker_Normalize.normalize
                                                   [FStar_TypeChecker_Normalize.Beta]
                                                   goal.FStar_Tactics_Types.context
                                                   uu____3041 in
                                               let uu____3042 =
                                                 add_implicits
                                                   implicits.FStar_TypeChecker_Env.implicits in
                                               bind uu____3042
                                                 (fun uu____3048  ->
                                                    let implicits1 =
                                                      FStar_All.pipe_right
                                                        implicits.FStar_TypeChecker_Env.implicits
                                                        (FStar_List.filter
                                                           (fun uu____3116 
                                                              ->
                                                              match uu____3116
                                                              with
                                                              | (uu____3129,uu____3130,uu____3131,tm2,uu____3133,uu____3134)
                                                                  ->
                                                                  let uu____3135
                                                                    =
                                                                    FStar_Syntax_Util.head_and_args
                                                                    tm2 in
                                                                  (match uu____3135
                                                                   with
                                                                   | 
                                                                   (hd1,uu____3151)
                                                                    ->
                                                                    let uu____3172
                                                                    =
                                                                    let uu____3173
                                                                    =
                                                                    FStar_Syntax_Subst.compress
                                                                    hd1 in
                                                                    uu____3173.FStar_Syntax_Syntax.n in
                                                                    (match uu____3172
                                                                    with
                                                                    | 
                                                                    FStar_Syntax_Syntax.Tm_uvar
                                                                    uu____3176
                                                                    -> true
                                                                    | 
                                                                    uu____3193
                                                                    -> false)))) in
                                                    let uu____3194 =
                                                      solve goal solution in
                                                    bind uu____3194
                                                      (fun uu____3205  ->
                                                         let is_free_uvar uv
                                                           t1 =
                                                           let free_uvars =
                                                             let uu____3216 =
                                                               let uu____3223
                                                                 =
                                                                 FStar_Syntax_Free.uvars
                                                                   t1 in
                                                               FStar_Util.set_elements
                                                                 uu____3223 in
                                                             FStar_List.map
                                                               FStar_Pervasives_Native.fst
                                                               uu____3216 in
                                                           FStar_List.existsML
                                                             (fun u  ->
                                                                FStar_Syntax_Unionfind.equiv
                                                                  u uv)
                                                             free_uvars in
                                                         let appears uv goals
                                                           =
                                                           FStar_List.existsML
                                                             (fun g'  ->
                                                                is_free_uvar
                                                                  uv
                                                                  g'.FStar_Tactics_Types.goal_ty)
                                                             goals in
                                                         let checkone t1
                                                           goals =
                                                           let uu____3264 =
                                                             FStar_Syntax_Util.head_and_args
                                                               t1 in
                                                           match uu____3264
                                                           with
                                                           | (hd1,uu____3280)
                                                               ->
                                                               (match 
                                                                  hd1.FStar_Syntax_Syntax.n
                                                                with
                                                                | FStar_Syntax_Syntax.Tm_uvar
                                                                    (uv,uu____3302)
                                                                    ->
                                                                    appears
                                                                    uv goals
                                                                | uu____3327
                                                                    -> false) in
                                                         let sub_goals =
                                                           FStar_All.pipe_right
                                                             implicits1
                                                             (FStar_List.map
                                                                (fun
                                                                   uu____3369
                                                                    ->
                                                                   match uu____3369
                                                                   with
                                                                   | 
                                                                   (_msg,_env,_uvar,term,typ,uu____3387)
                                                                    ->
                                                                    let uu___148_3388
                                                                    = goal in
                                                                    let uu____3389
                                                                    =
                                                                    bnorm
                                                                    goal.FStar_Tactics_Types.context
                                                                    term in
                                                                    let uu____3390
                                                                    =
                                                                    bnorm
                                                                    goal.FStar_Tactics_Types.context
                                                                    typ in
                                                                    {
                                                                    FStar_Tactics_Types.context
                                                                    =
                                                                    (uu___148_3388.FStar_Tactics_Types.context);
                                                                    FStar_Tactics_Types.witness
                                                                    =
                                                                    uu____3389;
                                                                    FStar_Tactics_Types.goal_ty
                                                                    =
                                                                    uu____3390;
                                                                    FStar_Tactics_Types.opts
                                                                    =
                                                                    (uu___148_3388.FStar_Tactics_Types.opts);
                                                                    FStar_Tactics_Types.is_guard
                                                                    =
                                                                    (uu___148_3388.FStar_Tactics_Types.is_guard)
                                                                    })) in
                                                         let rec filter' f xs
                                                           =
                                                           match xs with
                                                           | [] -> []
                                                           | x::xs1 ->
                                                               let uu____3428
                                                                 = f x xs1 in
                                                               if uu____3428
                                                               then
                                                                 let uu____3431
                                                                   =
                                                                   filter' f
                                                                    xs1 in
                                                                 x ::
                                                                   uu____3431
                                                               else
                                                                 filter' f
                                                                   xs1 in
                                                         let sub_goals1 =
                                                           filter'
                                                             (fun g  ->
                                                                fun goals  ->
                                                                  let uu____3445
                                                                    =
                                                                    checkone
                                                                    g.FStar_Tactics_Types.witness
                                                                    goals in
                                                                  Prims.op_Negation
                                                                    uu____3445)
                                                             sub_goals in
                                                         let uu____3446 =
                                                           add_goal_from_guard
                                                             "apply_lemma guard"
                                                             goal.FStar_Tactics_Types.context
                                                             guard
                                                             goal.FStar_Tactics_Types.opts in
                                                         bind uu____3446
                                                           (fun uu____3451 
                                                              ->
                                                              let uu____3452
                                                                =
                                                                let uu____3455
                                                                  =
                                                                  let uu____3456
                                                                    =
                                                                    let uu____3457
                                                                    =
                                                                    FStar_Syntax_Util.mk_squash
                                                                    pre in
                                                                    istrivial
                                                                    goal.FStar_Tactics_Types.context
                                                                    uu____3457 in
                                                                  Prims.op_Negation
                                                                    uu____3456 in
                                                                if uu____3455
                                                                then
                                                                  add_irrelevant_goal
                                                                    "apply_lemma precondition"
                                                                    goal.FStar_Tactics_Types.context
                                                                    pre
                                                                    goal.FStar_Tactics_Types.opts
                                                                else ret () in
                                                              bind uu____3452
                                                                (fun
                                                                   uu____3462
                                                                    ->
                                                                   add_goals
                                                                    sub_goals1))))))))))) in
      focus uu____2542 in
    FStar_All.pipe_left (wrap_err "apply_lemma") uu____2539
let destruct_eq':
  FStar_Syntax_Syntax.typ ->
    (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.term)
      FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option
  =
  fun typ  ->
    let uu____3483 = FStar_Syntax_Util.destruct_typ_as_formula typ in
    match uu____3483 with
    | FStar_Pervasives_Native.Some (FStar_Syntax_Util.BaseConn
        (l,uu____3493::(e1,uu____3495)::(e2,uu____3497)::[])) when
        FStar_Ident.lid_equals l FStar_Parser_Const.eq2_lid ->
        FStar_Pervasives_Native.Some (e1, e2)
    | uu____3556 -> FStar_Pervasives_Native.None
let destruct_eq:
  FStar_Syntax_Syntax.typ ->
    (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.term)
      FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option
  =
  fun typ  ->
    let uu____3579 = destruct_eq' typ in
    match uu____3579 with
    | FStar_Pervasives_Native.Some t -> FStar_Pervasives_Native.Some t
    | FStar_Pervasives_Native.None  ->
        let uu____3609 = FStar_Syntax_Util.un_squash typ in
        (match uu____3609 with
         | FStar_Pervasives_Native.Some typ1 -> destruct_eq' typ1
         | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None)
let split_env:
  FStar_Syntax_Syntax.bv ->
    env ->
      (env,FStar_Syntax_Syntax.bv Prims.list) FStar_Pervasives_Native.tuple2
        FStar_Pervasives_Native.option
  =
  fun bvar  ->
    fun e  ->
      let rec aux e1 =
        let uu____3667 = FStar_TypeChecker_Env.pop_bv e1 in
        match uu____3667 with
        | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
        | FStar_Pervasives_Native.Some (bv',e') ->
            if FStar_Syntax_Syntax.bv_eq bvar bv'
            then FStar_Pervasives_Native.Some (e', [])
            else
              (let uu____3715 = aux e' in
               FStar_Util.map_opt uu____3715
                 (fun uu____3739  ->
                    match uu____3739 with | (e'',bvs) -> (e'', (bv' :: bvs)))) in
      let uu____3760 = aux e in
      FStar_Util.map_opt uu____3760
        (fun uu____3784  ->
           match uu____3784 with | (e',bvs) -> (e', (FStar_List.rev bvs)))
let push_bvs:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.bv Prims.list -> FStar_TypeChecker_Env.env
  =
  fun e  ->
    fun bvs  ->
      FStar_List.fold_right
        (fun b  -> fun e1  -> FStar_TypeChecker_Env.push_bv e1 b) bvs e
let subst_goal:
  FStar_Syntax_Syntax.bv ->
    FStar_Syntax_Syntax.bv ->
      FStar_Syntax_Syntax.subst_elt Prims.list ->
        FStar_Tactics_Types.goal ->
          FStar_Tactics_Types.goal FStar_Pervasives_Native.option
  =
  fun b1  ->
    fun b2  ->
      fun s  ->
        fun g  ->
          let uu____3845 = split_env b1 g.FStar_Tactics_Types.context in
          FStar_Util.map_opt uu____3845
            (fun uu____3869  ->
               match uu____3869 with
               | (e0,bvs) ->
                   let s1 bv =
                     let uu___149_3886 = bv in
                     let uu____3887 =
                       FStar_Syntax_Subst.subst s bv.FStar_Syntax_Syntax.sort in
                     {
                       FStar_Syntax_Syntax.ppname =
                         (uu___149_3886.FStar_Syntax_Syntax.ppname);
                       FStar_Syntax_Syntax.index =
                         (uu___149_3886.FStar_Syntax_Syntax.index);
                       FStar_Syntax_Syntax.sort = uu____3887
                     } in
                   let bvs1 = FStar_List.map s1 bvs in
                   let c = push_bvs e0 (b2 :: bvs1) in
                   let w =
                     FStar_Syntax_Subst.subst s g.FStar_Tactics_Types.witness in
                   let t =
                     FStar_Syntax_Subst.subst s g.FStar_Tactics_Types.goal_ty in
                   let uu___150_3896 = g in
                   {
                     FStar_Tactics_Types.context = c;
                     FStar_Tactics_Types.witness = w;
                     FStar_Tactics_Types.goal_ty = t;
                     FStar_Tactics_Types.opts =
                       (uu___150_3896.FStar_Tactics_Types.opts);
                     FStar_Tactics_Types.is_guard =
                       (uu___150_3896.FStar_Tactics_Types.is_guard)
                   })
let rewrite: FStar_Syntax_Syntax.binder -> Prims.unit tac =
  fun h  ->
    bind cur_goal
      (fun goal  ->
         let uu____3910 = h in
         match uu____3910 with
         | (bv,uu____3914) ->
             mlog
               (fun uu____3918  ->
                  let uu____3919 = FStar_Syntax_Print.bv_to_string bv in
                  let uu____3920 =
                    FStar_Syntax_Print.term_to_string
                      bv.FStar_Syntax_Syntax.sort in
                  FStar_Util.print2 "+++Rewrite %s : %s\n" uu____3919
                    uu____3920)
               (fun uu____3923  ->
                  let uu____3924 =
                    split_env bv goal.FStar_Tactics_Types.context in
                  match uu____3924 with
                  | FStar_Pervasives_Native.None  ->
                      fail "rewrite: binder not found in environment"
                  | FStar_Pervasives_Native.Some (e0,bvs) ->
                      let uu____3953 =
                        destruct_eq bv.FStar_Syntax_Syntax.sort in
                      (match uu____3953 with
                       | FStar_Pervasives_Native.Some (x,e) ->
                           let uu____3968 =
                             let uu____3969 = FStar_Syntax_Subst.compress x in
                             uu____3969.FStar_Syntax_Syntax.n in
                           (match uu____3968 with
                            | FStar_Syntax_Syntax.Tm_name x1 ->
                                let s = [FStar_Syntax_Syntax.NT (x1, e)] in
                                let s1 bv1 =
                                  let uu___151_3982 = bv1 in
                                  let uu____3983 =
                                    FStar_Syntax_Subst.subst s
                                      bv1.FStar_Syntax_Syntax.sort in
                                  {
                                    FStar_Syntax_Syntax.ppname =
                                      (uu___151_3982.FStar_Syntax_Syntax.ppname);
                                    FStar_Syntax_Syntax.index =
                                      (uu___151_3982.FStar_Syntax_Syntax.index);
                                    FStar_Syntax_Syntax.sort = uu____3983
                                  } in
                                let bvs1 = FStar_List.map s1 bvs in
                                let uu____3989 =
                                  let uu___152_3990 = goal in
                                  let uu____3991 = push_bvs e0 (bv :: bvs1) in
                                  let uu____3992 =
                                    FStar_Syntax_Subst.subst s
                                      goal.FStar_Tactics_Types.witness in
                                  let uu____3993 =
                                    FStar_Syntax_Subst.subst s
                                      goal.FStar_Tactics_Types.goal_ty in
                                  {
                                    FStar_Tactics_Types.context = uu____3991;
                                    FStar_Tactics_Types.witness = uu____3992;
                                    FStar_Tactics_Types.goal_ty = uu____3993;
                                    FStar_Tactics_Types.opts =
                                      (uu___152_3990.FStar_Tactics_Types.opts);
                                    FStar_Tactics_Types.is_guard =
                                      (uu___152_3990.FStar_Tactics_Types.is_guard)
                                  } in
                                replace_cur uu____3989
                            | uu____3994 ->
                                fail
                                  "rewrite: Not an equality hypothesis with a variable on the LHS")
                       | uu____3995 ->
                           fail "rewrite: Not an equality hypothesis")))
let rename_to: FStar_Syntax_Syntax.binder -> Prims.string -> Prims.unit tac =
  fun b  ->
    fun s  ->
      bind cur_goal
        (fun goal  ->
           let uu____4022 = b in
           match uu____4022 with
           | (bv,uu____4026) ->
               let bv' =
                 FStar_Syntax_Syntax.freshen_bv
                   (let uu___153_4030 = bv in
                    {
                      FStar_Syntax_Syntax.ppname =
                        (FStar_Ident.mk_ident
                           (s,
                             ((bv.FStar_Syntax_Syntax.ppname).FStar_Ident.idRange)));
                      FStar_Syntax_Syntax.index =
                        (uu___153_4030.FStar_Syntax_Syntax.index);
                      FStar_Syntax_Syntax.sort =
                        (uu___153_4030.FStar_Syntax_Syntax.sort)
                    }) in
               let s1 =
                 let uu____4034 =
                   let uu____4035 =
                     let uu____4042 = FStar_Syntax_Syntax.bv_to_name bv' in
                     (bv, uu____4042) in
                   FStar_Syntax_Syntax.NT uu____4035 in
                 [uu____4034] in
               let uu____4043 = subst_goal bv bv' s1 goal in
               (match uu____4043 with
                | FStar_Pervasives_Native.None  ->
                    fail "rename_to: binder not found in environment"
                | FStar_Pervasives_Native.Some goal1 -> replace_cur goal1))
let binder_retype: FStar_Syntax_Syntax.binder -> Prims.unit tac =
  fun b  ->
    bind cur_goal
      (fun goal  ->
         let uu____4063 = b in
         match uu____4063 with
         | (bv,uu____4067) ->
             let uu____4068 = split_env bv goal.FStar_Tactics_Types.context in
             (match uu____4068 with
              | FStar_Pervasives_Native.None  ->
                  fail "binder_retype: binder is not present in environment"
              | FStar_Pervasives_Native.Some (e0,bvs) ->
                  let uu____4097 = FStar_Syntax_Util.type_u () in
                  (match uu____4097 with
                   | (ty,u) ->
                       let uu____4106 = new_uvar "binder_retype" e0 ty in
                       bind uu____4106
                         (fun t'  ->
                            let bv'' =
                              let uu___154_4116 = bv in
                              {
                                FStar_Syntax_Syntax.ppname =
                                  (uu___154_4116.FStar_Syntax_Syntax.ppname);
                                FStar_Syntax_Syntax.index =
                                  (uu___154_4116.FStar_Syntax_Syntax.index);
                                FStar_Syntax_Syntax.sort = t'
                              } in
                            let s =
                              let uu____4120 =
                                let uu____4121 =
                                  let uu____4128 =
                                    FStar_Syntax_Syntax.bv_to_name bv'' in
                                  (bv, uu____4128) in
                                FStar_Syntax_Syntax.NT uu____4121 in
                              [uu____4120] in
                            let bvs1 =
                              FStar_List.map
                                (fun b1  ->
                                   let uu___155_4136 = b1 in
                                   let uu____4137 =
                                     FStar_Syntax_Subst.subst s
                                       b1.FStar_Syntax_Syntax.sort in
                                   {
                                     FStar_Syntax_Syntax.ppname =
                                       (uu___155_4136.FStar_Syntax_Syntax.ppname);
                                     FStar_Syntax_Syntax.index =
                                       (uu___155_4136.FStar_Syntax_Syntax.index);
                                     FStar_Syntax_Syntax.sort = uu____4137
                                   }) bvs in
                            let env' = push_bvs e0 (bv'' :: bvs1) in
                            bind dismiss
                              (fun uu____4143  ->
                                 let uu____4144 =
                                   let uu____4147 =
                                     let uu____4150 =
                                       let uu___156_4151 = goal in
                                       let uu____4152 =
                                         FStar_Syntax_Subst.subst s
                                           goal.FStar_Tactics_Types.witness in
                                       let uu____4153 =
                                         FStar_Syntax_Subst.subst s
                                           goal.FStar_Tactics_Types.goal_ty in
                                       {
                                         FStar_Tactics_Types.context = env';
                                         FStar_Tactics_Types.witness =
                                           uu____4152;
                                         FStar_Tactics_Types.goal_ty =
                                           uu____4153;
                                         FStar_Tactics_Types.opts =
                                           (uu___156_4151.FStar_Tactics_Types.opts);
                                         FStar_Tactics_Types.is_guard =
                                           (uu___156_4151.FStar_Tactics_Types.is_guard)
                                       } in
                                     [uu____4150] in
                                   add_goals uu____4147 in
                                 bind uu____4144
                                   (fun uu____4156  ->
                                      let uu____4157 =
                                        FStar_Syntax_Util.mk_eq2
                                          (FStar_Syntax_Syntax.U_succ u) ty
                                          bv.FStar_Syntax_Syntax.sort t' in
                                      add_irrelevant_goal
                                        "binder_retype equation" e0
                                        uu____4157
                                        goal.FStar_Tactics_Types.opts))))))
let revert: Prims.unit tac =
  bind cur_goal
    (fun goal  ->
       let uu____4163 =
         FStar_TypeChecker_Env.pop_bv goal.FStar_Tactics_Types.context in
       match uu____4163 with
       | FStar_Pervasives_Native.None  -> fail "Cannot revert; empty context"
       | FStar_Pervasives_Native.Some (x,env') ->
           let typ' =
             let uu____4185 =
               FStar_Syntax_Syntax.mk_Total goal.FStar_Tactics_Types.goal_ty in
             FStar_Syntax_Util.arrow [(x, FStar_Pervasives_Native.None)]
               uu____4185 in
           let w' =
             FStar_Syntax_Util.abs [(x, FStar_Pervasives_Native.None)]
               goal.FStar_Tactics_Types.witness FStar_Pervasives_Native.None in
           replace_cur
             (let uu___157_4219 = goal in
              {
                FStar_Tactics_Types.context = env';
                FStar_Tactics_Types.witness = w';
                FStar_Tactics_Types.goal_ty = typ';
                FStar_Tactics_Types.opts =
                  (uu___157_4219.FStar_Tactics_Types.opts);
                FStar_Tactics_Types.is_guard =
                  (uu___157_4219.FStar_Tactics_Types.is_guard)
              }))
let revert_hd: name -> Prims.unit tac =
  fun x  ->
    bind cur_goal
      (fun goal  ->
         let uu____4231 =
           FStar_TypeChecker_Env.pop_bv goal.FStar_Tactics_Types.context in
         match uu____4231 with
         | FStar_Pervasives_Native.None  ->
             fail "Cannot revert_hd; empty context"
         | FStar_Pervasives_Native.Some (y,env') ->
             if Prims.op_Negation (FStar_Syntax_Syntax.bv_eq x y)
             then
               let uu____4252 = FStar_Syntax_Print.bv_to_string x in
               let uu____4253 = FStar_Syntax_Print.bv_to_string y in
               fail2
                 "Cannot revert_hd %s; head variable mismatch ... egot %s"
                 uu____4252 uu____4253
             else revert)
let clear_top: Prims.unit tac =
  bind cur_goal
    (fun goal  ->
       let uu____4260 =
         FStar_TypeChecker_Env.pop_bv goal.FStar_Tactics_Types.context in
       match uu____4260 with
       | FStar_Pervasives_Native.None  -> fail "Cannot clear; empty context"
       | FStar_Pervasives_Native.Some (x,env') ->
           let fns_ty =
             FStar_Syntax_Free.names goal.FStar_Tactics_Types.goal_ty in
           let uu____4282 = FStar_Util.set_mem x fns_ty in
           if uu____4282
           then fail "Cannot clear; variable appears in goal"
           else
             (let uu____4286 =
                new_uvar "clear_top" env' goal.FStar_Tactics_Types.goal_ty in
              bind uu____4286
                (fun u  ->
                   let uu____4292 =
                     let uu____4293 = trysolve goal u in
                     Prims.op_Negation uu____4293 in
                   if uu____4292
                   then fail "clear: unification failed"
                   else
                     (let new_goal =
                        let uu___158_4298 = goal in
                        let uu____4299 = bnorm env' u in
                        {
                          FStar_Tactics_Types.context = env';
                          FStar_Tactics_Types.witness = uu____4299;
                          FStar_Tactics_Types.goal_ty =
                            (uu___158_4298.FStar_Tactics_Types.goal_ty);
                          FStar_Tactics_Types.opts =
                            (uu___158_4298.FStar_Tactics_Types.opts);
                          FStar_Tactics_Types.is_guard =
                            (uu___158_4298.FStar_Tactics_Types.is_guard)
                        } in
                      bind dismiss (fun uu____4301  -> add_goals [new_goal])))))
let rec clear: FStar_Syntax_Syntax.binder -> Prims.unit tac =
  fun b  ->
    bind cur_goal
      (fun goal  ->
         let uu____4313 =
           FStar_TypeChecker_Env.pop_bv goal.FStar_Tactics_Types.context in
         match uu____4313 with
         | FStar_Pervasives_Native.None  ->
             fail "Cannot clear; empty context"
         | FStar_Pervasives_Native.Some (b',env') ->
             if FStar_Syntax_Syntax.bv_eq (FStar_Pervasives_Native.fst b) b'
             then clear_top
             else
               bind revert
                 (fun uu____4337  ->
                    let uu____4338 = clear b in
                    bind uu____4338
                      (fun uu____4342  ->
                         bind intro (fun uu____4344  -> ret ()))))
let prune: Prims.string -> Prims.unit tac =
  fun s  ->
    bind cur_goal
      (fun g  ->
         let ctx = g.FStar_Tactics_Types.context in
         let ctx' =
           FStar_TypeChecker_Env.rem_proof_ns ctx
             (FStar_Ident.path_of_text s) in
         let g' =
           let uu___159_4361 = g in
           {
             FStar_Tactics_Types.context = ctx';
             FStar_Tactics_Types.witness =
               (uu___159_4361.FStar_Tactics_Types.witness);
             FStar_Tactics_Types.goal_ty =
               (uu___159_4361.FStar_Tactics_Types.goal_ty);
             FStar_Tactics_Types.opts =
               (uu___159_4361.FStar_Tactics_Types.opts);
             FStar_Tactics_Types.is_guard =
               (uu___159_4361.FStar_Tactics_Types.is_guard)
           } in
         bind dismiss (fun uu____4363  -> add_goals [g']))
let addns: Prims.string -> Prims.unit tac =
  fun s  ->
    bind cur_goal
      (fun g  ->
         let ctx = g.FStar_Tactics_Types.context in
         let ctx' =
           FStar_TypeChecker_Env.add_proof_ns ctx
             (FStar_Ident.path_of_text s) in
         let g' =
           let uu___160_4380 = g in
           {
             FStar_Tactics_Types.context = ctx';
             FStar_Tactics_Types.witness =
               (uu___160_4380.FStar_Tactics_Types.witness);
             FStar_Tactics_Types.goal_ty =
               (uu___160_4380.FStar_Tactics_Types.goal_ty);
             FStar_Tactics_Types.opts =
               (uu___160_4380.FStar_Tactics_Types.opts);
             FStar_Tactics_Types.is_guard =
               (uu___160_4380.FStar_Tactics_Types.is_guard)
           } in
         bind dismiss (fun uu____4382  -> add_goals [g']))
let rec mapM: 'a 'b . ('a -> 'b tac) -> 'a Prims.list -> 'b Prims.list tac =
  fun f  ->
    fun l  ->
      match l with
      | [] -> ret []
      | x::xs ->
          let uu____4424 = f x in
          bind uu____4424
            (fun y  ->
               let uu____4432 = mapM f xs in
               bind uu____4432 (fun ys  -> ret (y :: ys)))
let rec tac_fold_env:
  FStar_Tactics_Types.direction ->
    (env -> FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term tac) ->
      env -> FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term tac
  =
  fun d  ->
    fun f  ->
      fun env  ->
        fun t  ->
          let tn =
            let uu____4482 = FStar_Syntax_Subst.compress t in
            uu____4482.FStar_Syntax_Syntax.n in
          let uu____4485 =
            if d = FStar_Tactics_Types.TopDown
            then
              f env
                (let uu___162_4491 = t in
                 {
                   FStar_Syntax_Syntax.n = tn;
                   FStar_Syntax_Syntax.pos =
                     (uu___162_4491.FStar_Syntax_Syntax.pos);
                   FStar_Syntax_Syntax.vars =
                     (uu___162_4491.FStar_Syntax_Syntax.vars)
                 })
            else ret t in
          bind uu____4485
            (fun t1  ->
               let tn1 =
                 match tn with
                 | FStar_Syntax_Syntax.Tm_app (hd1,args) ->
                     let ff = tac_fold_env d f env in
                     let uu____4528 = ff hd1 in
                     bind uu____4528
                       (fun hd2  ->
                          let fa uu____4548 =
                            match uu____4548 with
                            | (a,q) ->
                                let uu____4561 = ff a in
                                bind uu____4561 (fun a1  -> ret (a1, q)) in
                          let uu____4574 = mapM fa args in
                          bind uu____4574
                            (fun args1  ->
                               ret (FStar_Syntax_Syntax.Tm_app (hd2, args1))))
                 | FStar_Syntax_Syntax.Tm_abs (bs,t2,k) ->
                     let uu____4634 = FStar_Syntax_Subst.open_term bs t2 in
                     (match uu____4634 with
                      | (bs1,t') ->
                          let uu____4643 =
                            let uu____4646 =
                              FStar_TypeChecker_Env.push_binders env bs1 in
                            tac_fold_env d f uu____4646 t' in
                          bind uu____4643
                            (fun t''  ->
                               let uu____4650 =
                                 let uu____4651 =
                                   let uu____4668 =
                                     FStar_Syntax_Subst.close_binders bs1 in
                                   let uu____4669 =
                                     FStar_Syntax_Subst.close bs1 t'' in
                                   (uu____4668, uu____4669, k) in
                                 FStar_Syntax_Syntax.Tm_abs uu____4651 in
                               ret uu____4650))
                 | FStar_Syntax_Syntax.Tm_arrow (bs,k) -> ret tn
                 | uu____4690 -> ret tn in
               bind tn1
                 (fun tn2  ->
                    let t' =
                      let uu___161_4697 = t1 in
                      {
                        FStar_Syntax_Syntax.n = tn2;
                        FStar_Syntax_Syntax.pos =
                          (uu___161_4697.FStar_Syntax_Syntax.pos);
                        FStar_Syntax_Syntax.vars =
                          (uu___161_4697.FStar_Syntax_Syntax.vars)
                      } in
                    if d = FStar_Tactics_Types.BottomUp
                    then f env t'
                    else ret t'))
let pointwise_rec:
  FStar_Tactics_Types.proofstate ->
    Prims.unit tac ->
      FStar_Options.optionstate ->
        FStar_TypeChecker_Env.env ->
          FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term tac
  =
  fun ps  ->
    fun tau  ->
      fun opts  ->
        fun env  ->
          fun t  ->
            let uu____4731 = FStar_TypeChecker_TcTerm.tc_term env t in
            match uu____4731 with
            | (t1,lcomp,g) ->
                let uu____4743 =
                  (let uu____4746 =
                     FStar_Syntax_Util.is_pure_or_ghost_lcomp lcomp in
                   Prims.op_Negation uu____4746) ||
                    (let uu____4748 = FStar_TypeChecker_Rel.is_trivial g in
                     Prims.op_Negation uu____4748) in
                if uu____4743
                then ret t1
                else
                  (let typ = lcomp.FStar_Syntax_Syntax.res_typ in
                   let uu____4755 = new_uvar "pointwise_rec" env typ in
                   bind uu____4755
                     (fun ut  ->
                        log ps
                          (fun uu____4766  ->
                             let uu____4767 =
                               FStar_Syntax_Print.term_to_string t1 in
                             let uu____4768 =
                               FStar_Syntax_Print.term_to_string ut in
                             FStar_Util.print2
                               "Pointwise_rec: making equality %s = %s\n"
                               uu____4767 uu____4768);
                        (let uu____4769 =
                           let uu____4772 =
                             let uu____4773 =
                               FStar_TypeChecker_TcTerm.universe_of env typ in
                             FStar_Syntax_Util.mk_eq2 uu____4773 typ t1 ut in
                           add_irrelevant_goal "pointwise_rec equation" env
                             uu____4772 opts in
                         bind uu____4769
                           (fun uu____4776  ->
                              let uu____4777 =
                                bind tau
                                  (fun uu____4782  ->
                                     let ut1 =
                                       FStar_TypeChecker_Normalize.reduce_uvar_solutions
                                         env ut in
                                     ret ut1) in
                              focus uu____4777))))
let pointwise:
  FStar_Tactics_Types.direction -> Prims.unit tac -> Prims.unit tac =
  fun d  ->
    fun tau  ->
      bind get
        (fun ps  ->
           let uu____4807 =
             match ps.FStar_Tactics_Types.goals with
             | g::gs -> (g, gs)
             | [] -> failwith "Pointwise: no goals" in
           match uu____4807 with
           | (g,gs) ->
               let gt1 = g.FStar_Tactics_Types.goal_ty in
               (log ps
                  (fun uu____4844  ->
                     let uu____4845 = FStar_Syntax_Print.term_to_string gt1 in
                     FStar_Util.print1 "Pointwise starting with %s\n"
                       uu____4845);
                bind dismiss_all
                  (fun uu____4848  ->
                     let uu____4849 =
                       tac_fold_env d
                         (pointwise_rec ps tau g.FStar_Tactics_Types.opts)
                         g.FStar_Tactics_Types.context gt1 in
                     bind uu____4849
                       (fun gt'  ->
                          log ps
                            (fun uu____4859  ->
                               let uu____4860 =
                                 FStar_Syntax_Print.term_to_string gt' in
                               FStar_Util.print1
                                 "Pointwise seems to have succeded with %s\n"
                                 uu____4860);
                          (let uu____4861 = push_goals gs in
                           bind uu____4861
                             (fun uu____4865  ->
                                add_goals
                                  [(let uu___163_4867 = g in
                                    {
                                      FStar_Tactics_Types.context =
                                        (uu___163_4867.FStar_Tactics_Types.context);
                                      FStar_Tactics_Types.witness =
                                        (uu___163_4867.FStar_Tactics_Types.witness);
                                      FStar_Tactics_Types.goal_ty = gt';
                                      FStar_Tactics_Types.opts =
                                        (uu___163_4867.FStar_Tactics_Types.opts);
                                      FStar_Tactics_Types.is_guard =
                                        (uu___163_4867.FStar_Tactics_Types.is_guard)
                                    })]))))))
let trefl: Prims.unit tac =
  bind cur_goal
    (fun g  ->
       let uu____4887 =
         FStar_Syntax_Util.un_squash g.FStar_Tactics_Types.goal_ty in
       match uu____4887 with
       | FStar_Pervasives_Native.Some t ->
           let uu____4899 = FStar_Syntax_Util.head_and_args' t in
           (match uu____4899 with
            | (hd1,args) ->
                let uu____4932 =
                  let uu____4945 =
                    let uu____4946 = FStar_Syntax_Util.un_uinst hd1 in
                    uu____4946.FStar_Syntax_Syntax.n in
                  (uu____4945, args) in
                (match uu____4932 with
                 | (FStar_Syntax_Syntax.Tm_fvar
                    fv,uu____4960::(l,uu____4962)::(r,uu____4964)::[]) when
                     FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Parser_Const.eq2_lid
                     ->
                     let uu____5011 =
                       let uu____5012 =
                         do_unify g.FStar_Tactics_Types.context l r in
                       Prims.op_Negation uu____5012 in
                     if uu____5011
                     then
                       let uu____5015 =
                         FStar_TypeChecker_Normalize.term_to_string
                           g.FStar_Tactics_Types.context l in
                       let uu____5016 =
                         FStar_TypeChecker_Normalize.term_to_string
                           g.FStar_Tactics_Types.context r in
                       fail2 "trefl: not a trivial equality (%s vs %s)"
                         uu____5015 uu____5016
                     else solve g FStar_Syntax_Util.exp_unit
                 | (hd2,uu____5019) ->
                     let uu____5036 =
                       FStar_TypeChecker_Normalize.term_to_string
                         g.FStar_Tactics_Types.context t in
                     fail1 "trefl: not an equality (%s)" uu____5036))
       | FStar_Pervasives_Native.None  -> fail "not an irrelevant goal")
let dup: Prims.unit tac =
  bind cur_goal
    (fun g  ->
       let uu____5044 =
         new_uvar "dup" g.FStar_Tactics_Types.context
           g.FStar_Tactics_Types.goal_ty in
       bind uu____5044
         (fun u  ->
            let g' =
              let uu___164_5051 = g in
              {
                FStar_Tactics_Types.context =
                  (uu___164_5051.FStar_Tactics_Types.context);
                FStar_Tactics_Types.witness = u;
                FStar_Tactics_Types.goal_ty =
                  (uu___164_5051.FStar_Tactics_Types.goal_ty);
                FStar_Tactics_Types.opts =
                  (uu___164_5051.FStar_Tactics_Types.opts);
                FStar_Tactics_Types.is_guard =
                  (uu___164_5051.FStar_Tactics_Types.is_guard)
              } in
            bind dismiss
              (fun uu____5054  ->
                 let uu____5055 =
                   let uu____5058 =
                     let uu____5059 =
                       FStar_TypeChecker_TcTerm.universe_of
                         g.FStar_Tactics_Types.context
                         g.FStar_Tactics_Types.goal_ty in
                     FStar_Syntax_Util.mk_eq2 uu____5059
                       g.FStar_Tactics_Types.goal_ty u
                       g.FStar_Tactics_Types.witness in
                   add_irrelevant_goal "dup equation"
                     g.FStar_Tactics_Types.context uu____5058
                     g.FStar_Tactics_Types.opts in
                 bind uu____5055
                   (fun uu____5062  ->
                      let uu____5063 = add_goals [g'] in
                      bind uu____5063 (fun uu____5067  -> ret ())))))
let flip: Prims.unit tac =
  bind get
    (fun ps  ->
       match ps.FStar_Tactics_Types.goals with
       | g1::g2::gs ->
           set
             (let uu___165_5084 = ps in
              {
                FStar_Tactics_Types.main_context =
                  (uu___165_5084.FStar_Tactics_Types.main_context);
                FStar_Tactics_Types.main_goal =
                  (uu___165_5084.FStar_Tactics_Types.main_goal);
                FStar_Tactics_Types.all_implicits =
                  (uu___165_5084.FStar_Tactics_Types.all_implicits);
                FStar_Tactics_Types.goals = (g2 :: g1 :: gs);
                FStar_Tactics_Types.smt_goals =
                  (uu___165_5084.FStar_Tactics_Types.smt_goals);
                FStar_Tactics_Types.depth =
                  (uu___165_5084.FStar_Tactics_Types.depth);
                FStar_Tactics_Types.__dump =
                  (uu___165_5084.FStar_Tactics_Types.__dump);
                FStar_Tactics_Types.psc =
                  (uu___165_5084.FStar_Tactics_Types.psc)
              })
       | uu____5085 -> fail "flip: less than 2 goals")
let later: Prims.unit tac =
  bind get
    (fun ps  ->
       match ps.FStar_Tactics_Types.goals with
       | [] -> ret ()
       | g::gs ->
           set
             (let uu___166_5100 = ps in
              {
                FStar_Tactics_Types.main_context =
                  (uu___166_5100.FStar_Tactics_Types.main_context);
                FStar_Tactics_Types.main_goal =
                  (uu___166_5100.FStar_Tactics_Types.main_goal);
                FStar_Tactics_Types.all_implicits =
                  (uu___166_5100.FStar_Tactics_Types.all_implicits);
                FStar_Tactics_Types.goals = (FStar_List.append gs [g]);
                FStar_Tactics_Types.smt_goals =
                  (uu___166_5100.FStar_Tactics_Types.smt_goals);
                FStar_Tactics_Types.depth =
                  (uu___166_5100.FStar_Tactics_Types.depth);
                FStar_Tactics_Types.__dump =
                  (uu___166_5100.FStar_Tactics_Types.__dump);
                FStar_Tactics_Types.psc =
                  (uu___166_5100.FStar_Tactics_Types.psc)
              }))
let qed: Prims.unit tac =
  bind get
    (fun ps  ->
       match ps.FStar_Tactics_Types.goals with
       | [] -> ret ()
       | uu____5107 -> fail "Not done!")
let cases:
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.term)
      FStar_Pervasives_Native.tuple2 tac
  =
  fun t  ->
    let uu____5126 =
      bind cur_goal
        (fun g  ->
           let uu____5140 = __tc g.FStar_Tactics_Types.context t in
           bind uu____5140
             (fun uu____5176  ->
                match uu____5176 with
                | (t1,typ,guard) ->
                    let uu____5192 = FStar_Syntax_Util.head_and_args typ in
                    (match uu____5192 with
                     | (hd1,args) ->
                         let uu____5235 =
                           let uu____5248 =
                             let uu____5249 = FStar_Syntax_Util.un_uinst hd1 in
                             uu____5249.FStar_Syntax_Syntax.n in
                           (uu____5248, args) in
                         (match uu____5235 with
                          | (FStar_Syntax_Syntax.Tm_fvar
                             fv,(p,uu____5268)::(q,uu____5270)::[]) when
                              FStar_Syntax_Syntax.fv_eq_lid fv
                                FStar_Parser_Const.or_lid
                              ->
                              let v_p =
                                FStar_Syntax_Syntax.new_bv
                                  FStar_Pervasives_Native.None p in
                              let v_q =
                                FStar_Syntax_Syntax.new_bv
                                  FStar_Pervasives_Native.None q in
                              let g1 =
                                let uu___167_5308 = g in
                                let uu____5309 =
                                  FStar_TypeChecker_Env.push_bv
                                    g.FStar_Tactics_Types.context v_p in
                                {
                                  FStar_Tactics_Types.context = uu____5309;
                                  FStar_Tactics_Types.witness =
                                    (uu___167_5308.FStar_Tactics_Types.witness);
                                  FStar_Tactics_Types.goal_ty =
                                    (uu___167_5308.FStar_Tactics_Types.goal_ty);
                                  FStar_Tactics_Types.opts =
                                    (uu___167_5308.FStar_Tactics_Types.opts);
                                  FStar_Tactics_Types.is_guard =
                                    (uu___167_5308.FStar_Tactics_Types.is_guard)
                                } in
                              let g2 =
                                let uu___168_5311 = g in
                                let uu____5312 =
                                  FStar_TypeChecker_Env.push_bv
                                    g.FStar_Tactics_Types.context v_q in
                                {
                                  FStar_Tactics_Types.context = uu____5312;
                                  FStar_Tactics_Types.witness =
                                    (uu___168_5311.FStar_Tactics_Types.witness);
                                  FStar_Tactics_Types.goal_ty =
                                    (uu___168_5311.FStar_Tactics_Types.goal_ty);
                                  FStar_Tactics_Types.opts =
                                    (uu___168_5311.FStar_Tactics_Types.opts);
                                  FStar_Tactics_Types.is_guard =
                                    (uu___168_5311.FStar_Tactics_Types.is_guard)
                                } in
                              bind dismiss
                                (fun uu____5319  ->
                                   let uu____5320 = add_goals [g1; g2] in
                                   bind uu____5320
                                     (fun uu____5329  ->
                                        let uu____5330 =
                                          let uu____5335 =
                                            FStar_Syntax_Syntax.bv_to_name
                                              v_p in
                                          let uu____5336 =
                                            FStar_Syntax_Syntax.bv_to_name
                                              v_q in
                                          (uu____5335, uu____5336) in
                                        ret uu____5330))
                          | uu____5341 ->
                              let uu____5354 =
                                FStar_TypeChecker_Normalize.term_to_string
                                  g.FStar_Tactics_Types.context typ in
                              fail1 "Not a disjunction: %s" uu____5354)))) in
    FStar_All.pipe_left (wrap_err "cases") uu____5126
let set_options: Prims.string -> Prims.unit tac =
  fun s  ->
    bind cur_goal
      (fun g  ->
         FStar_Options.push ();
         (let uu____5393 = FStar_Util.smap_copy g.FStar_Tactics_Types.opts in
          FStar_Options.set uu____5393);
         (let res = FStar_Options.set_options FStar_Options.Set s in
          let opts' = FStar_Options.peek () in
          FStar_Options.pop ();
          (match res with
           | FStar_Getopt.Success  ->
               let g' =
                 let uu___169_5400 = g in
                 {
                   FStar_Tactics_Types.context =
                     (uu___169_5400.FStar_Tactics_Types.context);
                   FStar_Tactics_Types.witness =
                     (uu___169_5400.FStar_Tactics_Types.witness);
                   FStar_Tactics_Types.goal_ty =
                     (uu___169_5400.FStar_Tactics_Types.goal_ty);
                   FStar_Tactics_Types.opts = opts';
                   FStar_Tactics_Types.is_guard =
                     (uu___169_5400.FStar_Tactics_Types.is_guard)
                 } in
               replace_cur g'
           | FStar_Getopt.Error err1 ->
               fail2 "Setting options `%s` failed: %s" s err1
           | FStar_Getopt.Help  ->
               fail1 "Setting options `%s` failed (got `Help`?)" s)))
let top_env: FStar_TypeChecker_Env.env tac =
  bind get
    (fun ps  -> FStar_All.pipe_left ret ps.FStar_Tactics_Types.main_context)
let cur_env: FStar_TypeChecker_Env.env tac =
  bind cur_goal
    (fun g  -> FStar_All.pipe_left ret g.FStar_Tactics_Types.context)
let cur_goal': FStar_Syntax_Syntax.typ tac =
  bind cur_goal
    (fun g  -> FStar_All.pipe_left ret g.FStar_Tactics_Types.goal_ty)
let cur_witness: FStar_Syntax_Syntax.term tac =
  bind cur_goal
    (fun g  -> FStar_All.pipe_left ret g.FStar_Tactics_Types.witness)
let unquote:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term tac
  =
  fun ty  ->
    fun tm  ->
      let uu____5438 =
        bind cur_goal
          (fun goal  ->
             let env =
               FStar_TypeChecker_Env.set_expected_typ
                 goal.FStar_Tactics_Types.context ty in
             let uu____5446 = __tc env tm in
             bind uu____5446
               (fun uu____5466  ->
                  match uu____5466 with
                  | (tm1,typ,guard) ->
                      (FStar_TypeChecker_Rel.force_trivial_guard env guard;
                       ret tm1))) in
      FStar_All.pipe_left (wrap_err "unquote") uu____5438
let uvar_env:
  env ->
    FStar_Syntax_Syntax.typ FStar_Pervasives_Native.option ->
      FStar_Syntax_Syntax.term tac
  =
  fun env  ->
    fun ty  ->
      let uu____5499 =
        match ty with
        | FStar_Pervasives_Native.Some ty1 -> ret ty1
        | FStar_Pervasives_Native.None  ->
            let uu____5505 =
              let uu____5506 = FStar_Syntax_Util.type_u () in
              FStar_All.pipe_left FStar_Pervasives_Native.fst uu____5506 in
            new_uvar "uvar_env.2" env uu____5505 in
      bind uu____5499
        (fun typ  ->
           let uu____5518 = new_uvar "uvar_env" env typ in
           bind uu____5518 (fun t  -> ret t))
let unshelve: FStar_Syntax_Syntax.term -> Prims.unit tac =
  fun t  ->
    let uu____5531 =
      bind cur_goal
        (fun goal  ->
           let uu____5537 = __tc goal.FStar_Tactics_Types.context t in
           bind uu____5537
             (fun uu____5557  ->
                match uu____5557 with
                | (t1,typ,guard) ->
                    let uu____5569 =
                      let uu____5570 =
                        let uu____5571 =
                          FStar_TypeChecker_Rel.discharge_guard
                            goal.FStar_Tactics_Types.context guard in
                        FStar_All.pipe_left FStar_TypeChecker_Rel.is_trivial
                          uu____5571 in
                      Prims.op_Negation uu____5570 in
                    if uu____5569
                    then fail "got non-trivial guard"
                    else
                      (let uu____5575 =
                         let uu____5578 =
                           let uu___170_5579 = goal in
                           let uu____5580 =
                             bnorm goal.FStar_Tactics_Types.context t1 in
                           let uu____5581 =
                             bnorm goal.FStar_Tactics_Types.context typ in
                           {
                             FStar_Tactics_Types.context =
                               (uu___170_5579.FStar_Tactics_Types.context);
                             FStar_Tactics_Types.witness = uu____5580;
                             FStar_Tactics_Types.goal_ty = uu____5581;
                             FStar_Tactics_Types.opts =
                               (uu___170_5579.FStar_Tactics_Types.opts);
                             FStar_Tactics_Types.is_guard = false
                           } in
                         [uu____5578] in
                       add_goals uu____5575))) in
    FStar_All.pipe_left (wrap_err "unshelve") uu____5531
let unify:
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> Prims.bool tac =
  fun t1  ->
    fun t2  ->
      bind get
        (fun ps  ->
           let uu____5601 =
             do_unify ps.FStar_Tactics_Types.main_context t1 t2 in
           ret uu____5601)
let launch_process:
  Prims.string -> Prims.string -> Prims.string -> Prims.string tac =
  fun prog  ->
    fun args  ->
      fun input  ->
        bind idtac
          (fun uu____5621  ->
             let uu____5622 = FStar_Options.unsafe_tactic_exec () in
             if uu____5622
             then
               let s =
                 FStar_Util.launch_process true "tactic_launch" prog args
                   input (fun uu____5628  -> fun uu____5629  -> false) in
               ret s
             else
               fail
                 "launch_process: will not run anything unless --unsafe_tactic_exec is provided")
let goal_of_goal_ty:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      (FStar_Tactics_Types.goal,FStar_TypeChecker_Env.guard_t)
        FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun typ  ->
      let uu____5651 =
        FStar_TypeChecker_Util.new_implicit_var "proofstate_of_goal_ty"
          typ.FStar_Syntax_Syntax.pos env typ in
      match uu____5651 with
      | (u,uu____5669,g_u) ->
          let g =
            let uu____5684 = FStar_Options.peek () in
            {
              FStar_Tactics_Types.context = env;
              FStar_Tactics_Types.witness = u;
              FStar_Tactics_Types.goal_ty = typ;
              FStar_Tactics_Types.opts = uu____5684;
              FStar_Tactics_Types.is_guard = false
            } in
          (g, g_u)
let proofstate_of_goal_ty:
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      (FStar_Tactics_Types.proofstate,FStar_Syntax_Syntax.term)
        FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun typ  ->
      let uu____5701 = goal_of_goal_ty env typ in
      match uu____5701 with
      | (g,g_u) ->
          let ps =
            {
              FStar_Tactics_Types.main_context = env;
              FStar_Tactics_Types.main_goal = g;
              FStar_Tactics_Types.all_implicits =
                (g_u.FStar_TypeChecker_Env.implicits);
              FStar_Tactics_Types.goals = [g];
              FStar_Tactics_Types.smt_goals = [];
              FStar_Tactics_Types.depth = (Prims.parse_int "0");
              FStar_Tactics_Types.__dump =
                (fun ps  -> fun msg  -> dump_proofstate ps msg);
              FStar_Tactics_Types.psc = FStar_TypeChecker_Normalize.null_psc
            } in
          (ps, (g.FStar_Tactics_Types.witness))