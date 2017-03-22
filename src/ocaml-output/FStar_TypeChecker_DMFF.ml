open Prims
type env =
  {
  env: FStar_TypeChecker_Env.env ;
  subst: FStar_Syntax_Syntax.subst_elt Prims.list ;
  tc_const: FStar_Const.sconst -> FStar_Syntax_Syntax.typ }
let empty :
  FStar_TypeChecker_Env.env ->
    (FStar_Const.sconst -> FStar_Syntax_Syntax.typ) -> env
  = fun env  -> fun tc_const  -> { env; subst = []; tc_const } 
let gen_wps_for_free :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.binders ->
      FStar_Syntax_Syntax.bv ->
        FStar_Syntax_Syntax.term ->
          FStar_Syntax_Syntax.eff_decl ->
            (FStar_Syntax_Syntax.sigelts * FStar_Syntax_Syntax.eff_decl)
  =
  fun env  ->
    fun binders  ->
      fun a  ->
        fun wp_a  ->
          fun ed  ->
            let wp_a =
              FStar_TypeChecker_Normalize.normalize
                [FStar_TypeChecker_Normalize.Beta;
                FStar_TypeChecker_Normalize.EraseUniverses] env wp_a
               in
            let a =
              let uu___96_64 = a  in
              let _0_191 =
                FStar_TypeChecker_Normalize.normalize
                  [FStar_TypeChecker_Normalize.EraseUniverses] env
                  a.FStar_Syntax_Syntax.sort
                 in
              {
                FStar_Syntax_Syntax.ppname =
                  (uu___96_64.FStar_Syntax_Syntax.ppname);
                FStar_Syntax_Syntax.index =
                  (uu___96_64.FStar_Syntax_Syntax.index);
                FStar_Syntax_Syntax.sort = _0_191
              }  in
            let d s = FStar_Util.print1 "\\x1b[01;36m%s\\x1b[00m\n" s  in
            (let uu____70 =
               FStar_TypeChecker_Env.debug env (FStar_Options.Other "ED")  in
             if uu____70
             then
               (d "Elaborating extra WP combinators";
                (let _0_192 = FStar_Syntax_Print.term_to_string wp_a  in
                 FStar_Util.print1 "wp_a is: %s\n" _0_192))
             else ());
            (let rec collect_binders t =
               let uu____80 =
                 (let _0_193 = FStar_Syntax_Subst.compress t  in
                  FStar_All.pipe_left FStar_Syntax_Util.unascribe _0_193).FStar_Syntax_Syntax.n
                  in
               match uu____80 with
               | FStar_Syntax_Syntax.Tm_arrow (bs,comp) ->
                   let rest =
                     match comp.FStar_Syntax_Syntax.n with
                     | FStar_Syntax_Syntax.Total (t,uu____102) -> t
                     | uu____109 -> failwith "wp_a contains non-Tot arrow"
                      in
                   let _0_194 = collect_binders rest  in
                   FStar_List.append bs _0_194
               | FStar_Syntax_Syntax.Tm_type uu____114 -> []
               | uu____117 -> failwith "wp_a doesn't end in Type0"  in
             let mk_lid name =
               FStar_Ident.lid_of_path
                 (FStar_Ident.path_of_text
                    (Prims.strcat
                       (FStar_Ident.text_of_lid ed.FStar_Syntax_Syntax.mname)
                       (Prims.strcat "_" name))) FStar_Range.dummyRange
                in
             let gamma =
               let _0_195 = collect_binders wp_a  in
               FStar_All.pipe_right _0_195 FStar_Syntax_Util.name_binders  in
             (let uu____136 =
                FStar_TypeChecker_Env.debug env (FStar_Options.Other "ED")
                 in
              if uu____136
              then
                d
                  (let _0_196 =
                     FStar_Syntax_Print.binders_to_string ", " gamma  in
                   FStar_Util.format1 "Gamma is %s\n" _0_196)
              else ());
             (let unknown = FStar_Syntax_Syntax.tun  in
              let mk x =
                (FStar_Syntax_Syntax.mk x) None FStar_Range.dummyRange  in
              let sigelts = FStar_Util.mk_ref []  in
              let register env lident def =
                let uu____168 =
                  FStar_TypeChecker_Util.mk_toplevel_definition env lident
                    def
                   in
                match uu____168 with
                | (sigelt,fv) ->
                    ((let _0_198 =
                        let _0_197 = FStar_ST.read sigelts  in sigelt ::
                          _0_197
                         in
                      FStar_ST.write sigelts _0_198);
                     fv)
                 in
              let binders_of_list =
                FStar_List.map
                  (fun uu____193  ->
                     match uu____193 with
                     | (t,b) ->
                         let _0_199 = FStar_Syntax_Syntax.as_implicit b  in
                         (t, _0_199))
                 in
              let mk_all_implicit =
                FStar_List.map
                  (fun t  ->
                     let _0_200 = FStar_Syntax_Syntax.as_implicit true  in
                     ((Prims.fst t), _0_200))
                 in
              let args_of_binders =
                FStar_List.map
                  (fun bv  ->
                     FStar_Syntax_Syntax.as_arg
                       (FStar_Syntax_Syntax.bv_to_name (Prims.fst bv)))
                 in
              let uu____228 =
                let uu____240 =
                  let mk f =
                    let t =
                      FStar_Syntax_Syntax.gen_bv "t" None
                        FStar_Syntax_Util.ktype
                       in
                    let body =
                      let _0_201 = f (FStar_Syntax_Syntax.bv_to_name t)  in
                      FStar_Syntax_Util.arrow gamma _0_201  in
                    let _0_206 =
                      let _0_205 =
                        let _0_204 = FStar_Syntax_Syntax.mk_binder a  in
                        let _0_203 =
                          let _0_202 = FStar_Syntax_Syntax.mk_binder t  in
                          [_0_202]  in
                        _0_204 :: _0_203  in
                      FStar_List.append binders _0_205  in
                    FStar_Syntax_Util.abs _0_206 body None  in
                  let _0_208 = mk FStar_Syntax_Syntax.mk_Total  in
                  let _0_207 = mk FStar_Syntax_Syntax.mk_GTotal  in
                  (_0_208, _0_207)  in
                match uu____240 with
                | (ctx_def,gctx_def) ->
                    let ctx_lid = mk_lid "ctx"  in
                    let ctx_fv = register env ctx_lid ctx_def  in
                    let gctx_lid = mk_lid "gctx"  in
                    let gctx_fv = register env gctx_lid gctx_def  in
                    let mk_app fv t =
                      mk
                        (FStar_Syntax_Syntax.Tm_app
                           (let _0_219 =
                              let _0_218 =
                                FStar_List.map
                                  (fun uu____308  ->
                                     match uu____308 with
                                     | (bv,uu____314) ->
                                         let _0_210 =
                                           FStar_Syntax_Syntax.bv_to_name bv
                                            in
                                         let _0_209 =
                                           FStar_Syntax_Syntax.as_implicit
                                             false
                                            in
                                         (_0_210, _0_209)) binders
                                 in
                              let _0_217 =
                                let _0_216 =
                                  let _0_212 =
                                    FStar_Syntax_Syntax.bv_to_name a  in
                                  let _0_211 =
                                    FStar_Syntax_Syntax.as_implicit false  in
                                  (_0_212, _0_211)  in
                                let _0_215 =
                                  let _0_214 =
                                    let _0_213 =
                                      FStar_Syntax_Syntax.as_implicit false
                                       in
                                    (t, _0_213)  in
                                  [_0_214]  in
                                _0_216 :: _0_215  in
                              FStar_List.append _0_218 _0_217  in
                            (fv, _0_219)))
                       in
                    (env, (mk_app ctx_fv), (mk_app gctx_fv))
                 in
              match uu____228 with
              | (env,mk_ctx,mk_gctx) ->
                  let c_pure =
                    let t =
                      FStar_Syntax_Syntax.gen_bv "t" None
                        FStar_Syntax_Util.ktype
                       in
                    let x =
                      let _0_220 = FStar_Syntax_Syntax.bv_to_name t  in
                      FStar_Syntax_Syntax.gen_bv "x" None _0_220  in
                    let ret =
                      Some
                        (FStar_Util.Inl
                           (FStar_Syntax_Util.lcomp_of_comp
                              (FStar_Syntax_Syntax.mk_Total
                                 (mk_ctx (FStar_Syntax_Syntax.bv_to_name t)))))
                       in
                    let body =
                      let _0_221 = FStar_Syntax_Syntax.bv_to_name x  in
                      FStar_Syntax_Util.abs gamma _0_221 ret  in
                    let _0_224 =
                      let _0_223 = mk_all_implicit binders  in
                      let _0_222 =
                        binders_of_list [(a, true); (t, true); (x, false)]
                         in
                      FStar_List.append _0_223 _0_222  in
                    FStar_Syntax_Util.abs _0_224 body ret  in
                  let c_pure =
                    let _0_225 = mk_lid "pure"  in register env _0_225 c_pure
                     in
                  let c_app =
                    let t1 =
                      FStar_Syntax_Syntax.gen_bv "t1" None
                        FStar_Syntax_Util.ktype
                       in
                    let t2 =
                      FStar_Syntax_Syntax.gen_bv "t2" None
                        FStar_Syntax_Util.ktype
                       in
                    let l =
                      let _0_230 =
                        mk_gctx
                          (let _0_229 =
                             let _0_227 =
                               FStar_Syntax_Syntax.mk_binder
                                 (let _0_226 =
                                    FStar_Syntax_Syntax.bv_to_name t1  in
                                  FStar_Syntax_Syntax.new_bv None _0_226)
                                in
                             [_0_227]  in
                           let _0_228 =
                             FStar_Syntax_Syntax.mk_GTotal
                               (FStar_Syntax_Syntax.bv_to_name t2)
                              in
                           FStar_Syntax_Util.arrow _0_229 _0_228)
                         in
                      FStar_Syntax_Syntax.gen_bv "l" None _0_230  in
                    let r =
                      let _0_231 =
                        mk_gctx (FStar_Syntax_Syntax.bv_to_name t1)  in
                      FStar_Syntax_Syntax.gen_bv "r" None _0_231  in
                    let ret =
                      Some
                        (FStar_Util.Inl
                           (FStar_Syntax_Util.lcomp_of_comp
                              (FStar_Syntax_Syntax.mk_Total
                                 (mk_gctx (FStar_Syntax_Syntax.bv_to_name t2)))))
                       in
                    let outer_body =
                      let gamma_as_args = args_of_binders gamma  in
                      let inner_body =
                        let _0_236 = FStar_Syntax_Syntax.bv_to_name l  in
                        let _0_235 =
                          let _0_234 =
                            let _0_233 =
                              FStar_Syntax_Syntax.as_arg
                                (let _0_232 =
                                   FStar_Syntax_Syntax.bv_to_name r  in
                                 FStar_Syntax_Util.mk_app _0_232
                                   gamma_as_args)
                               in
                            [_0_233]  in
                          FStar_List.append gamma_as_args _0_234  in
                        FStar_Syntax_Util.mk_app _0_236 _0_235  in
                      FStar_Syntax_Util.abs gamma inner_body ret  in
                    let _0_239 =
                      let _0_238 = mk_all_implicit binders  in
                      let _0_237 =
                        binders_of_list
                          [(a, true);
                          (t1, true);
                          (t2, true);
                          (l, false);
                          (r, false)]
                         in
                      FStar_List.append _0_238 _0_237  in
                    FStar_Syntax_Util.abs _0_239 outer_body ret  in
                  let c_app =
                    let _0_240 = mk_lid "app"  in register env _0_240 c_app
                     in
                  let c_lift1 =
                    let t1 =
                      FStar_Syntax_Syntax.gen_bv "t1" None
                        FStar_Syntax_Util.ktype
                       in
                    let t2 =
                      FStar_Syntax_Syntax.gen_bv "t2" None
                        FStar_Syntax_Util.ktype
                       in
                    let t_f =
                      let _0_243 =
                        let _0_241 =
                          FStar_Syntax_Syntax.null_binder
                            (FStar_Syntax_Syntax.bv_to_name t1)
                           in
                        [_0_241]  in
                      let _0_242 =
                        FStar_Syntax_Syntax.mk_GTotal
                          (FStar_Syntax_Syntax.bv_to_name t2)
                         in
                      FStar_Syntax_Util.arrow _0_243 _0_242  in
                    let f = FStar_Syntax_Syntax.gen_bv "f" None t_f  in
                    let a1 =
                      let _0_244 =
                        mk_gctx (FStar_Syntax_Syntax.bv_to_name t1)  in
                      FStar_Syntax_Syntax.gen_bv "a1" None _0_244  in
                    let ret =
                      Some
                        (FStar_Util.Inl
                           (FStar_Syntax_Util.lcomp_of_comp
                              (FStar_Syntax_Syntax.mk_Total
                                 (mk_gctx (FStar_Syntax_Syntax.bv_to_name t2)))))
                       in
                    let _0_256 =
                      let _0_246 = mk_all_implicit binders  in
                      let _0_245 =
                        binders_of_list
                          [(a, true);
                          (t1, true);
                          (t2, true);
                          (f, false);
                          (a1, false)]
                         in
                      FStar_List.append _0_246 _0_245  in
                    let _0_255 =
                      let _0_254 =
                        let _0_253 =
                          let _0_252 =
                            let _0_249 =
                              let _0_248 =
                                let _0_247 = FStar_Syntax_Syntax.bv_to_name f
                                   in
                                [_0_247]  in
                              FStar_List.map FStar_Syntax_Syntax.as_arg
                                _0_248
                               in
                            FStar_Syntax_Util.mk_app c_pure _0_249  in
                          let _0_251 =
                            let _0_250 = FStar_Syntax_Syntax.bv_to_name a1
                               in
                            [_0_250]  in
                          _0_252 :: _0_251  in
                        FStar_List.map FStar_Syntax_Syntax.as_arg _0_253  in
                      FStar_Syntax_Util.mk_app c_app _0_254  in
                    FStar_Syntax_Util.abs _0_256 _0_255 ret  in
                  let c_lift1 =
                    let _0_257 = mk_lid "lift1"  in
                    register env _0_257 c_lift1  in
                  let c_lift2 =
                    let t1 =
                      FStar_Syntax_Syntax.gen_bv "t1" None
                        FStar_Syntax_Util.ktype
                       in
                    let t2 =
                      FStar_Syntax_Syntax.gen_bv "t2" None
                        FStar_Syntax_Util.ktype
                       in
                    let t3 =
                      FStar_Syntax_Syntax.gen_bv "t3" None
                        FStar_Syntax_Util.ktype
                       in
                    let t_f =
                      let _0_262 =
                        let _0_260 =
                          FStar_Syntax_Syntax.null_binder
                            (FStar_Syntax_Syntax.bv_to_name t1)
                           in
                        let _0_259 =
                          let _0_258 =
                            FStar_Syntax_Syntax.null_binder
                              (FStar_Syntax_Syntax.bv_to_name t2)
                             in
                          [_0_258]  in
                        _0_260 :: _0_259  in
                      let _0_261 =
                        FStar_Syntax_Syntax.mk_GTotal
                          (FStar_Syntax_Syntax.bv_to_name t3)
                         in
                      FStar_Syntax_Util.arrow _0_262 _0_261  in
                    let f = FStar_Syntax_Syntax.gen_bv "f" None t_f  in
                    let a1 =
                      let _0_263 =
                        mk_gctx (FStar_Syntax_Syntax.bv_to_name t1)  in
                      FStar_Syntax_Syntax.gen_bv "a1" None _0_263  in
                    let a2 =
                      let _0_264 =
                        mk_gctx (FStar_Syntax_Syntax.bv_to_name t2)  in
                      FStar_Syntax_Syntax.gen_bv "a2" None _0_264  in
                    let ret =
                      Some
                        (FStar_Util.Inl
                           (FStar_Syntax_Util.lcomp_of_comp
                              (FStar_Syntax_Syntax.mk_Total
                                 (mk_gctx (FStar_Syntax_Syntax.bv_to_name t3)))))
                       in
                    let _0_281 =
                      let _0_266 = mk_all_implicit binders  in
                      let _0_265 =
                        binders_of_list
                          [(a, true);
                          (t1, true);
                          (t2, true);
                          (t3, true);
                          (f, false);
                          (a1, false);
                          (a2, false)]
                         in
                      FStar_List.append _0_266 _0_265  in
                    let _0_280 =
                      let _0_279 =
                        let _0_278 =
                          let _0_277 =
                            let _0_274 =
                              let _0_273 =
                                let _0_272 =
                                  let _0_269 =
                                    let _0_268 =
                                      let _0_267 =
                                        FStar_Syntax_Syntax.bv_to_name f  in
                                      [_0_267]  in
                                    FStar_List.map FStar_Syntax_Syntax.as_arg
                                      _0_268
                                     in
                                  FStar_Syntax_Util.mk_app c_pure _0_269  in
                                let _0_271 =
                                  let _0_270 =
                                    FStar_Syntax_Syntax.bv_to_name a1  in
                                  [_0_270]  in
                                _0_272 :: _0_271  in
                              FStar_List.map FStar_Syntax_Syntax.as_arg
                                _0_273
                               in
                            FStar_Syntax_Util.mk_app c_app _0_274  in
                          let _0_276 =
                            let _0_275 = FStar_Syntax_Syntax.bv_to_name a2
                               in
                            [_0_275]  in
                          _0_277 :: _0_276  in
                        FStar_List.map FStar_Syntax_Syntax.as_arg _0_278  in
                      FStar_Syntax_Util.mk_app c_app _0_279  in
                    FStar_Syntax_Util.abs _0_281 _0_280 ret  in
                  let c_lift2 =
                    let _0_282 = mk_lid "lift2"  in
                    register env _0_282 c_lift2  in
                  let c_push =
                    let t1 =
                      FStar_Syntax_Syntax.gen_bv "t1" None
                        FStar_Syntax_Util.ktype
                       in
                    let t2 =
                      FStar_Syntax_Syntax.gen_bv "t2" None
                        FStar_Syntax_Util.ktype
                       in
                    let t_f =
                      let _0_285 =
                        let _0_283 =
                          FStar_Syntax_Syntax.null_binder
                            (FStar_Syntax_Syntax.bv_to_name t1)
                           in
                        [_0_283]  in
                      let _0_284 =
                        FStar_Syntax_Syntax.mk_Total
                          (mk_gctx (FStar_Syntax_Syntax.bv_to_name t2))
                         in
                      FStar_Syntax_Util.arrow _0_285 _0_284  in
                    let f = FStar_Syntax_Syntax.gen_bv "f" None t_f  in
                    let ret =
                      Some
                        (FStar_Util.Inl
                           (FStar_Syntax_Util.lcomp_of_comp
                              (FStar_Syntax_Syntax.mk_Total
                                 (mk_ctx
                                    (let _0_288 =
                                       let _0_286 =
                                         FStar_Syntax_Syntax.null_binder
                                           (FStar_Syntax_Syntax.bv_to_name t1)
                                          in
                                       [_0_286]  in
                                     let _0_287 =
                                       FStar_Syntax_Syntax.mk_GTotal
                                         (FStar_Syntax_Syntax.bv_to_name t2)
                                        in
                                     FStar_Syntax_Util.arrow _0_288 _0_287)))))
                       in
                    let e1 =
                      let _0_289 = FStar_Syntax_Syntax.bv_to_name t1  in
                      FStar_Syntax_Syntax.gen_bv "e1" None _0_289  in
                    let body =
                      let _0_297 =
                        let _0_291 =
                          let _0_290 = FStar_Syntax_Syntax.mk_binder e1  in
                          [_0_290]  in
                        FStar_List.append gamma _0_291  in
                      let _0_296 =
                        let _0_295 = FStar_Syntax_Syntax.bv_to_name f  in
                        let _0_294 =
                          let _0_293 =
                            FStar_Syntax_Syntax.as_arg
                              (FStar_Syntax_Syntax.bv_to_name e1)
                             in
                          let _0_292 = args_of_binders gamma  in _0_293 ::
                            _0_292
                           in
                        FStar_Syntax_Util.mk_app _0_295 _0_294  in
                      FStar_Syntax_Util.abs _0_297 _0_296 ret  in
                    let _0_300 =
                      let _0_299 = mk_all_implicit binders  in
                      let _0_298 =
                        binders_of_list
                          [(a, true); (t1, true); (t2, true); (f, false)]
                         in
                      FStar_List.append _0_299 _0_298  in
                    FStar_Syntax_Util.abs _0_300 body ret  in
                  let c_push =
                    let _0_301 = mk_lid "push"  in register env _0_301 c_push
                     in
                  let ret_tot_wp_a =
                    Some
                      (FStar_Util.Inl
                         (FStar_Syntax_Util.lcomp_of_comp
                            (FStar_Syntax_Syntax.mk_Total wp_a)))
                     in
                  let mk_generic_app c =
                    if (FStar_List.length binders) > (Prims.parse_int "0")
                    then
                      mk
                        (FStar_Syntax_Syntax.Tm_app
                           (let _0_302 = args_of_binders binders  in
                            (c, _0_302)))
                    else c  in
                  let wp_if_then_else =
                    let result_comp =
                      FStar_Syntax_Syntax.mk_Total
                        (let _0_307 =
                           let _0_305 = FStar_Syntax_Syntax.null_binder wp_a
                              in
                           let _0_304 =
                             let _0_303 =
                               FStar_Syntax_Syntax.null_binder wp_a  in
                             [_0_303]  in
                           _0_305 :: _0_304  in
                         let _0_306 = FStar_Syntax_Syntax.mk_Total wp_a  in
                         FStar_Syntax_Util.arrow _0_307 _0_306)
                       in
                    let c =
                      FStar_Syntax_Syntax.gen_bv "c" None
                        FStar_Syntax_Util.ktype
                       in
                    let _0_316 =
                      let _0_308 = FStar_Syntax_Syntax.binders_of_list [a; c]
                         in
                      FStar_List.append binders _0_308  in
                    let _0_315 =
                      let l_ite =
                        FStar_Syntax_Syntax.fvar FStar_Syntax_Const.ite_lid
                          (FStar_Syntax_Syntax.Delta_defined_at_level
                             (Prims.parse_int "2")) None
                         in
                      let _0_314 =
                        let _0_313 =
                          let _0_312 =
                            let _0_311 =
                              let _0_310 =
                                let _0_309 =
                                  FStar_Syntax_Syntax.as_arg
                                    (FStar_Syntax_Syntax.bv_to_name c)
                                   in
                                [_0_309]  in
                              FStar_Syntax_Util.mk_app l_ite _0_310  in
                            [_0_311]  in
                          FStar_List.map FStar_Syntax_Syntax.as_arg _0_312
                           in
                        FStar_Syntax_Util.mk_app c_lift2 _0_313  in
                      FStar_Syntax_Util.ascribe _0_314
                        (FStar_Util.Inr result_comp)
                       in
                    FStar_Syntax_Util.abs _0_316 _0_315
                      (Some
                         (FStar_Util.Inl
                            (FStar_Syntax_Util.lcomp_of_comp result_comp)))
                     in
                  let wp_if_then_else =
                    let _0_317 = mk_lid "wp_if_then_else"  in
                    register env _0_317 wp_if_then_else  in
                  let wp_if_then_else = mk_generic_app wp_if_then_else  in
                  let wp_assert =
                    let q =
                      FStar_Syntax_Syntax.gen_bv "q" None
                        FStar_Syntax_Util.ktype
                       in
                    let wp = FStar_Syntax_Syntax.gen_bv "wp" None wp_a  in
                    let l_and =
                      FStar_Syntax_Syntax.fvar FStar_Syntax_Const.and_lid
                        (FStar_Syntax_Syntax.Delta_defined_at_level
                           (Prims.parse_int "1")) None
                       in
                    let body =
                      let _0_327 =
                        let _0_326 =
                          let _0_325 =
                            let _0_322 =
                              let _0_321 =
                                let _0_320 =
                                  let _0_319 =
                                    let _0_318 =
                                      FStar_Syntax_Syntax.as_arg
                                        (FStar_Syntax_Syntax.bv_to_name q)
                                       in
                                    [_0_318]  in
                                  FStar_Syntax_Util.mk_app l_and _0_319  in
                                [_0_320]  in
                              FStar_List.map FStar_Syntax_Syntax.as_arg
                                _0_321
                               in
                            FStar_Syntax_Util.mk_app c_pure _0_322  in
                          let _0_324 =
                            let _0_323 = FStar_Syntax_Syntax.bv_to_name wp
                               in
                            [_0_323]  in
                          _0_325 :: _0_324  in
                        FStar_List.map FStar_Syntax_Syntax.as_arg _0_326  in
                      FStar_Syntax_Util.mk_app c_app _0_327  in
                    let _0_329 =
                      let _0_328 =
                        FStar_Syntax_Syntax.binders_of_list [a; q; wp]  in
                      FStar_List.append binders _0_328  in
                    FStar_Syntax_Util.abs _0_329 body ret_tot_wp_a  in
                  let wp_assert =
                    let _0_330 = mk_lid "wp_assert"  in
                    register env _0_330 wp_assert  in
                  let wp_assert = mk_generic_app wp_assert  in
                  let wp_assume =
                    let q =
                      FStar_Syntax_Syntax.gen_bv "q" None
                        FStar_Syntax_Util.ktype
                       in
                    let wp = FStar_Syntax_Syntax.gen_bv "wp" None wp_a  in
                    let l_imp =
                      FStar_Syntax_Syntax.fvar FStar_Syntax_Const.imp_lid
                        (FStar_Syntax_Syntax.Delta_defined_at_level
                           (Prims.parse_int "1")) None
                       in
                    let body =
                      let _0_340 =
                        let _0_339 =
                          let _0_338 =
                            let _0_335 =
                              let _0_334 =
                                let _0_333 =
                                  let _0_332 =
                                    let _0_331 =
                                      FStar_Syntax_Syntax.as_arg
                                        (FStar_Syntax_Syntax.bv_to_name q)
                                       in
                                    [_0_331]  in
                                  FStar_Syntax_Util.mk_app l_imp _0_332  in
                                [_0_333]  in
                              FStar_List.map FStar_Syntax_Syntax.as_arg
                                _0_334
                               in
                            FStar_Syntax_Util.mk_app c_pure _0_335  in
                          let _0_337 =
                            let _0_336 = FStar_Syntax_Syntax.bv_to_name wp
                               in
                            [_0_336]  in
                          _0_338 :: _0_337  in
                        FStar_List.map FStar_Syntax_Syntax.as_arg _0_339  in
                      FStar_Syntax_Util.mk_app c_app _0_340  in
                    let _0_342 =
                      let _0_341 =
                        FStar_Syntax_Syntax.binders_of_list [a; q; wp]  in
                      FStar_List.append binders _0_341  in
                    FStar_Syntax_Util.abs _0_342 body ret_tot_wp_a  in
                  let wp_assume =
                    let _0_343 = mk_lid "wp_assume"  in
                    register env _0_343 wp_assume  in
                  let wp_assume = mk_generic_app wp_assume  in
                  let wp_close =
                    let b =
                      FStar_Syntax_Syntax.gen_bv "b" None
                        FStar_Syntax_Util.ktype
                       in
                    let t_f =
                      let _0_346 =
                        let _0_344 =
                          FStar_Syntax_Syntax.null_binder
                            (FStar_Syntax_Syntax.bv_to_name b)
                           in
                        [_0_344]  in
                      let _0_345 = FStar_Syntax_Syntax.mk_Total wp_a  in
                      FStar_Syntax_Util.arrow _0_346 _0_345  in
                    let f = FStar_Syntax_Syntax.gen_bv "f" None t_f  in
                    let body =
                      let _0_355 =
                        let _0_354 =
                          let _0_353 =
                            let _0_347 =
                              FStar_List.map FStar_Syntax_Syntax.as_arg
                                [FStar_Syntax_Util.tforall]
                               in
                            FStar_Syntax_Util.mk_app c_pure _0_347  in
                          let _0_352 =
                            let _0_351 =
                              let _0_350 =
                                let _0_349 =
                                  let _0_348 =
                                    FStar_Syntax_Syntax.bv_to_name f  in
                                  [_0_348]  in
                                FStar_List.map FStar_Syntax_Syntax.as_arg
                                  _0_349
                                 in
                              FStar_Syntax_Util.mk_app c_push _0_350  in
                            [_0_351]  in
                          _0_353 :: _0_352  in
                        FStar_List.map FStar_Syntax_Syntax.as_arg _0_354  in
                      FStar_Syntax_Util.mk_app c_app _0_355  in
                    let _0_357 =
                      let _0_356 =
                        FStar_Syntax_Syntax.binders_of_list [a; b; f]  in
                      FStar_List.append binders _0_356  in
                    FStar_Syntax_Util.abs _0_357 body ret_tot_wp_a  in
                  let wp_close =
                    let _0_358 = mk_lid "wp_close"  in
                    register env _0_358 wp_close  in
                  let wp_close = mk_generic_app wp_close  in
                  let ret_tot_type =
                    Some
                      (FStar_Util.Inl
                         (let _0_359 =
                            FStar_Syntax_Syntax.mk_Total
                              FStar_Syntax_Util.ktype
                             in
                          FStar_All.pipe_left FStar_Syntax_Util.lcomp_of_comp
                            _0_359))
                     in
                  let ret_gtot_type =
                    Some
                      (FStar_Util.Inl
                         (let _0_360 =
                            FStar_Syntax_Syntax.mk_GTotal
                              FStar_Syntax_Util.ktype
                             in
                          FStar_All.pipe_left FStar_Syntax_Util.lcomp_of_comp
                            _0_360))
                     in
                  let mk_forall x body =
                    (FStar_Syntax_Syntax.mk
                       (FStar_Syntax_Syntax.Tm_app
                          (let _0_364 =
                             let _0_363 =
                               FStar_Syntax_Syntax.as_arg
                                 (let _0_362 =
                                    let _0_361 =
                                      FStar_Syntax_Syntax.mk_binder x  in
                                    [_0_361]  in
                                  FStar_Syntax_Util.abs _0_362 body
                                    ret_tot_type)
                                in
                             [_0_363]  in
                           (FStar_Syntax_Util.tforall, _0_364)))) None
                      FStar_Range.dummyRange
                     in
                  let rec is_discrete t =
                    let uu____721 =
                      (FStar_Syntax_Subst.compress t).FStar_Syntax_Syntax.n
                       in
                    match uu____721 with
                    | FStar_Syntax_Syntax.Tm_type uu____722 -> false
                    | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
                        (FStar_List.for_all
                           (fun uu____737  ->
                              match uu____737 with
                              | (b,uu____741) ->
                                  is_discrete b.FStar_Syntax_Syntax.sort) bs)
                          && (is_discrete (FStar_Syntax_Util.comp_result c))
                    | uu____742 -> true  in
                  let rec is_monotonic t =
                    let uu____747 =
                      (FStar_Syntax_Subst.compress t).FStar_Syntax_Syntax.n
                       in
                    match uu____747 with
                    | FStar_Syntax_Syntax.Tm_type uu____748 -> true
                    | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
                        (FStar_List.for_all
                           (fun uu____763  ->
                              match uu____763 with
                              | (b,uu____767) ->
                                  is_discrete b.FStar_Syntax_Syntax.sort) bs)
                          && (is_monotonic (FStar_Syntax_Util.comp_result c))
                    | uu____768 -> is_discrete t  in
                  let rec mk_rel rel t x y =
                    let mk_rel = mk_rel rel  in
                    let t =
                      FStar_TypeChecker_Normalize.normalize
                        [FStar_TypeChecker_Normalize.Beta;
                        FStar_TypeChecker_Normalize.Eager_unfolding;
                        FStar_TypeChecker_Normalize.UnfoldUntil
                          FStar_Syntax_Syntax.Delta_constant] env t
                       in
                    let uu____820 =
                      (FStar_Syntax_Subst.compress t).FStar_Syntax_Syntax.n
                       in
                    match uu____820 with
                    | FStar_Syntax_Syntax.Tm_type uu____821 -> rel x y
                    | FStar_Syntax_Syntax.Tm_arrow
                      (binder::[],{
                                    FStar_Syntax_Syntax.n =
                                      FStar_Syntax_Syntax.GTotal (b,_);
                                    FStar_Syntax_Syntax.tk = _;
                                    FStar_Syntax_Syntax.pos = _;
                                    FStar_Syntax_Syntax.vars = _;_})
                      |FStar_Syntax_Syntax.Tm_arrow
                      (binder::[],{
                                    FStar_Syntax_Syntax.n =
                                      FStar_Syntax_Syntax.Total (b,_);
                                    FStar_Syntax_Syntax.tk = _;
                                    FStar_Syntax_Syntax.pos = _;
                                    FStar_Syntax_Syntax.vars = _;_})
                        ->
                        let a = (Prims.fst binder).FStar_Syntax_Syntax.sort
                           in
                        let uu____867 = (is_monotonic a) || (is_monotonic b)
                           in
                        if uu____867
                        then
                          let a1 = FStar_Syntax_Syntax.gen_bv "a1" None a  in
                          let body =
                            let _0_370 =
                              let _0_366 =
                                let _0_365 =
                                  FStar_Syntax_Syntax.as_arg
                                    (FStar_Syntax_Syntax.bv_to_name a1)
                                   in
                                [_0_365]  in
                              FStar_Syntax_Util.mk_app x _0_366  in
                            let _0_369 =
                              let _0_368 =
                                let _0_367 =
                                  FStar_Syntax_Syntax.as_arg
                                    (FStar_Syntax_Syntax.bv_to_name a1)
                                   in
                                [_0_367]  in
                              FStar_Syntax_Util.mk_app y _0_368  in
                            mk_rel b _0_370 _0_369  in
                          mk_forall a1 body
                        else
                          (let a1 = FStar_Syntax_Syntax.gen_bv "a1" None a
                              in
                           let a2 = FStar_Syntax_Syntax.gen_bv "a2" None a
                              in
                           let body =
                             let _0_380 =
                               let _0_372 = FStar_Syntax_Syntax.bv_to_name a1
                                  in
                               let _0_371 = FStar_Syntax_Syntax.bv_to_name a2
                                  in
                               mk_rel a _0_372 _0_371  in
                             let _0_379 =
                               let _0_378 =
                                 let _0_374 =
                                   let _0_373 =
                                     FStar_Syntax_Syntax.as_arg
                                       (FStar_Syntax_Syntax.bv_to_name a1)
                                      in
                                   [_0_373]  in
                                 FStar_Syntax_Util.mk_app x _0_374  in
                               let _0_377 =
                                 let _0_376 =
                                   let _0_375 =
                                     FStar_Syntax_Syntax.as_arg
                                       (FStar_Syntax_Syntax.bv_to_name a2)
                                      in
                                   [_0_375]  in
                                 FStar_Syntax_Util.mk_app y _0_376  in
                               mk_rel b _0_378 _0_377  in
                             FStar_Syntax_Util.mk_imp _0_380 _0_379  in
                           let _0_381 = mk_forall a2 body  in
                           mk_forall a1 _0_381)
                    | FStar_Syntax_Syntax.Tm_arrow (binder::binders,comp) ->
                        let t =
                          let uu___97_894 = t  in
                          let _0_383 =
                            FStar_Syntax_Syntax.Tm_arrow
                              (let _0_382 =
                                 FStar_Syntax_Syntax.mk_Total
                                   (FStar_Syntax_Util.arrow binders comp)
                                  in
                               ([binder], _0_382))
                             in
                          {
                            FStar_Syntax_Syntax.n = _0_383;
                            FStar_Syntax_Syntax.tk =
                              (uu___97_894.FStar_Syntax_Syntax.tk);
                            FStar_Syntax_Syntax.pos =
                              (uu___97_894.FStar_Syntax_Syntax.pos);
                            FStar_Syntax_Syntax.vars =
                              (uu___97_894.FStar_Syntax_Syntax.vars)
                          }  in
                        mk_rel t x y
                    | FStar_Syntax_Syntax.Tm_arrow uu____906 ->
                        failwith "unhandled arrow"
                    | uu____914 -> FStar_Syntax_Util.mk_untyped_eq2 x y  in
                  let stronger =
                    let wp1 = FStar_Syntax_Syntax.gen_bv "wp1" None wp_a  in
                    let wp2 = FStar_Syntax_Syntax.gen_bv "wp2" None wp_a  in
                    let rec mk_stronger t x y =
                      let t =
                        FStar_TypeChecker_Normalize.normalize
                          [FStar_TypeChecker_Normalize.Beta;
                          FStar_TypeChecker_Normalize.Eager_unfolding;
                          FStar_TypeChecker_Normalize.UnfoldUntil
                            FStar_Syntax_Syntax.Delta_constant] env t
                         in
                      let uu____929 =
                        (FStar_Syntax_Subst.compress t).FStar_Syntax_Syntax.n
                         in
                      match uu____929 with
                      | FStar_Syntax_Syntax.Tm_type uu____930 ->
                          FStar_Syntax_Util.mk_imp x y
                      | FStar_Syntax_Syntax.Tm_app (head,args) when
                          FStar_Syntax_Util.is_tuple_constructor
                            (FStar_Syntax_Subst.compress head)
                          ->
                          let project i tuple =
                            let projector =
                              let _0_385 =
                                let _0_384 =
                                  FStar_Syntax_Util.mk_tuple_data_lid
                                    (FStar_List.length args)
                                    FStar_Range.dummyRange
                                   in
                                FStar_TypeChecker_Env.lookup_projector env
                                  _0_384 i
                                 in
                              FStar_Syntax_Syntax.fvar _0_385
                                (FStar_Syntax_Syntax.Delta_defined_at_level
                                   (Prims.parse_int "1")) None
                               in
                            FStar_Syntax_Util.mk_app projector
                              [(tuple, None)]
                             in
                          let uu____981 =
                            let uu____985 =
                              FStar_List.mapi
                                (fun i  ->
                                   fun uu____990  ->
                                     match uu____990 with
                                     | (t,q) ->
                                         let _0_387 = project i x  in
                                         let _0_386 = project i y  in
                                         mk_stronger t _0_387 _0_386) args
                               in
                            match uu____985 with
                            | [] ->
                                failwith
                                  "Impossible : Empty application when creating stronger relation in DM4F"
                            | rel0::rels -> (rel0, rels)  in
                          (match uu____981 with
                           | (rel0,rels) ->
                               FStar_List.fold_left FStar_Syntax_Util.mk_conj
                                 rel0 rels)
                      | FStar_Syntax_Syntax.Tm_arrow
                        (binders,{
                                   FStar_Syntax_Syntax.n =
                                     FStar_Syntax_Syntax.GTotal (b,_);
                                   FStar_Syntax_Syntax.tk = _;
                                   FStar_Syntax_Syntax.pos = _;
                                   FStar_Syntax_Syntax.vars = _;_})
                        |FStar_Syntax_Syntax.Tm_arrow
                        (binders,{
                                   FStar_Syntax_Syntax.n =
                                     FStar_Syntax_Syntax.Total (b,_);
                                   FStar_Syntax_Syntax.tk = _;
                                   FStar_Syntax_Syntax.pos = _;
                                   FStar_Syntax_Syntax.vars = _;_})
                          ->
                          let bvs =
                            FStar_List.mapi
                              (fun i  ->
                                 fun uu____1050  ->
                                   match uu____1050 with
                                   | (bv,q) ->
                                       let _0_389 =
                                         let _0_388 =
                                           FStar_Util.string_of_int i  in
                                         Prims.strcat "a" _0_388  in
                                       FStar_Syntax_Syntax.gen_bv _0_389 None
                                         bv.FStar_Syntax_Syntax.sort) binders
                             in
                          let args =
                            FStar_List.map
                              (fun ai  ->
                                 FStar_Syntax_Syntax.as_arg
                                   (FStar_Syntax_Syntax.bv_to_name ai)) bvs
                             in
                          let body =
                            let _0_391 = FStar_Syntax_Util.mk_app x args  in
                            let _0_390 = FStar_Syntax_Util.mk_app y args  in
                            mk_stronger b _0_391 _0_390  in
                          FStar_List.fold_right
                            (fun bv  -> fun body  -> mk_forall bv body) bvs
                            body
                      | uu____1061 -> failwith "Not a DM elaborated type"  in
                    let body =
                      let _0_394 = FStar_Syntax_Util.unascribe wp_a  in
                      let _0_393 = FStar_Syntax_Syntax.bv_to_name wp1  in
                      let _0_392 = FStar_Syntax_Syntax.bv_to_name wp2  in
                      mk_stronger _0_394 _0_393 _0_392  in
                    let _0_396 =
                      let _0_395 =
                        binders_of_list
                          [(a, false); (wp1, false); (wp2, false)]
                         in
                      FStar_List.append binders _0_395  in
                    FStar_Syntax_Util.abs _0_396 body ret_tot_type  in
                  let stronger =
                    let _0_397 = mk_lid "stronger"  in
                    register env _0_397 stronger  in
                  let stronger = mk_generic_app stronger  in
                  let wp_ite =
                    let wp = FStar_Syntax_Syntax.gen_bv "wp" None wp_a  in
                    let uu____1079 = FStar_Util.prefix gamma  in
                    match uu____1079 with
                    | (wp_args,post) ->
                        let k =
                          FStar_Syntax_Syntax.gen_bv "k" None
                            (Prims.fst post).FStar_Syntax_Syntax.sort
                           in
                        let equiv =
                          let k_tm = FStar_Syntax_Syntax.bv_to_name k  in
                          let eq =
                            let _0_398 =
                              FStar_Syntax_Syntax.bv_to_name (Prims.fst post)
                               in
                            mk_rel FStar_Syntax_Util.mk_iff
                              k.FStar_Syntax_Syntax.sort k_tm _0_398
                             in
                          let uu____1105 =
                            FStar_Syntax_Util.destruct_typ_as_formula eq  in
                          match uu____1105 with
                          | Some (FStar_Syntax_Util.QAll (binders,[],body))
                              ->
                              let k_app =
                                let _0_399 = args_of_binders binders  in
                                FStar_Syntax_Util.mk_app k_tm _0_399  in
                              let guard_free =
                                FStar_Syntax_Syntax.fv_to_tm
                                  (FStar_Syntax_Syntax.lid_as_fv
                                     FStar_Syntax_Const.guard_free
                                     FStar_Syntax_Syntax.Delta_constant None)
                                 in
                              let pat =
                                let _0_401 =
                                  let _0_400 =
                                    FStar_Syntax_Syntax.as_arg k_app  in
                                  [_0_400]  in
                                FStar_Syntax_Util.mk_app guard_free _0_401
                                 in
                              let pattern_guarded_body =
                                mk
                                  (FStar_Syntax_Syntax.Tm_meta
                                     (let _0_404 =
                                        FStar_Syntax_Syntax.Meta_pattern
                                          (let _0_403 =
                                             let _0_402 =
                                               FStar_Syntax_Syntax.as_arg pat
                                                in
                                             [_0_402]  in
                                           [_0_403])
                                         in
                                      (body, _0_404)))
                                 in
                              FStar_Syntax_Util.close_forall binders
                                pattern_guarded_body
                          | uu____1122 ->
                              failwith
                                "Impossible: Expected the equivalence to be a quantified formula"
                           in
                        let body =
                          let _0_412 =
                            let _0_411 =
                              let _0_410 =
                                let _0_409 =
                                  FStar_Syntax_Syntax.bv_to_name wp  in
                                let _0_408 =
                                  let _0_407 = args_of_binders wp_args  in
                                  let _0_406 =
                                    let _0_405 =
                                      FStar_Syntax_Syntax.as_arg
                                        (FStar_Syntax_Syntax.bv_to_name k)
                                       in
                                    [_0_405]  in
                                  FStar_List.append _0_407 _0_406  in
                                FStar_Syntax_Util.mk_app _0_409 _0_408  in
                              FStar_Syntax_Util.mk_imp equiv _0_410  in
                            FStar_Syntax_Util.mk_forall k _0_411  in
                          FStar_Syntax_Util.abs gamma _0_412 ret_gtot_type
                           in
                        let _0_414 =
                          let _0_413 =
                            FStar_Syntax_Syntax.binders_of_list [a; wp]  in
                          FStar_List.append binders _0_413  in
                        FStar_Syntax_Util.abs _0_414 body ret_gtot_type
                     in
                  let wp_ite =
                    let _0_415 = mk_lid "wp_ite"  in
                    register env _0_415 wp_ite  in
                  let wp_ite = mk_generic_app wp_ite  in
                  let null_wp =
                    let wp = FStar_Syntax_Syntax.gen_bv "wp" None wp_a  in
                    let uu____1133 = FStar_Util.prefix gamma  in
                    match uu____1133 with
                    | (wp_args,post) ->
                        let x =
                          FStar_Syntax_Syntax.gen_bv "x" None
                            FStar_Syntax_Syntax.tun
                           in
                        let body =
                          let _0_419 =
                            let _0_418 =
                              FStar_All.pipe_left
                                FStar_Syntax_Syntax.bv_to_name
                                (Prims.fst post)
                               in
                            let _0_417 =
                              let _0_416 =
                                FStar_Syntax_Syntax.as_arg
                                  (FStar_Syntax_Syntax.bv_to_name x)
                                 in
                              [_0_416]  in
                            FStar_Syntax_Util.mk_app _0_418 _0_417  in
                          FStar_Syntax_Util.mk_forall x _0_419  in
                        let _0_422 =
                          let _0_421 =
                            let _0_420 =
                              FStar_Syntax_Syntax.binders_of_list [a]  in
                            FStar_List.append _0_420 gamma  in
                          FStar_List.append binders _0_421  in
                        FStar_Syntax_Util.abs _0_422 body ret_gtot_type
                     in
                  let null_wp =
                    let _0_423 = mk_lid "null_wp"  in
                    register env _0_423 null_wp  in
                  let null_wp = mk_generic_app null_wp  in
                  let wp_trivial =
                    let wp = FStar_Syntax_Syntax.gen_bv "wp" None wp_a  in
                    let body =
                      let _0_432 =
                        let _0_431 =
                          let _0_430 = FStar_Syntax_Syntax.bv_to_name a  in
                          let _0_429 =
                            let _0_428 =
                              let _0_425 =
                                let _0_424 =
                                  FStar_Syntax_Syntax.as_arg
                                    (FStar_Syntax_Syntax.bv_to_name a)
                                   in
                                [_0_424]  in
                              FStar_Syntax_Util.mk_app null_wp _0_425  in
                            let _0_427 =
                              let _0_426 = FStar_Syntax_Syntax.bv_to_name wp
                                 in
                              [_0_426]  in
                            _0_428 :: _0_427  in
                          _0_430 :: _0_429  in
                        FStar_List.map FStar_Syntax_Syntax.as_arg _0_431  in
                      FStar_Syntax_Util.mk_app stronger _0_432  in
                    let _0_434 =
                      let _0_433 =
                        FStar_Syntax_Syntax.binders_of_list [a; wp]  in
                      FStar_List.append binders _0_433  in
                    FStar_Syntax_Util.abs _0_434 body ret_tot_type  in
                  let wp_trivial =
                    let _0_435 = mk_lid "wp_trivial"  in
                    register env _0_435 wp_trivial  in
                  let wp_trivial = mk_generic_app wp_trivial  in
                  ((let uu____1179 =
                      FStar_TypeChecker_Env.debug env
                        (FStar_Options.Other "ED")
                       in
                    if uu____1179
                    then d "End Dijkstra monads for free"
                    else ());
                   (let c = FStar_Syntax_Subst.close binders  in
                    let _0_453 = FStar_List.rev (FStar_ST.read sigelts)  in
                    let _0_452 =
                      let uu___98_1188 = ed  in
                      let _0_451 =
                        let _0_436 = c wp_if_then_else  in ([], _0_436)  in
                      let _0_450 = let _0_437 = c wp_ite  in ([], _0_437)  in
                      let _0_449 = let _0_438 = c stronger  in ([], _0_438)
                         in
                      let _0_448 = let _0_439 = c wp_close  in ([], _0_439)
                         in
                      let _0_447 = let _0_440 = c wp_assert  in ([], _0_440)
                         in
                      let _0_446 = let _0_441 = c wp_assume  in ([], _0_441)
                         in
                      let _0_445 = let _0_442 = c null_wp  in ([], _0_442)
                         in
                      let _0_444 = let _0_443 = c wp_trivial  in ([], _0_443)
                         in
                      {
                        FStar_Syntax_Syntax.qualifiers =
                          (uu___98_1188.FStar_Syntax_Syntax.qualifiers);
                        FStar_Syntax_Syntax.cattributes =
                          (uu___98_1188.FStar_Syntax_Syntax.cattributes);
                        FStar_Syntax_Syntax.mname =
                          (uu___98_1188.FStar_Syntax_Syntax.mname);
                        FStar_Syntax_Syntax.univs =
                          (uu___98_1188.FStar_Syntax_Syntax.univs);
                        FStar_Syntax_Syntax.binders =
                          (uu___98_1188.FStar_Syntax_Syntax.binders);
                        FStar_Syntax_Syntax.signature =
                          (uu___98_1188.FStar_Syntax_Syntax.signature);
                        FStar_Syntax_Syntax.ret_wp =
                          (uu___98_1188.FStar_Syntax_Syntax.ret_wp);
                        FStar_Syntax_Syntax.bind_wp =
                          (uu___98_1188.FStar_Syntax_Syntax.bind_wp);
                        FStar_Syntax_Syntax.if_then_else = _0_451;
                        FStar_Syntax_Syntax.ite_wp = _0_450;
                        FStar_Syntax_Syntax.stronger = _0_449;
                        FStar_Syntax_Syntax.close_wp = _0_448;
                        FStar_Syntax_Syntax.assert_p = _0_447;
                        FStar_Syntax_Syntax.assume_p = _0_446;
                        FStar_Syntax_Syntax.null_wp = _0_445;
                        FStar_Syntax_Syntax.trivial = _0_444;
                        FStar_Syntax_Syntax.repr =
                          (uu___98_1188.FStar_Syntax_Syntax.repr);
                        FStar_Syntax_Syntax.return_repr =
                          (uu___98_1188.FStar_Syntax_Syntax.return_repr);
                        FStar_Syntax_Syntax.bind_repr =
                          (uu___98_1188.FStar_Syntax_Syntax.bind_repr);
                        FStar_Syntax_Syntax.actions =
                          (uu___98_1188.FStar_Syntax_Syntax.actions)
                      }  in
                    (_0_453, _0_452)))))
  
type env_ = env
let get_env : env -> FStar_TypeChecker_Env.env = fun env  -> env.env 
type nm =
  | N of FStar_Syntax_Syntax.typ 
  | M of FStar_Syntax_Syntax.typ 
let uu___is_N : nm -> Prims.bool =
  fun projectee  -> match projectee with | N _0 -> true | uu____1210 -> false 
let __proj__N__item___0 : nm -> FStar_Syntax_Syntax.typ =
  fun projectee  -> match projectee with | N _0 -> _0 
let uu___is_M : nm -> Prims.bool =
  fun projectee  -> match projectee with | M _0 -> true | uu____1222 -> false 
let __proj__M__item___0 : nm -> FStar_Syntax_Syntax.typ =
  fun projectee  -> match projectee with | M _0 -> _0 
type nm_ = nm
let nm_of_comp : FStar_Syntax_Syntax.comp' -> nm =
  fun uu___85_1232  ->
    match uu___85_1232 with
    | FStar_Syntax_Syntax.Total (t,uu____1234) -> N t
    | FStar_Syntax_Syntax.Comp c when
        FStar_All.pipe_right c.FStar_Syntax_Syntax.flags
          (FStar_Util.for_some
             (fun uu___84_1243  ->
                match uu___84_1243 with
                | FStar_Syntax_Syntax.CPS  -> true
                | uu____1244 -> false))
        -> M (c.FStar_Syntax_Syntax.result_typ)
    | FStar_Syntax_Syntax.Comp c ->
        failwith
          (let _0_455 =
             let _0_454 = FStar_Syntax_Syntax.mk_Comp c  in
             FStar_All.pipe_left FStar_Syntax_Print.comp_to_string _0_454  in
           FStar_Util.format1 "[nm_of_comp]: impossible (%s)" _0_455)
    | FStar_Syntax_Syntax.GTotal uu____1246 ->
        failwith "[nm_of_comp]: impossible (GTot)"
  
let string_of_nm : nm -> Prims.string =
  fun uu___86_1254  ->
    match uu___86_1254 with
    | N t ->
        let _0_456 = FStar_Syntax_Print.term_to_string t  in
        FStar_Util.format1 "N[%s]" _0_456
    | M t ->
        let _0_457 = FStar_Syntax_Print.term_to_string t  in
        FStar_Util.format1 "M[%s]" _0_457
  
let is_monadic_arrow : FStar_Syntax_Syntax.term' -> nm =
  fun n  ->
    match n with
    | FStar_Syntax_Syntax.Tm_arrow
        (uu____1260,{ FStar_Syntax_Syntax.n = n;
                      FStar_Syntax_Syntax.tk = uu____1262;
                      FStar_Syntax_Syntax.pos = uu____1263;
                      FStar_Syntax_Syntax.vars = uu____1264;_})
        -> nm_of_comp n
    | uu____1275 -> failwith "unexpected_argument: [is_monadic_arrow]"
  
let is_monadic_comp c =
  let uu____1287 = nm_of_comp c.FStar_Syntax_Syntax.n  in
  match uu____1287 with | M uu____1288 -> true | N uu____1289 -> false 
exception Not_found 
let uu___is_Not_found : Prims.exn -> Prims.bool =
  fun projectee  ->
    match projectee with | Not_found  -> true | uu____1293 -> false
  
let double_star :
  FStar_Syntax_Syntax.typ ->
    (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax
  =
  fun typ  ->
    let star_once typ =
      let _0_461 =
        let _0_459 =
          let _0_458 = FStar_Syntax_Syntax.new_bv None typ  in
          FStar_All.pipe_left FStar_Syntax_Syntax.mk_binder _0_458  in
        [_0_459]  in
      let _0_460 = FStar_Syntax_Syntax.mk_Total FStar_Syntax_Util.ktype0  in
      FStar_Syntax_Util.arrow _0_461 _0_460  in
    let _0_462 = FStar_All.pipe_right typ star_once  in
    FStar_All.pipe_left star_once _0_462
  
let rec mk_star_to_type :
  (FStar_Syntax_Syntax.term' ->
     (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
       FStar_Syntax_Syntax.syntax)
    ->
    env ->
      (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax ->
        (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
          FStar_Syntax_Syntax.syntax
  =
  fun mk  ->
    fun env  ->
      fun a  ->
        mk
          (FStar_Syntax_Syntax.Tm_arrow
             (let _0_467 =
                let _0_465 =
                  let _0_464 = FStar_Syntax_Syntax.null_bv (star_type' env a)
                     in
                  let _0_463 = FStar_Syntax_Syntax.as_implicit false  in
                  (_0_464, _0_463)  in
                [_0_465]  in
              let _0_466 =
                FStar_Syntax_Syntax.mk_Total FStar_Syntax_Util.ktype0  in
              (_0_467, _0_466)))

and star_type' :
  env ->
    (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax -> FStar_Syntax_Syntax.term
  =
  fun env  ->
    fun t  ->
      let mk x = (FStar_Syntax_Syntax.mk x) None t.FStar_Syntax_Syntax.pos
         in
      let mk_star_to_type = mk_star_to_type mk  in
      let t = FStar_Syntax_Subst.compress t  in
      match t.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_arrow (binders,uu____1373) ->
          let binders =
            FStar_List.map
              (fun uu____1392  ->
                 match uu____1392 with
                 | (bv,aqual) ->
                     let _0_469 =
                       let uu___99_1399 = bv  in
                       let _0_468 =
                         star_type' env bv.FStar_Syntax_Syntax.sort  in
                       {
                         FStar_Syntax_Syntax.ppname =
                           (uu___99_1399.FStar_Syntax_Syntax.ppname);
                         FStar_Syntax_Syntax.index =
                           (uu___99_1399.FStar_Syntax_Syntax.index);
                         FStar_Syntax_Syntax.sort = _0_468
                       }  in
                     (_0_469, aqual)) binders
             in
          (match t.FStar_Syntax_Syntax.n with
           | FStar_Syntax_Syntax.Tm_arrow
               (uu____1400,{
                             FStar_Syntax_Syntax.n =
                               FStar_Syntax_Syntax.GTotal (hn,uu____1402);
                             FStar_Syntax_Syntax.tk = uu____1403;
                             FStar_Syntax_Syntax.pos = uu____1404;
                             FStar_Syntax_Syntax.vars = uu____1405;_})
               ->
               mk
                 (FStar_Syntax_Syntax.Tm_arrow
                    (let _0_470 =
                       FStar_Syntax_Syntax.mk_GTotal (star_type' env hn)  in
                     (binders, _0_470)))
           | uu____1425 ->
               let uu____1426 = is_monadic_arrow t.FStar_Syntax_Syntax.n  in
               (match uu____1426 with
                | N hn ->
                    mk
                      (FStar_Syntax_Syntax.Tm_arrow
                         (let _0_471 =
                            FStar_Syntax_Syntax.mk_Total (star_type' env hn)
                             in
                          (binders, _0_471)))
                | M a ->
                    mk
                      (FStar_Syntax_Syntax.Tm_arrow
                         (let _0_477 =
                            let _0_475 =
                              let _0_474 =
                                let _0_473 =
                                  FStar_Syntax_Syntax.null_bv
                                    (mk_star_to_type env a)
                                   in
                                let _0_472 =
                                  FStar_Syntax_Syntax.as_implicit false  in
                                (_0_473, _0_472)  in
                              [_0_474]  in
                            FStar_List.append binders _0_475  in
                          let _0_476 =
                            FStar_Syntax_Syntax.mk_Total
                              FStar_Syntax_Util.ktype0
                             in
                          (_0_477, _0_476)))))
      | FStar_Syntax_Syntax.Tm_app (head,args) ->
          let debug t s =
            let string_of_set f s =
              let elts = FStar_Util.set_elements s  in
              match elts with
              | [] -> "{}"
              | x::xs ->
                  let strb = FStar_Util.new_string_builder ()  in
                  (FStar_Util.string_builder_append strb "{";
                   (let _0_478 = f x  in
                    FStar_Util.string_builder_append strb _0_478);
                   FStar_List.iter
                     (fun x  ->
                        FStar_Util.string_builder_append strb ", ";
                        (let _0_479 = f x  in
                         FStar_Util.string_builder_append strb _0_479)) xs;
                   FStar_Util.string_builder_append strb "}";
                   FStar_Util.string_of_string_builder strb)
               in
            let _0_481 = FStar_Syntax_Print.term_to_string t  in
            let _0_480 = string_of_set FStar_Syntax_Print.bv_to_string s  in
            FStar_Util.print2_warning "Dependency found in term %s : %s"
              _0_481 _0_480
             in
          let rec is_non_dependent_arrow ty n =
            let uu____1499 =
              (FStar_Syntax_Subst.compress ty).FStar_Syntax_Syntax.n  in
            match uu____1499 with
            | FStar_Syntax_Syntax.Tm_arrow (binders,c) ->
                let uu____1512 =
                  Prims.op_Negation (FStar_Syntax_Util.is_tot_or_gtot_comp c)
                   in
                if uu____1512
                then false
                else
                  (try
                     let non_dependent_or_raise s ty =
                       let sinter =
                         let _0_482 = FStar_Syntax_Free.names ty  in
                         FStar_Util.set_intersect _0_482 s  in
                       let uu____1526 =
                         Prims.op_Negation (FStar_Util.set_is_empty sinter)
                          in
                       if uu____1526
                       then (debug ty sinter; Prims.raise Not_found)
                       else ()  in
                     let uu____1529 = FStar_Syntax_Subst.open_comp binders c
                        in
                     match uu____1529 with
                     | (binders,c) ->
                         let s =
                           FStar_List.fold_left
                             (fun s  ->
                                fun uu____1540  ->
                                  match uu____1540 with
                                  | (bv,uu____1546) ->
                                      (non_dependent_or_raise s
                                         bv.FStar_Syntax_Syntax.sort;
                                       FStar_Util.set_add bv s))
                             FStar_Syntax_Syntax.no_names binders
                            in
                         let ct = FStar_Syntax_Util.comp_result c  in
                         (non_dependent_or_raise s ct;
                          (let k = n - (FStar_List.length binders)  in
                           if k > (Prims.parse_int "0")
                           then is_non_dependent_arrow ct k
                           else true))
                   with | Not_found  -> false)
            | uu____1559 ->
                ((let _0_483 = FStar_Syntax_Print.term_to_string ty  in
                  FStar_Util.print1_warning "Not a dependent arrow : %s"
                    _0_483);
                 false)
             in
          let rec is_valid_application head =
            let uu____1565 =
              (FStar_Syntax_Subst.compress head).FStar_Syntax_Syntax.n  in
            match uu____1565 with
            | FStar_Syntax_Syntax.Tm_fvar fv when
                (((FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Syntax_Const.option_lid)
                    ||
                    (FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Syntax_Const.either_lid))
                   ||
                   (FStar_Syntax_Syntax.fv_eq_lid fv
                      FStar_Syntax_Const.eq2_lid))
                  ||
                  (FStar_Syntax_Util.is_tuple_constructor
                     (FStar_Syntax_Subst.compress head))
                -> true
            | FStar_Syntax_Syntax.Tm_fvar fv when
                is_non_dependent_arrow
                  (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.ty
                  (FStar_List.length args)
                ->
                let res =
                  FStar_TypeChecker_Normalize.normalize
                    [FStar_TypeChecker_Normalize.Inlining;
                    FStar_TypeChecker_Normalize.UnfoldUntil
                      FStar_Syntax_Syntax.Delta_constant] env.env t
                   in
                (match res.FStar_Syntax_Syntax.n with
                 | FStar_Syntax_Syntax.Tm_app uu____1579 -> true
                 | uu____1589 ->
                     ((let _0_484 = FStar_Syntax_Print.term_to_string head
                          in
                       FStar_Util.print1_warning
                         "Got a term which might be a non-dependent user-defined data-type %s\n"
                         _0_484);
                      false))
            | FStar_Syntax_Syntax.Tm_bvar _|FStar_Syntax_Syntax.Tm_name _ ->
                true
            | FStar_Syntax_Syntax.Tm_uinst (t,uu____1594) ->
                is_valid_application t
            | uu____1599 -> false  in
          let uu____1600 = is_valid_application head  in
          if uu____1600
          then
            mk
              (FStar_Syntax_Syntax.Tm_app
                 (let _0_486 =
                    FStar_List.map
                      (fun uu____1612  ->
                         match uu____1612 with
                         | (t,qual) ->
                             let _0_485 = star_type' env t  in (_0_485, qual))
                      args
                     in
                  (head, _0_486)))
          else
            Prims.raise
              (FStar_Errors.Err
                 (let _0_487 = FStar_Syntax_Print.term_to_string t  in
                  FStar_Util.format1
                    "For now, only [either], [option] and [eq2] are supported in the definition language (got: %s)"
                    _0_487))
      | FStar_Syntax_Syntax.Tm_bvar _
        |FStar_Syntax_Syntax.Tm_name _
         |FStar_Syntax_Syntax.Tm_type _|FStar_Syntax_Syntax.Tm_fvar _ -> t
      | FStar_Syntax_Syntax.Tm_abs (binders,repr,something) ->
          let uu____1655 = FStar_Syntax_Subst.open_term binders repr  in
          (match uu____1655 with
           | (binders,repr) ->
               let env =
                 let uu___102_1661 = env  in
                 let _0_488 =
                   FStar_TypeChecker_Env.push_binders env.env binders  in
                 {
                   env = _0_488;
                   subst = (uu___102_1661.subst);
                   tc_const = (uu___102_1661.tc_const)
                 }  in
               let repr = star_type' env repr  in
               FStar_Syntax_Util.abs binders repr something)
      | FStar_Syntax_Syntax.Tm_refine (x,t) when false ->
          let x = FStar_Syntax_Syntax.freshen_bv x  in
          let sort = star_type' env x.FStar_Syntax_Syntax.sort  in
          let subst = [FStar_Syntax_Syntax.DB ((Prims.parse_int "0"), x)]  in
          let t = FStar_Syntax_Subst.subst subst t  in
          let t = star_type' env t  in
          let subst = [FStar_Syntax_Syntax.NM (x, (Prims.parse_int "0"))]  in
          let t = FStar_Syntax_Subst.subst subst t  in
          mk
            (FStar_Syntax_Syntax.Tm_refine
               ((let uu___103_1678 = x  in
                 {
                   FStar_Syntax_Syntax.ppname =
                     (uu___103_1678.FStar_Syntax_Syntax.ppname);
                   FStar_Syntax_Syntax.index =
                     (uu___103_1678.FStar_Syntax_Syntax.index);
                   FStar_Syntax_Syntax.sort = sort
                 }), t))
      | FStar_Syntax_Syntax.Tm_meta (t,m) ->
          mk
            (FStar_Syntax_Syntax.Tm_meta
               (let _0_489 = star_type' env t  in (_0_489, m)))
      | FStar_Syntax_Syntax.Tm_ascribed (e,FStar_Util.Inl t,something) ->
          mk
            (FStar_Syntax_Syntax.Tm_ascribed
               (let _0_491 = star_type' env e  in
                let _0_490 = FStar_Util.Inl (star_type' env t)  in
                (_0_491, _0_490, something)))
      | FStar_Syntax_Syntax.Tm_ascribed uu____1713 ->
          Prims.raise
            (FStar_Errors.Err
               (let _0_492 = FStar_Syntax_Print.term_to_string t  in
                FStar_Util.format1
                  "Tm_ascribed is outside of the definition language: %s"
                  _0_492))
      | FStar_Syntax_Syntax.Tm_refine uu____1726 ->
          Prims.raise
            (FStar_Errors.Err
               (let _0_493 = FStar_Syntax_Print.term_to_string t  in
                FStar_Util.format1
                  "Tm_refine is outside of the definition language: %s"
                  _0_493))
      | FStar_Syntax_Syntax.Tm_uinst uu____1731 ->
          Prims.raise
            (FStar_Errors.Err
               (let _0_494 = FStar_Syntax_Print.term_to_string t  in
                FStar_Util.format1
                  "Tm_uinst is outside of the definition language: %s" _0_494))
      | FStar_Syntax_Syntax.Tm_constant uu____1736 ->
          Prims.raise
            (FStar_Errors.Err
               (let _0_495 = FStar_Syntax_Print.term_to_string t  in
                FStar_Util.format1
                  "Tm_constant is outside of the definition language: %s"
                  _0_495))
      | FStar_Syntax_Syntax.Tm_match uu____1737 ->
          Prims.raise
            (FStar_Errors.Err
               (let _0_496 = FStar_Syntax_Print.term_to_string t  in
                FStar_Util.format1
                  "Tm_match is outside of the definition language: %s" _0_496))
      | FStar_Syntax_Syntax.Tm_let uu____1753 ->
          Prims.raise
            (FStar_Errors.Err
               (let _0_497 = FStar_Syntax_Print.term_to_string t  in
                FStar_Util.format1
                  "Tm_let is outside of the definition language: %s" _0_497))
      | FStar_Syntax_Syntax.Tm_uvar uu____1761 ->
          Prims.raise
            (FStar_Errors.Err
               (let _0_498 = FStar_Syntax_Print.term_to_string t  in
                FStar_Util.format1
                  "Tm_uvar is outside of the definition language: %s" _0_498))
      | FStar_Syntax_Syntax.Tm_unknown  ->
          Prims.raise
            (FStar_Errors.Err
               (let _0_499 = FStar_Syntax_Print.term_to_string t  in
                FStar_Util.format1
                  "Tm_unknown is outside of the definition language: %s"
                  _0_499))
      | FStar_Syntax_Syntax.Tm_delayed uu____1770 -> failwith "impossible"

let is_monadic uu___88_1803 =
  match uu___88_1803 with
  | None  -> failwith "un-annotated lambda?!"
  | Some (FStar_Util.Inl
    { FStar_Syntax_Syntax.eff_name = _; FStar_Syntax_Syntax.res_typ = _;
      FStar_Syntax_Syntax.cflags = flags; FStar_Syntax_Syntax.comp = _;_})
    |Some (FStar_Util.Inr (_,flags)) ->
      FStar_All.pipe_right flags
        (FStar_Util.for_some
           (fun uu___87_1840  ->
              match uu___87_1840 with
              | FStar_Syntax_Syntax.CPS  -> true
              | uu____1841 -> false))
  
let rec is_C : FStar_Syntax_Syntax.typ -> Prims.bool =
  fun t  ->
    let uu____1845 = (FStar_Syntax_Subst.compress t).FStar_Syntax_Syntax.n
       in
    match uu____1845 with
    | FStar_Syntax_Syntax.Tm_app (head,args) when
        FStar_Syntax_Util.is_tuple_constructor head ->
        let r = is_C (Prims.fst (FStar_List.hd args))  in
        if r
        then
          ((let uu____1870 =
              Prims.op_Negation
                (FStar_List.for_all
                   (fun uu____1873  ->
                      match uu____1873 with | (h,uu____1877) -> is_C h) args)
               in
            if uu____1870 then failwith "not a C (A * C)" else ());
           true)
        else
          ((let uu____1881 =
              Prims.op_Negation
                (FStar_List.for_all
                   (fun uu____1884  ->
                      match uu____1884 with
                      | (h,uu____1888) -> Prims.op_Negation (is_C h)) args)
               in
            if uu____1881 then failwith "not a C (C * A)" else ());
           false)
    | FStar_Syntax_Syntax.Tm_arrow (binders,comp) ->
        let uu____1902 = nm_of_comp comp.FStar_Syntax_Syntax.n  in
        (match uu____1902 with
         | M t ->
             ((let uu____1905 = is_C t  in
               if uu____1905 then failwith "not a C (C -> C)" else ());
              true)
         | N t -> is_C t)
    | FStar_Syntax_Syntax.Tm_meta (t,_)
      |FStar_Syntax_Syntax.Tm_uinst (t,_)|FStar_Syntax_Syntax.Tm_ascribed
       (t,_,_) -> is_C t
    | uu____1932 -> false
  
let mk_return :
  env ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  =
  fun env  ->
    fun t  ->
      fun e  ->
        let mk x = (FStar_Syntax_Syntax.mk x) None e.FStar_Syntax_Syntax.pos
           in
        let p_type = mk_star_to_type mk env t  in
        let p = FStar_Syntax_Syntax.gen_bv "p'" None p_type  in
        let body =
          mk
            (FStar_Syntax_Syntax.Tm_app
               (let _0_503 = FStar_Syntax_Syntax.bv_to_name p  in
                let _0_502 =
                  let _0_501 =
                    let _0_500 = FStar_Syntax_Syntax.as_implicit false  in
                    (e, _0_500)  in
                  [_0_501]  in
                (_0_503, _0_502)))
           in
        let _0_505 =
          let _0_504 = FStar_Syntax_Syntax.mk_binder p  in [_0_504]  in
        FStar_Syntax_Util.abs _0_505 body None
  
let is_unknown : FStar_Syntax_Syntax.term' -> Prims.bool =
  fun uu___89_1977  ->
    match uu___89_1977 with
    | FStar_Syntax_Syntax.Tm_unknown  -> true
    | uu____1978 -> false
  
let rec check :
  env ->
    FStar_Syntax_Syntax.term ->
      nm -> (nm * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun e  ->
      fun context_nm  ->
        let mk x = FStar_Syntax_Syntax.mk x None e.FStar_Syntax_Syntax.pos
           in
        let return_if uu____2122 =
          match uu____2122 with
          | (rec_nm,s_e,u_e) ->
              let check t1 t2 =
                let uu____2143 =
                  (Prims.op_Negation (is_unknown t2.FStar_Syntax_Syntax.n))
                    &&
                    (Prims.op_Negation
                       (FStar_TypeChecker_Rel.is_trivial
                          (FStar_TypeChecker_Rel.teq env.env t1 t2)))
                   in
                if uu____2143
                then
                  Prims.raise
                    (FStar_Errors.Err
                       (let _0_508 = FStar_Syntax_Print.term_to_string e  in
                        let _0_507 = FStar_Syntax_Print.term_to_string t1  in
                        let _0_506 = FStar_Syntax_Print.term_to_string t2  in
                        FStar_Util.format3
                          "[check]: the expression [%s] has type [%s] but should have type [%s]"
                          _0_508 _0_507 _0_506))
                else ()  in
              (match (rec_nm, context_nm) with
               | (N t1,N t2)|(M t1,M t2) -> (check t1 t2; (rec_nm, s_e, u_e))
               | (N t1,M t2) ->
                   (check t1 t2;
                    (let _0_509 = mk_return env t1 s_e  in
                     ((M t1), _0_509, u_e)))
               | (M t1,N t2) ->
                   Prims.raise
                     (FStar_Errors.Err
                        (let _0_512 = FStar_Syntax_Print.term_to_string e  in
                         let _0_511 = FStar_Syntax_Print.term_to_string t1
                            in
                         let _0_510 = FStar_Syntax_Print.term_to_string t2
                            in
                         FStar_Util.format3
                           "[check %s]: got an effectful computation [%s] in lieu of a pure computation [%s]"
                           _0_512 _0_511 _0_510)))
           in
        let ensure_m env e2 =
          let strip_m uu___90_2181 =
            match uu___90_2181 with
            | (M t,s_e,u_e) -> (t, s_e, u_e)
            | uu____2191 -> failwith "impossible"  in
          match context_nm with
          | N t ->
              Prims.raise
                (FStar_Errors.Error
                   (let _0_514 =
                      let _0_513 = FStar_Syntax_Print.term_to_string t  in
                      Prims.strcat
                        "let-bound monadic body has a non-monadic continuation or a branch of a match is monadic and the others aren't : "
                        _0_513
                       in
                    (_0_514, (e2.FStar_Syntax_Syntax.pos))))
          | M uu____2205 -> strip_m (check env e2 context_nm)  in
        let uu____2206 =
          (FStar_Syntax_Subst.compress e).FStar_Syntax_Syntax.n  in
        match uu____2206 with
        | FStar_Syntax_Syntax.Tm_bvar _
          |FStar_Syntax_Syntax.Tm_name _
           |FStar_Syntax_Syntax.Tm_fvar _
            |FStar_Syntax_Syntax.Tm_abs _
             |FStar_Syntax_Syntax.Tm_constant _|FStar_Syntax_Syntax.Tm_app _
            -> return_if (infer env e)
        | FStar_Syntax_Syntax.Tm_let ((false ,binding::[]),e2) ->
            mk_let env binding e2
              (fun env  -> fun e2  -> check env e2 context_nm) ensure_m
        | FStar_Syntax_Syntax.Tm_match (e0,branches) ->
            mk_match env e0 branches
              (fun env  -> fun body  -> check env body context_nm)
        | FStar_Syntax_Syntax.Tm_meta (e,_)
          |FStar_Syntax_Syntax.Tm_uinst (e,_)|FStar_Syntax_Syntax.Tm_ascribed
           (e,_,_) -> check env e context_nm
        | FStar_Syntax_Syntax.Tm_let uu____2282 ->
            failwith
              (let _0_515 = FStar_Syntax_Print.term_to_string e  in
               FStar_Util.format1 "[check]: Tm_let %s" _0_515)
        | FStar_Syntax_Syntax.Tm_type uu____2293 ->
            failwith "impossible (DM stratification)"
        | FStar_Syntax_Syntax.Tm_arrow uu____2297 ->
            failwith "impossible (DM stratification)"
        | FStar_Syntax_Syntax.Tm_refine uu____2308 ->
            failwith
              (let _0_516 = FStar_Syntax_Print.term_to_string e  in
               FStar_Util.format1 "[check]: Tm_refine %s" _0_516)
        | FStar_Syntax_Syntax.Tm_uvar uu____2316 ->
            failwith
              (let _0_517 = FStar_Syntax_Print.term_to_string e  in
               FStar_Util.format1 "[check]: Tm_uvar %s" _0_517)
        | FStar_Syntax_Syntax.Tm_delayed uu____2328 ->
            failwith "impossible (compressed)"
        | FStar_Syntax_Syntax.Tm_unknown  ->
            failwith
              (let _0_518 = FStar_Syntax_Print.term_to_string e  in
               FStar_Util.format1 "[check]: Tm_unknown %s" _0_518)

and infer :
  env ->
    FStar_Syntax_Syntax.term ->
      (nm * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun e  ->
      let mk x = FStar_Syntax_Syntax.mk x None e.FStar_Syntax_Syntax.pos  in
      let normalize =
        FStar_TypeChecker_Normalize.normalize
          [FStar_TypeChecker_Normalize.Beta;
          FStar_TypeChecker_Normalize.Eager_unfolding;
          FStar_TypeChecker_Normalize.UnfoldUntil
            FStar_Syntax_Syntax.Delta_constant;
          FStar_TypeChecker_Normalize.EraseUniverses] env.env
         in
      let uu____2373 = (FStar_Syntax_Subst.compress e).FStar_Syntax_Syntax.n
         in
      match uu____2373 with
      | FStar_Syntax_Syntax.Tm_bvar bv ->
          failwith "I failed to open a binder... boo"
      | FStar_Syntax_Syntax.Tm_name bv ->
          ((N (bv.FStar_Syntax_Syntax.sort)), e, e)
      | FStar_Syntax_Syntax.Tm_abs (binders,body,what) ->
          let binders = FStar_Syntax_Subst.open_binders binders  in
          let subst = FStar_Syntax_Subst.opening_of_binders binders  in
          let body = FStar_Syntax_Subst.subst subst body  in
          let env =
            let uu___104_2411 = env  in
            let _0_519 = FStar_TypeChecker_Env.push_binders env.env binders
               in
            {
              env = _0_519;
              subst = (uu___104_2411.subst);
              tc_const = (uu___104_2411.tc_const)
            }  in
          let s_binders =
            FStar_List.map
              (fun uu____2420  ->
                 match uu____2420 with
                 | (bv,qual) ->
                     let sort = star_type' env bv.FStar_Syntax_Syntax.sort
                        in
                     ((let uu___105_2428 = bv  in
                       {
                         FStar_Syntax_Syntax.ppname =
                           (uu___105_2428.FStar_Syntax_Syntax.ppname);
                         FStar_Syntax_Syntax.index =
                           (uu___105_2428.FStar_Syntax_Syntax.index);
                         FStar_Syntax_Syntax.sort = sort
                       }), qual)) binders
             in
          let uu____2429 =
            FStar_List.fold_left
              (fun uu____2438  ->
                 fun uu____2439  ->
                   match (uu____2438, uu____2439) with
                   | ((env,acc),(bv,qual)) ->
                       let c = bv.FStar_Syntax_Syntax.sort  in
                       let uu____2467 = is_C c  in
                       if uu____2467
                       then
                         let xw =
                           let _0_520 = star_type' env c  in
                           FStar_Syntax_Syntax.gen_bv
                             (Prims.strcat
                                (bv.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                "^w") None _0_520
                            in
                         let x =
                           let uu___106_2473 = bv  in
                           let _0_522 =
                             let _0_521 = FStar_Syntax_Syntax.bv_to_name xw
                                in
                             trans_F_ env c _0_521  in
                           {
                             FStar_Syntax_Syntax.ppname =
                               (uu___106_2473.FStar_Syntax_Syntax.ppname);
                             FStar_Syntax_Syntax.index =
                               (uu___106_2473.FStar_Syntax_Syntax.index);
                             FStar_Syntax_Syntax.sort = _0_522
                           }  in
                         let env =
                           let uu___107_2475 = env  in
                           let _0_525 =
                             let _0_524 =
                               FStar_Syntax_Syntax.NT
                                 (let _0_523 =
                                    FStar_Syntax_Syntax.bv_to_name xw  in
                                  (bv, _0_523))
                                in
                             _0_524 :: (env.subst)  in
                           {
                             env = (uu___107_2475.env);
                             subst = _0_525;
                             tc_const = (uu___107_2475.tc_const)
                           }  in
                         let _0_529 =
                           let _0_528 = FStar_Syntax_Syntax.mk_binder x  in
                           let _0_527 =
                             let _0_526 = FStar_Syntax_Syntax.mk_binder xw
                                in
                             _0_526 :: acc  in
                           _0_528 :: _0_527  in
                         (env, _0_529)
                       else
                         (let x =
                            let uu___108_2479 = bv  in
                            let _0_530 =
                              star_type' env bv.FStar_Syntax_Syntax.sort  in
                            {
                              FStar_Syntax_Syntax.ppname =
                                (uu___108_2479.FStar_Syntax_Syntax.ppname);
                              FStar_Syntax_Syntax.index =
                                (uu___108_2479.FStar_Syntax_Syntax.index);
                              FStar_Syntax_Syntax.sort = _0_530
                            }  in
                          let _0_532 =
                            let _0_531 = FStar_Syntax_Syntax.mk_binder x  in
                            _0_531 :: acc  in
                          (env, _0_532))) (env, []) binders
             in
          (match uu____2429 with
           | (env,u_binders) ->
               let u_binders = FStar_List.rev u_binders  in
               let uu____2491 =
                 let check_what =
                   let uu____2503 = is_monadic what  in
                   if uu____2503 then check_m else check_n  in
                 let uu____2512 = check_what env body  in
                 match uu____2512 with
                 | (t,s_body,u_body) ->
                     let _0_533 =
                       comp_of_nm
                         (let uu____2522 = is_monadic what  in
                          if uu____2522 then M t else N t)
                        in
                     (_0_533, s_body, u_body)
                  in
               (match uu____2491 with
                | (comp,s_body,u_body) ->
                    let t = FStar_Syntax_Util.arrow binders comp  in
                    let s_what =
                      match what with
                      | None  -> None
                      | Some (FStar_Util.Inl lc) ->
                          let uu____2565 =
                            FStar_All.pipe_right
                              lc.FStar_Syntax_Syntax.cflags
                              (FStar_Util.for_some
                                 (fun uu___91_2567  ->
                                    match uu___91_2567 with
                                    | FStar_Syntax_Syntax.CPS  -> true
                                    | uu____2568 -> false))
                             in
                          if uu____2565
                          then
                            let double_starred_comp =
                              FStar_Syntax_Syntax.mk_Total
                                (let _0_534 =
                                   FStar_Syntax_Util.comp_result
                                     (lc.FStar_Syntax_Syntax.comp ())
                                    in
                                 FStar_All.pipe_left double_star _0_534)
                               in
                            let flags =
                              FStar_List.filter
                                (fun uu___92_2578  ->
                                   match uu___92_2578 with
                                   | FStar_Syntax_Syntax.CPS  -> false
                                   | uu____2579 -> true)
                                lc.FStar_Syntax_Syntax.cflags
                               in
                            Some
                              (FStar_Util.Inl
                                 (FStar_Syntax_Util.lcomp_of_comp
                                    (FStar_Syntax_Util.comp_set_flags
                                       double_starred_comp flags)))
                          else
                            Some
                              (FStar_Util.Inl
                                 ((let uu___109_2597 = lc  in
                                   {
                                     FStar_Syntax_Syntax.eff_name =
                                       (uu___109_2597.FStar_Syntax_Syntax.eff_name);
                                     FStar_Syntax_Syntax.res_typ =
                                       (uu___109_2597.FStar_Syntax_Syntax.res_typ);
                                     FStar_Syntax_Syntax.cflags =
                                       (uu___109_2597.FStar_Syntax_Syntax.cflags);
                                     FStar_Syntax_Syntax.comp =
                                       (fun uu____2598  ->
                                          let c =
                                            lc.FStar_Syntax_Syntax.comp ()
                                             in
                                          let result_typ =
                                            star_type' env
                                              (FStar_Syntax_Util.comp_result
                                                 c)
                                             in
                                          FStar_Syntax_Util.set_result_typ c
                                            result_typ)
                                   })))
                      | Some (FStar_Util.Inr (lid,flags)) ->
                          Some
                            (FStar_Util.Inr
                               (let uu____2623 =
                                  FStar_All.pipe_right flags
                                    (FStar_Util.for_some
                                       (fun uu___93_2625  ->
                                          match uu___93_2625 with
                                          | FStar_Syntax_Syntax.CPS  -> true
                                          | uu____2626 -> false))
                                   in
                                if uu____2623
                                then
                                  let _0_535 =
                                    FStar_List.filter
                                      (fun uu___94_2631  ->
                                         match uu___94_2631 with
                                         | FStar_Syntax_Syntax.CPS  -> false
                                         | uu____2632 -> true) flags
                                     in
                                  (FStar_Syntax_Const.effect_Tot_lid, _0_535)
                                else (lid, flags)))
                       in
                    let uu____2635 =
                      let comp =
                        let _0_537 = is_monadic what  in
                        let _0_536 =
                          FStar_Syntax_Subst.subst env.subst s_body  in
                        trans_G env (FStar_Syntax_Util.comp_result comp)
                          _0_537 _0_536
                         in
                      let _0_538 =
                        FStar_Syntax_Util.ascribe u_body
                          (FStar_Util.Inr comp)
                         in
                      (_0_538,
                        (Some
                           (FStar_Util.Inl
                              (FStar_Syntax_Util.lcomp_of_comp comp))))
                       in
                    (match uu____2635 with
                     | (u_body,u_what) ->
                         let s_body =
                           FStar_Syntax_Subst.close s_binders s_body  in
                         let s_binders =
                           FStar_Syntax_Subst.close_binders s_binders  in
                         let s_term =
                           mk
                             (FStar_Syntax_Syntax.Tm_abs
                                (s_binders, s_body, s_what))
                            in
                         let u_body =
                           FStar_Syntax_Subst.close u_binders u_body  in
                         let u_binders =
                           FStar_Syntax_Subst.close_binders u_binders  in
                         let u_term =
                           mk
                             (FStar_Syntax_Syntax.Tm_abs
                                (u_binders, u_body, u_what))
                            in
                         ((N t), s_term, u_term))))
      | FStar_Syntax_Syntax.Tm_fvar
          {
            FStar_Syntax_Syntax.fv_name =
              { FStar_Syntax_Syntax.v = lid;
                FStar_Syntax_Syntax.ty = uu____2713;
                FStar_Syntax_Syntax.p = uu____2714;_};
            FStar_Syntax_Syntax.fv_delta = uu____2715;
            FStar_Syntax_Syntax.fv_qual = uu____2716;_}
          ->
          let uu____2722 = FStar_TypeChecker_Env.lookup_lid env.env lid  in
          (match uu____2722 with
           | (uu____2728,t) ->
               let txt = FStar_Ident.text_of_lid lid  in
               let _0_539 = N (normalize t)  in (_0_539, e, e))
      | FStar_Syntax_Syntax.Tm_app (head,args) ->
          let uu____2747 = check_n env head  in
          (match uu____2747 with
           | (t_head,s_head,u_head) ->
               let is_arrow t =
                 let uu____2761 =
                   (FStar_Syntax_Subst.compress t).FStar_Syntax_Syntax.n  in
                 match uu____2761 with
                 | FStar_Syntax_Syntax.Tm_arrow uu____2762 -> true
                 | uu____2770 -> false  in
               let rec flatten t =
                 let uu____2782 =
                   (FStar_Syntax_Subst.compress t).FStar_Syntax_Syntax.n  in
                 match uu____2782 with
                 | FStar_Syntax_Syntax.Tm_arrow
                     (binders,{
                                FStar_Syntax_Syntax.n =
                                  FStar_Syntax_Syntax.Total (t,uu____2792);
                                FStar_Syntax_Syntax.tk = uu____2793;
                                FStar_Syntax_Syntax.pos = uu____2794;
                                FStar_Syntax_Syntax.vars = uu____2795;_})
                     when is_arrow t ->
                     let uu____2812 = flatten t  in
                     (match uu____2812 with
                      | (binders',comp) ->
                          ((FStar_List.append binders binders'), comp))
                 | FStar_Syntax_Syntax.Tm_arrow (binders,comp) ->
                     (binders, comp)
                 | FStar_Syntax_Syntax.Tm_ascribed (e,uu____2864,uu____2865)
                     -> flatten e
                 | uu____2884 ->
                     Prims.raise
                       (FStar_Errors.Err
                          (let _0_540 =
                             FStar_Syntax_Print.term_to_string t_head  in
                           FStar_Util.format1 "%s: not a function type"
                             _0_540))
                  in
               let uu____2892 = flatten t_head  in
               (match uu____2892 with
                | (binders,comp) ->
                    let n = FStar_List.length binders  in
                    let n' = FStar_List.length args  in
                    (if
                       (FStar_List.length binders) < (FStar_List.length args)
                     then
                       Prims.raise
                         (FStar_Errors.Err
                            (let _0_543 = FStar_Util.string_of_int n  in
                             let _0_542 = FStar_Util.string_of_int (n' - n)
                                in
                             let _0_541 = FStar_Util.string_of_int n  in
                             FStar_Util.format3
                               "The head of this application, after being applied to %s arguments, is an effectful computation (leaving %s arguments to be applied). Please let-bind the head applied to the %s first arguments."
                               _0_543 _0_542 _0_541))
                     else ();
                     (let uu____2949 =
                        FStar_Syntax_Subst.open_comp binders comp  in
                      match uu____2949 with
                      | (binders,comp) ->
                          let rec final_type subst uu____2976 args =
                            match uu____2976 with
                            | (binders,comp) ->
                                (match (binders, args) with
                                 | ([],[]) ->
                                     nm_of_comp
                                       (FStar_Syntax_Subst.subst_comp subst
                                          comp).FStar_Syntax_Syntax.n
                                 | (binders,[]) ->
                                     let uu____3035 =
                                       (FStar_Syntax_Subst.compress
                                          (let _0_544 =
                                             mk
                                               (FStar_Syntax_Syntax.Tm_arrow
                                                  (binders, comp))
                                              in
                                           FStar_Syntax_Subst.subst subst
                                             _0_544)).FStar_Syntax_Syntax.n
                                        in
                                     (match uu____3035 with
                                      | FStar_Syntax_Syntax.Tm_arrow
                                          (binders,comp) ->
                                          N
                                            (mk
                                               (FStar_Syntax_Syntax.Tm_arrow
                                                  (let _0_545 =
                                                     FStar_Syntax_Subst.close_comp
                                                       binders comp
                                                      in
                                                   (binders, _0_545))))
                                      | uu____3054 -> failwith "wat?")
                                 | ([],uu____3055::uu____3056) ->
                                     failwith "just checked that?!"
                                 | ((bv,uu____3081)::binders,(arg,uu____3084)::args)
                                     ->
                                     final_type
                                       ((FStar_Syntax_Syntax.NT (bv, arg)) ::
                                       subst) (binders, comp) args)
                             in
                          let final_type = final_type [] (binders, comp) args
                             in
                          let uu____3118 = FStar_List.splitAt n' binders  in
                          (match uu____3118 with
                           | (binders,uu____3135) ->
                               let uu____3148 =
                                 FStar_List.split
                                   (FStar_List.map2
                                      (fun uu____3174  ->
                                         fun uu____3175  ->
                                           match (uu____3174, uu____3175)
                                           with
                                           | ((bv,uu____3192),(arg,q)) ->
                                               let uu____3199 =
                                                 (FStar_Syntax_Subst.compress
                                                    bv.FStar_Syntax_Syntax.sort).FStar_Syntax_Syntax.n
                                                  in
                                               (match uu____3199 with
                                                | FStar_Syntax_Syntax.Tm_type
                                                    uu____3207 ->
                                                    let arg = (arg, q)  in
                                                    (arg, [arg])
                                                | uu____3220 ->
                                                    let uu____3221 =
                                                      check_n env arg  in
                                                    (match uu____3221 with
                                                     | (uu____3232,s_arg,u_arg)
                                                         ->
                                                         let _0_548 =
                                                           let uu____3240 =
                                                             is_C
                                                               bv.FStar_Syntax_Syntax.sort
                                                              in
                                                           if uu____3240
                                                           then
                                                             let _0_547 =
                                                               let _0_546 =
                                                                 FStar_Syntax_Subst.subst
                                                                   env.subst
                                                                   s_arg
                                                                  in
                                                               (_0_546, q)
                                                                in
                                                             [_0_547;
                                                             (u_arg, q)]
                                                           else [(u_arg, q)]
                                                            in
                                                         ((s_arg, q), _0_548))))
                                      binders args)
                                  in
                               (match uu____3148 with
                                | (s_args,u_args) ->
                                    let u_args = FStar_List.flatten u_args
                                       in
                                    let _0_550 =
                                      mk
                                        (FStar_Syntax_Syntax.Tm_app
                                           (s_head, s_args))
                                       in
                                    let _0_549 =
                                      mk
                                        (FStar_Syntax_Syntax.Tm_app
                                           (u_head, u_args))
                                       in
                                    (final_type, _0_550, _0_549)))))))
      | FStar_Syntax_Syntax.Tm_let ((false ,binding::[]),e2) ->
          mk_let env binding e2 infer check_m
      | FStar_Syntax_Syntax.Tm_match (e0,branches) ->
          mk_match env e0 branches infer
      | FStar_Syntax_Syntax.Tm_uinst (e,_)
        |FStar_Syntax_Syntax.Tm_meta (e,_)|FStar_Syntax_Syntax.Tm_ascribed
         (e,_,_) -> infer env e
      | FStar_Syntax_Syntax.Tm_constant c ->
          let _0_551 = N (env.tc_const c)  in (_0_551, e, e)
      | FStar_Syntax_Syntax.Tm_let uu____3353 ->
          failwith
            (let _0_552 = FStar_Syntax_Print.term_to_string e  in
             FStar_Util.format1 "[infer]: Tm_let %s" _0_552)
      | FStar_Syntax_Syntax.Tm_type uu____3364 ->
          failwith "impossible (DM stratification)"
      | FStar_Syntax_Syntax.Tm_arrow uu____3368 ->
          failwith "impossible (DM stratification)"
      | FStar_Syntax_Syntax.Tm_refine uu____3379 ->
          failwith
            (let _0_553 = FStar_Syntax_Print.term_to_string e  in
             FStar_Util.format1 "[infer]: Tm_refine %s" _0_553)
      | FStar_Syntax_Syntax.Tm_uvar uu____3387 ->
          failwith
            (let _0_554 = FStar_Syntax_Print.term_to_string e  in
             FStar_Util.format1 "[infer]: Tm_uvar %s" _0_554)
      | FStar_Syntax_Syntax.Tm_delayed uu____3399 ->
          failwith "impossible (compressed)"
      | FStar_Syntax_Syntax.Tm_unknown  ->
          failwith
            (let _0_555 = FStar_Syntax_Print.term_to_string e  in
             FStar_Util.format1 "[infer]: Tm_unknown %s" _0_555)

and mk_match :
  env ->
    (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax ->
      ((FStar_Syntax_Syntax.pat',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.withinfo_t *
        (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax Prims.option *
        (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
        FStar_Syntax_Syntax.syntax) Prims.list ->
        (env ->
           FStar_Syntax_Syntax.term ->
             (nm * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term))
          -> (nm * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun e0  ->
      fun branches  ->
        fun f  ->
          let mk x = FStar_Syntax_Syntax.mk x None e0.FStar_Syntax_Syntax.pos
             in
          let uu____3460 = check_n env e0  in
          match uu____3460 with
          | (uu____3467,s_e0,u_e0) ->
              let uu____3470 =
                FStar_List.split
                  (FStar_List.map
                     (fun b  ->
                        let uu____3517 = FStar_Syntax_Subst.open_branch b  in
                        match uu____3517 with
                        | (pat,None ,body) ->
                            let env =
                              let uu___110_3549 = env  in
                              let _0_557 =
                                let _0_556 = FStar_Syntax_Syntax.pat_bvs pat
                                   in
                                FStar_List.fold_left
                                  FStar_TypeChecker_Env.push_bv env.env
                                  _0_556
                                 in
                              {
                                env = _0_557;
                                subst = (uu___110_3549.subst);
                                tc_const = (uu___110_3549.tc_const)
                              }  in
                            let uu____3550 = f env body  in
                            (match uu____3550 with
                             | (nm,s_body,u_body) ->
                                 (nm, (pat, None, (s_body, u_body, body))))
                        | uu____3599 ->
                            Prims.raise
                              (FStar_Errors.Err
                                 "No when clauses in the definition language"))
                     branches)
                 in
              (match uu____3470 with
               | (nms,branches) ->
                   let t1 =
                     let uu____3651 = FStar_List.hd nms  in
                     match uu____3651 with | M t1|N t1 -> t1  in
                   let has_m =
                     FStar_List.existsb
                       (fun uu___95_3654  ->
                          match uu___95_3654 with
                          | M uu____3655 -> true
                          | uu____3656 -> false) nms
                      in
                   let uu____3657 =
                     FStar_List.unzip3
                       (FStar_List.map2
                          (fun nm  ->
                             fun uu____3727  ->
                               match uu____3727 with
                               | (pat,guard,(s_body,u_body,original_body)) ->
                                   (match (nm, has_m) with
                                    | (N t2,false )|(M t2,true ) ->
                                        (nm, (pat, guard, s_body),
                                          (pat, guard, u_body))
                                    | (N t2,true ) ->
                                        let uu____3823 =
                                          check env original_body (M t2)  in
                                        (match uu____3823 with
                                         | (uu____3846,s_body,u_body) ->
                                             ((M t2), (pat, guard, s_body),
                                               (pat, guard, u_body)))
                                    | (M uu____3875,false ) ->
                                        failwith "impossible")) nms branches)
                      in
                   (match uu____3657 with
                    | (nms,s_branches,u_branches) ->
                        if has_m
                        then
                          let p_type = mk_star_to_type mk env t1  in
                          let p =
                            FStar_Syntax_Syntax.gen_bv "p''" None p_type  in
                          let s_branches =
                            FStar_List.map
                              (fun uu____3978  ->
                                 match uu____3978 with
                                 | (pat,guard,s_body) ->
                                     let s_body =
                                       mk
                                         (FStar_Syntax_Syntax.Tm_app
                                            (let _0_561 =
                                               let _0_560 =
                                                 let _0_559 =
                                                   FStar_Syntax_Syntax.bv_to_name
                                                     p
                                                    in
                                                 let _0_558 =
                                                   FStar_Syntax_Syntax.as_implicit
                                                     false
                                                    in
                                                 (_0_559, _0_558)  in
                                               [_0_560]  in
                                             (s_body, _0_561)))
                                        in
                                     (pat, guard, s_body)) s_branches
                             in
                          let s_branches =
                            FStar_List.map FStar_Syntax_Subst.close_branch
                              s_branches
                             in
                          let u_branches =
                            FStar_List.map FStar_Syntax_Subst.close_branch
                              u_branches
                             in
                          let s_e =
                            let _0_564 =
                              let _0_562 = FStar_Syntax_Syntax.mk_binder p
                                 in
                              [_0_562]  in
                            let _0_563 =
                              mk
                                (FStar_Syntax_Syntax.Tm_match
                                   (s_e0, s_branches))
                               in
                            FStar_Syntax_Util.abs _0_564 _0_563 None  in
                          let t1_star =
                            let _0_568 =
                              let _0_566 =
                                let _0_565 =
                                  FStar_Syntax_Syntax.new_bv None p_type  in
                                FStar_All.pipe_left
                                  FStar_Syntax_Syntax.mk_binder _0_565
                                 in
                              [_0_566]  in
                            let _0_567 =
                              FStar_Syntax_Syntax.mk_Total
                                FStar_Syntax_Util.ktype0
                               in
                            FStar_Syntax_Util.arrow _0_568 _0_567  in
                          let _0_570 =
                            mk
                              (FStar_Syntax_Syntax.Tm_ascribed
                                 (s_e, (FStar_Util.Inl t1_star), None))
                             in
                          let _0_569 =
                            mk
                              (FStar_Syntax_Syntax.Tm_match
                                 (u_e0, u_branches))
                             in
                          ((M t1), _0_570, _0_569)
                        else
                          (let s_branches =
                             FStar_List.map FStar_Syntax_Subst.close_branch
                               s_branches
                              in
                           let u_branches =
                             FStar_List.map FStar_Syntax_Subst.close_branch
                               u_branches
                              in
                           let t1_star = t1  in
                           let _0_573 =
                             mk
                               (FStar_Syntax_Syntax.Tm_ascribed
                                  (let _0_571 =
                                     mk
                                       (FStar_Syntax_Syntax.Tm_match
                                          (s_e0, s_branches))
                                      in
                                   (_0_571, (FStar_Util.Inl t1_star), None)))
                              in
                           let _0_572 =
                             mk
                               (FStar_Syntax_Syntax.Tm_match
                                  (u_e0, u_branches))
                              in
                           ((N t1), _0_573, _0_572))))

and mk_let :
  env_ ->
    FStar_Syntax_Syntax.letbinding ->
      FStar_Syntax_Syntax.term ->
        (env_ ->
           FStar_Syntax_Syntax.term ->
             (nm * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term))
          ->
          (env_ ->
             FStar_Syntax_Syntax.term ->
               (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term *
                 FStar_Syntax_Syntax.term))
            -> (nm * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun binding  ->
      fun e2  ->
        fun proceed  ->
          fun ensure_m  ->
            let mk x =
              FStar_Syntax_Syntax.mk x None e2.FStar_Syntax_Syntax.pos  in
            let e1 = binding.FStar_Syntax_Syntax.lbdef  in
            let x = FStar_Util.left binding.FStar_Syntax_Syntax.lbname  in
            let x_binders =
              let _0_574 = FStar_Syntax_Syntax.mk_binder x  in [_0_574]  in
            let uu____4121 = FStar_Syntax_Subst.open_term x_binders e2  in
            match uu____4121 with
            | (x_binders,e2) ->
                let uu____4129 = infer env e1  in
                (match uu____4129 with
                 | (N t1,s_e1,u_e1) ->
                     let u_binding =
                       let uu____4140 = is_C t1  in
                       if uu____4140
                       then
                         let uu___111_4141 = binding  in
                         let _0_576 =
                           let _0_575 =
                             FStar_Syntax_Subst.subst env.subst s_e1  in
                           trans_F_ env t1 _0_575  in
                         {
                           FStar_Syntax_Syntax.lbname =
                             (uu___111_4141.FStar_Syntax_Syntax.lbname);
                           FStar_Syntax_Syntax.lbunivs =
                             (uu___111_4141.FStar_Syntax_Syntax.lbunivs);
                           FStar_Syntax_Syntax.lbtyp = _0_576;
                           FStar_Syntax_Syntax.lbeff =
                             (uu___111_4141.FStar_Syntax_Syntax.lbeff);
                           FStar_Syntax_Syntax.lbdef =
                             (uu___111_4141.FStar_Syntax_Syntax.lbdef)
                         }
                       else binding  in
                     let env =
                       let uu___112_4144 = env  in
                       let _0_577 =
                         FStar_TypeChecker_Env.push_bv env.env
                           (let uu___113_4145 = x  in
                            {
                              FStar_Syntax_Syntax.ppname =
                                (uu___113_4145.FStar_Syntax_Syntax.ppname);
                              FStar_Syntax_Syntax.index =
                                (uu___113_4145.FStar_Syntax_Syntax.index);
                              FStar_Syntax_Syntax.sort = t1
                            })
                          in
                       {
                         env = _0_577;
                         subst = (uu___112_4144.subst);
                         tc_const = (uu___112_4144.tc_const)
                       }  in
                     let uu____4146 = proceed env e2  in
                     (match uu____4146 with
                      | (nm_rec,s_e2,u_e2) ->
                          let s_binding =
                            let uu___114_4157 = binding  in
                            let _0_578 =
                              star_type' env
                                binding.FStar_Syntax_Syntax.lbtyp
                               in
                            {
                              FStar_Syntax_Syntax.lbname =
                                (uu___114_4157.FStar_Syntax_Syntax.lbname);
                              FStar_Syntax_Syntax.lbunivs =
                                (uu___114_4157.FStar_Syntax_Syntax.lbunivs);
                              FStar_Syntax_Syntax.lbtyp = _0_578;
                              FStar_Syntax_Syntax.lbeff =
                                (uu___114_4157.FStar_Syntax_Syntax.lbeff);
                              FStar_Syntax_Syntax.lbdef =
                                (uu___114_4157.FStar_Syntax_Syntax.lbdef)
                            }  in
                          let _0_582 =
                            mk
                              (FStar_Syntax_Syntax.Tm_let
                                 (let _0_579 =
                                    FStar_Syntax_Subst.close x_binders s_e2
                                     in
                                  ((false,
                                     [(let uu___115_4166 = s_binding  in
                                       {
                                         FStar_Syntax_Syntax.lbname =
                                           (uu___115_4166.FStar_Syntax_Syntax.lbname);
                                         FStar_Syntax_Syntax.lbunivs =
                                           (uu___115_4166.FStar_Syntax_Syntax.lbunivs);
                                         FStar_Syntax_Syntax.lbtyp =
                                           (uu___115_4166.FStar_Syntax_Syntax.lbtyp);
                                         FStar_Syntax_Syntax.lbeff =
                                           (uu___115_4166.FStar_Syntax_Syntax.lbeff);
                                         FStar_Syntax_Syntax.lbdef = s_e1
                                       })]), _0_579)))
                             in
                          let _0_581 =
                            mk
                              (FStar_Syntax_Syntax.Tm_let
                                 (let _0_580 =
                                    FStar_Syntax_Subst.close x_binders u_e2
                                     in
                                  ((false,
                                     [(let uu___116_4171 = u_binding  in
                                       {
                                         FStar_Syntax_Syntax.lbname =
                                           (uu___116_4171.FStar_Syntax_Syntax.lbname);
                                         FStar_Syntax_Syntax.lbunivs =
                                           (uu___116_4171.FStar_Syntax_Syntax.lbunivs);
                                         FStar_Syntax_Syntax.lbtyp =
                                           (uu___116_4171.FStar_Syntax_Syntax.lbtyp);
                                         FStar_Syntax_Syntax.lbeff =
                                           (uu___116_4171.FStar_Syntax_Syntax.lbeff);
                                         FStar_Syntax_Syntax.lbdef = u_e1
                                       })]), _0_580)))
                             in
                          (nm_rec, _0_582, _0_581))
                 | (M t1,s_e1,u_e1) ->
                     let u_binding =
                       let uu___117_4176 = binding  in
                       {
                         FStar_Syntax_Syntax.lbname =
                           (uu___117_4176.FStar_Syntax_Syntax.lbname);
                         FStar_Syntax_Syntax.lbunivs =
                           (uu___117_4176.FStar_Syntax_Syntax.lbunivs);
                         FStar_Syntax_Syntax.lbtyp = t1;
                         FStar_Syntax_Syntax.lbeff =
                           FStar_Syntax_Const.effect_PURE_lid;
                         FStar_Syntax_Syntax.lbdef =
                           (uu___117_4176.FStar_Syntax_Syntax.lbdef)
                       }  in
                     let env =
                       let uu___118_4178 = env  in
                       let _0_583 =
                         FStar_TypeChecker_Env.push_bv env.env
                           (let uu___119_4179 = x  in
                            {
                              FStar_Syntax_Syntax.ppname =
                                (uu___119_4179.FStar_Syntax_Syntax.ppname);
                              FStar_Syntax_Syntax.index =
                                (uu___119_4179.FStar_Syntax_Syntax.index);
                              FStar_Syntax_Syntax.sort = t1
                            })
                          in
                       {
                         env = _0_583;
                         subst = (uu___118_4178.subst);
                         tc_const = (uu___118_4178.tc_const)
                       }  in
                     let uu____4180 = ensure_m env e2  in
                     (match uu____4180 with
                      | (t2,s_e2,u_e2) ->
                          let p_type = mk_star_to_type mk env t2  in
                          let p =
                            FStar_Syntax_Syntax.gen_bv "p''" None p_type  in
                          let s_e2 =
                            mk
                              (FStar_Syntax_Syntax.Tm_app
                                 (let _0_587 =
                                    let _0_586 =
                                      let _0_585 =
                                        FStar_Syntax_Syntax.bv_to_name p  in
                                      let _0_584 =
                                        FStar_Syntax_Syntax.as_implicit false
                                         in
                                      (_0_585, _0_584)  in
                                    [_0_586]  in
                                  (s_e2, _0_587)))
                             in
                          let s_e2 =
                            FStar_Syntax_Util.abs x_binders s_e2 None  in
                          let body =
                            mk
                              (FStar_Syntax_Syntax.Tm_app
                                 (let _0_590 =
                                    let _0_589 =
                                      let _0_588 =
                                        FStar_Syntax_Syntax.as_implicit false
                                         in
                                      (s_e2, _0_588)  in
                                    [_0_589]  in
                                  (s_e1, _0_590)))
                             in
                          let _0_595 =
                            let _0_592 =
                              let _0_591 = FStar_Syntax_Syntax.mk_binder p
                                 in
                              [_0_591]  in
                            FStar_Syntax_Util.abs _0_592 body None  in
                          let _0_594 =
                            mk
                              (FStar_Syntax_Syntax.Tm_let
                                 (let _0_593 =
                                    FStar_Syntax_Subst.close x_binders u_e2
                                     in
                                  ((false,
                                     [(let uu___120_4231 = u_binding  in
                                       {
                                         FStar_Syntax_Syntax.lbname =
                                           (uu___120_4231.FStar_Syntax_Syntax.lbname);
                                         FStar_Syntax_Syntax.lbunivs =
                                           (uu___120_4231.FStar_Syntax_Syntax.lbunivs);
                                         FStar_Syntax_Syntax.lbtyp =
                                           (uu___120_4231.FStar_Syntax_Syntax.lbtyp);
                                         FStar_Syntax_Syntax.lbeff =
                                           (uu___120_4231.FStar_Syntax_Syntax.lbeff);
                                         FStar_Syntax_Syntax.lbdef = u_e1
                                       })]), _0_593)))
                             in
                          ((M t2), _0_595, _0_594)))

and check_n :
  env_ ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.typ * FStar_Syntax_Syntax.term *
        FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun e  ->
      let mn =
        N
          (FStar_Syntax_Syntax.mk FStar_Syntax_Syntax.Tm_unknown None
             e.FStar_Syntax_Syntax.pos)
         in
      let uu____4250 = check env e mn  in
      match uu____4250 with
      | (N t,s_e,u_e) -> (t, s_e, u_e)
      | uu____4260 -> failwith "[check_n]: impossible"

and check_m :
  env_ ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.typ * FStar_Syntax_Syntax.term *
        FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun e  ->
      let mn =
        M
          (FStar_Syntax_Syntax.mk FStar_Syntax_Syntax.Tm_unknown None
             e.FStar_Syntax_Syntax.pos)
         in
      let uu____4285 = check env e mn  in
      match uu____4285 with
      | (M t,s_e,u_e) -> (t, s_e, u_e)
      | uu____4295 -> failwith "[check_m]: impossible"

and comp_of_nm : nm_ -> FStar_Syntax_Syntax.comp =
  fun nm  ->
    match nm with | N t -> FStar_Syntax_Syntax.mk_Total t | M t -> mk_M t

and mk_M : FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.comp =
  fun t  ->
    FStar_Syntax_Syntax.mk_Comp
      {
        FStar_Syntax_Syntax.comp_univs = [FStar_Syntax_Syntax.U_unknown];
        FStar_Syntax_Syntax.effect_name = FStar_Syntax_Const.monadic_lid;
        FStar_Syntax_Syntax.result_typ = t;
        FStar_Syntax_Syntax.effect_args = [];
        FStar_Syntax_Syntax.flags =
          [FStar_Syntax_Syntax.CPS; FStar_Syntax_Syntax.TOTAL]
      }

and type_of_comp :
  (FStar_Syntax_Syntax.comp',Prims.unit) FStar_Syntax_Syntax.syntax ->
    (FStar_Syntax_Syntax.term',FStar_Syntax_Syntax.term')
      FStar_Syntax_Syntax.syntax
  = fun t  -> FStar_Syntax_Util.comp_result t

and trans_F_ :
  env_ ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  =
  fun env  ->
    fun c  ->
      fun wp  ->
        (let uu____4317 = Prims.op_Negation (is_C c)  in
         if uu____4317 then failwith "not a C" else ());
        (let mk x = FStar_Syntax_Syntax.mk x None c.FStar_Syntax_Syntax.pos
            in
         let uu____4329 =
           (FStar_Syntax_Subst.compress c).FStar_Syntax_Syntax.n  in
         match uu____4329 with
         | FStar_Syntax_Syntax.Tm_app (head,args) ->
             let uu____4346 = FStar_Syntax_Util.head_and_args wp  in
             (match uu____4346 with
              | (wp_head,wp_args) ->
                  ((let uu____4373 =
                      (Prims.op_Negation
                         ((FStar_List.length wp_args) =
                            (FStar_List.length args)))
                        ||
                        (Prims.op_Negation
                           (let _0_596 =
                              FStar_Syntax_Util.mk_tuple_data_lid
                                (FStar_List.length wp_args)
                                FStar_Range.dummyRange
                               in
                            FStar_Syntax_Util.is_constructor wp_head _0_596))
                       in
                    if uu____4373 then failwith "mismatch" else ());
                   mk
                     (FStar_Syntax_Syntax.Tm_app
                        (let _0_600 =
                           FStar_List.map2
                             (fun uu____4405  ->
                                fun uu____4406  ->
                                  match (uu____4405, uu____4406) with
                                  | ((arg,q),(wp_arg,q')) ->
                                      let print_implicit q =
                                        let uu____4429 =
                                          FStar_Syntax_Syntax.is_implicit q
                                           in
                                        if uu____4429
                                        then "implicit"
                                        else "explicit"  in
                                      (if q <> q'
                                       then
                                         (let _0_598 = print_implicit q  in
                                          let _0_597 = print_implicit q'  in
                                          FStar_Util.print2_warning
                                            "Incoherent implicit qualifiers %b %b"
                                            _0_598 _0_597)
                                       else ();
                                       (let _0_599 = trans_F_ env arg wp_arg
                                           in
                                        (_0_599, q)))) args wp_args
                            in
                         (head, _0_600)))))
         | FStar_Syntax_Syntax.Tm_arrow (binders,comp) ->
             let binders = FStar_Syntax_Util.name_binders binders  in
             let uu____4449 = FStar_Syntax_Subst.open_comp binders comp  in
             (match uu____4449 with
              | (binders_orig,comp) ->
                  let uu____4454 =
                    FStar_List.split
                      (FStar_List.map
                         (fun uu____4472  ->
                            match uu____4472 with
                            | (bv,q) ->
                                let h = bv.FStar_Syntax_Syntax.sort  in
                                let uu____4485 = is_C h  in
                                if uu____4485
                                then
                                  let w' =
                                    let _0_601 = star_type' env h  in
                                    FStar_Syntax_Syntax.gen_bv
                                      (Prims.strcat
                                         (bv.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                         "-w'") None _0_601
                                     in
                                  let _0_606 =
                                    let _0_605 =
                                      let _0_604 =
                                        let _0_603 =
                                          FStar_Syntax_Syntax.null_bv
                                            (let _0_602 =
                                               FStar_Syntax_Syntax.bv_to_name
                                                 w'
                                                in
                                             trans_F_ env h _0_602)
                                           in
                                        (_0_603, q)  in
                                      [_0_604]  in
                                    (w', q) :: _0_605  in
                                  (w', _0_606)
                                else
                                  (let x =
                                     let _0_607 = star_type' env h  in
                                     FStar_Syntax_Syntax.gen_bv
                                       (Prims.strcat
                                          (bv.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                          "-x") None _0_607
                                      in
                                   (x, [(x, q)]))) binders_orig)
                     in
                  (match uu____4454 with
                   | (bvs,binders) ->
                       let binders = FStar_List.flatten binders  in
                       let comp =
                         let _0_609 =
                           let _0_608 =
                             FStar_Syntax_Syntax.binders_of_list bvs  in
                           FStar_Syntax_Util.rename_binders binders_orig
                             _0_608
                            in
                         FStar_Syntax_Subst.subst_comp _0_609 comp  in
                       let app =
                         mk
                           (FStar_Syntax_Syntax.Tm_app
                              (let _0_612 =
                                 FStar_List.map
                                   (fun bv  ->
                                      let _0_611 =
                                        FStar_Syntax_Syntax.bv_to_name bv  in
                                      let _0_610 =
                                        FStar_Syntax_Syntax.as_implicit false
                                         in
                                      (_0_611, _0_610)) bvs
                                  in
                               (wp, _0_612)))
                          in
                       let comp =
                         let _0_614 = type_of_comp comp  in
                         let _0_613 = is_monadic_comp comp  in
                         trans_G env _0_614 _0_613 app  in
                       FStar_Syntax_Util.arrow binders comp))
         | FStar_Syntax_Syntax.Tm_ascribed (e,uu____4540,uu____4541) ->
             trans_F_ env e wp
         | uu____4560 -> failwith "impossible trans_F_")

and trans_G :
  env_ ->
    FStar_Syntax_Syntax.typ ->
      Prims.bool -> FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.comp
  =
  fun env  ->
    fun h  ->
      fun is_monadic  ->
        fun wp  ->
          let mk x = FStar_Syntax_Syntax.mk x None h.FStar_Syntax_Syntax.pos
             in
          if is_monadic
          then
            FStar_Syntax_Syntax.mk_Comp
              (let _0_618 = star_type' env h  in
               let _0_617 =
                 let _0_616 =
                   let _0_615 = FStar_Syntax_Syntax.as_implicit false  in
                   (wp, _0_615)  in
                 [_0_616]  in
               {
                 FStar_Syntax_Syntax.comp_univs =
                   [FStar_Syntax_Syntax.U_unknown];
                 FStar_Syntax_Syntax.effect_name =
                   FStar_Syntax_Const.effect_PURE_lid;
                 FStar_Syntax_Syntax.result_typ = _0_618;
                 FStar_Syntax_Syntax.effect_args = _0_617;
                 FStar_Syntax_Syntax.flags = []
               })
          else FStar_Syntax_Syntax.mk_Total (trans_F_ env h wp)

let n :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  =
  FStar_TypeChecker_Normalize.normalize
    [FStar_TypeChecker_Normalize.Beta;
    FStar_TypeChecker_Normalize.UnfoldUntil
      FStar_Syntax_Syntax.Delta_constant;
    FStar_TypeChecker_Normalize.NoDeltaSteps;
    FStar_TypeChecker_Normalize.Eager_unfolding;
    FStar_TypeChecker_Normalize.EraseUniverses]
  
let star_type : env -> FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.term =
  fun env  -> fun t  -> let _0_619 = n env.env t  in star_type' env _0_619 
let star_expr :
  env ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.typ * FStar_Syntax_Syntax.term *
        FStar_Syntax_Syntax.term)
  = fun env  -> fun t  -> let _0_620 = n env.env t  in check_n env _0_620 
let trans_F :
  env_ ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term
  =
  fun env  ->
    fun c  ->
      fun wp  ->
        let _0_622 = n env.env c  in
        let _0_621 = n env.env wp  in trans_F_ env _0_622 _0_621
  