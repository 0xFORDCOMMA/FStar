module FStar.Pointer.Derived2

module DM = FStar.DependentMap
module HH = FStar.HyperHeap
module HS = FStar.HyperStack
module HST = FStar.HyperStack.ST

private
let copy_buffer_contents_inv
  (#t: typ)
  (a: buffer t) (* source *)
  (idx_a: UInt32.t)
  (b: buffer t) (* destination *)
  (idx_b: UInt32.t)
  (len: UInt32.t)
  (len' : UInt32.t)
  (h: HS.mem)
  (h' : HS.mem)
: GTot Type0
= copy_buffer_contents_precond a idx_a b idx_b len h /\
  modifies (loc_buffer (gsub_buffer b idx_b len)) h h' /\
  UInt32.v len' <= UInt32.v len /\
  buffer_readable h' (gsub_buffer b idx_b len') /\
  buffer_as_seq h' (gsub_buffer b idx_b len') == buffer_as_seq h (gsub_buffer a idx_a len')

private
val copy_buffer_contents_init
  (#t: typ)
  (a: buffer t) (* source *)
  (idx_a: UInt32.t)
  (b: buffer t) (* destination *)
  (idx_b: UInt32.t)
  (len: UInt32.t)
  (h: HS.mem)
: Lemma
  (requires (copy_buffer_contents_precond a idx_a b idx_b len h))
  (ensures (copy_buffer_contents_inv a idx_a b idx_b len 0ul h h))

let copy_buffer_contents_init #t a idx_a b idx_b len h =
  buffer_readable_intro_empty h (gsub_buffer b idx_b 0ul);
  Seq.lemma_eq_intro (buffer_as_seq h (gsub_buffer b idx_b 0ul)) (buffer_as_seq h (gsub_buffer a idx_a 0ul))

private
val copy_buffer_contents_advance
  (#t: typ)
  (a: buffer t) (* source *)
  (idx_a: UInt32.t)
  (b: buffer t) (* destination *)
  (idx_b: UInt32.t)
  (len: UInt32.t)  
  (len' : UInt32.t)
  (h: Ghost.erased HS.mem)
: HST.Stack unit
  (requires (fun h0 ->
    copy_buffer_contents_inv a idx_a b idx_b len len' (Ghost.reveal h) h0 /\
    UInt32.v len' < UInt32.v len
  ))
  (ensures (fun h1 _ h2 ->
    copy_buffer_contents_inv a idx_a b idx_b len len' (Ghost.reveal h) h1 /\
    UInt32.v len' < UInt32.v len /\
    copy_buffer_contents_inv a idx_a b idx_b len (UInt32.add len' 1ul) (Ghost.reveal h) h2
  ))

#set-options "--z3rlimit 16"

let copy_buffer_contents_advance #t a idx_a b idx_b len len' h =
  let v = read_buffer a (UInt32.add idx_a len') in
  let h1 = HST.get () in
  buffer_snoc b idx_b len' v;
  let h2 = HST.get () in
  assert (gpointer_of_buffer_cell b (UInt32.add idx_b len') == gpointer_of_buffer_cell (gsub_buffer b idx_b len) len');
  assert (v == Seq.index (buffer_as_seq (Ghost.reveal h) (gsub_buffer a idx_a len)) (UInt32.v len'));
  buffer_as_seq_gsub_buffer_snoc (Ghost.reveal h) a idx_a len'

private
val copy_buffer_contents_aux
  (#t: typ)
  (a: buffer t) (* source *)
  (idx_a: UInt32.t)
  (b: buffer t) (* destination *)
  (idx_b: UInt32.t)
  (len: UInt32.t)
  (len': UInt32.t)
  (h: Ghost.erased HS.mem)
: HST.Stack unit
  (requires (fun h0 -> 
    copy_buffer_contents_inv a idx_a b idx_b len len' (Ghost.reveal h) h0
  ))
  (ensures (fun h0 _ h1 ->
    copy_buffer_contents_inv a idx_a b idx_b len len' (Ghost.reveal h) h0 /\
    copy_buffer_contents_postcond a idx_a b idx_b len (Ghost.reveal h) h1
  ))
  (decreases (UInt32.v len - UInt32.v len'))

let rec copy_buffer_contents_aux #t a idx_a b idx_b len len' h =
  if len = len'
  then ()
  else begin
    copy_buffer_contents_advance a idx_a b idx_b len len' h;
    copy_buffer_contents_aux a idx_a b idx_b len (UInt32.add len' 1ul) h
  end

(* FIXME: Does not work if I directly try to define copy_buffer_contents *)

let copy_buffer_contents'
  (#t: typ)
  (a: buffer t) (* source *)
  (idx_a: UInt32.t)
  (b: buffer t) (* destination *)
  (idx_b: UInt32.t)
  (len: UInt32.t)
: HST.Stack unit
  (requires (fun h ->
    copy_buffer_contents_precond a idx_a b idx_b len h
//    copy_buffer_contents_inv a idx_a b idx_b len 0ul h h
  ))
  (ensures (fun h0 _ h1 ->
    copy_buffer_contents_postcond a idx_a b idx_b len h0 h1
  ))
= let h0 = HST.get () in
  copy_buffer_contents_init a idx_a b idx_b len h0;
  copy_buffer_contents_aux a idx_a b idx_b len 0ul (Ghost.hide h0)

let copy_buffer_contents = copy_buffer_contents'
