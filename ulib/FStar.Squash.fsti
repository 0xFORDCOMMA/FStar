module FStar.Squash

(* Interface for squash types; somehow inspired by:
Quotient Types: A Modular Approach. Aleksey Nogin, TPHOLs 2002.
http://www.nuprl.org/documents/Nogin/QuotientTypes_02.pdf
*)

(*
assume new type squash : Type -> Type0
Interface contains an abstract 'type' declaration; use 'val' instead
*)

(*
val squash : Type -> Type0
val squash in the interface is implemented with a 'type'
*)
val squash : Type -> Type0

val get_proof : p:Type ->
  Pure (squash p) (requires p) (ensures (fun _ -> True))

val give_proof : #p:Type -> squash p ->
  Pure unit (requires True) (ensures (fun _ -> p))

val proof_irrelevance : p:Type -> x:squash p ->
                                 y:squash p -> Tot (squash (x == y))

val squash_double_arrow : #a:Type -> #p:(a -> Type) ->
  $f:(squash (x:a -> Tot (squash (p x)))) -> Tot (squash (x:a -> Tot (p x)))

val squash_double_sum:  #a:Type -> #p:(a -> Type) ->
  $f:(squash (x:a & squash (p x))) -> Tot (squash (x:a & p x))

(* This is a monad *)

val return_squash : #a:Type -> a -> Tot (squash a)

val bind_squash : #a:Type -> #b:Type -> squash a -> (a -> Tot (squash b)) ->
  Tot (squash b)

val map_squash : #a:Type -> #b:Type -> squash a -> (a -> Tot b) ->
  Tot (squash b)
