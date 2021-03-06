module Bug1270

open FStar.Tactics

let test =
  assert_by_tactic (True ==> True)
    (fun () ->
      let _ = implies_intros () in
      let env = cur_env () in
      let hyps = binders_of_env env in
      match hyps with
      | [] -> ()
      | h :: _ -> ())
