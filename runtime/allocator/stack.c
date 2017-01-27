/*
   Copyright 2015 Michael Hicks, Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdarg.h>
#include "stack.h"
#include "bitmask.h"

/* Utility routines */

#define check(_p) if (!(_p)) { fprintf(stderr,"Failed check %s:%d\n",__FILE__,__LINE__); fflush(stdout); exit(1); }
#ifdef DEBUG
#define assert check
#else
#define assert(x) 
#endif
#define max(a,b) (a>b?a:b)

static inline int align(int n, int blocksize) {
  return n % blocksize == 0 ? n : blocksize * ((n / blocksize) + 1);
}

static inline int word_align(int bytes) {
  return align(bytes,WORD_SZB);
}

static inline int byte_align(int bits) {
  return align(bits,8);
}

/* 
   A stack is implemented as a list of pages, where the front of the list
   is the top of the stack. One page can store many frames and a frame
   can span multiple pages. Allocation is always word aligned.
*/

typedef struct _Page {
  void* memory; /* contains the memory for this page; returned by malloc() */
  void* alloc_ptr; /* the allocation pointer (within the page memory) */
  void* limit_ptr; /* the limit pointer (points to the end of memory) */
  void** frame_ptr; /* points to the base of the current frame, in the memory */
    /* frame_ptr == NULL implies this is the topmost frame of the current page */
    /* frame_ptr == EXT_MARKER implies this frame begins on the prior page */
    /* frame_ptr == p implies p points to the base of the frame in the page's memory */
  struct _Page *prev; /* points to the previous page on the stack */
  MASK_TYPE pointermap[0]; /* contains a bitmask that identifies all pointers on this page. */
    /* this map is only valid for memory in the range [memory -- alloc_ptr]; outside
       that range it is garbage. Also, the map is at word granularity. */
} Page;

/* This needs to be > NULL and < legal pointers */
#define EXT_MARKER (void **)0x1

/* The top of the stack */
static Page *top = NULL;
static int default_page_szw = DEFAULT_PAGE_SZW;

/* [have_space(w)] returns 1 iff there exist [w] words available to allocate on the current page */
static inline int have_space(int sz_w) {
  return (((void **)top->limit_ptr - (void **)top->alloc_ptr) >= sz_w);
}

/* [add_page(w,e)] pushes a new page on the stack, where the page should have at least
   [w] words. If [e] is 1, then this page is extending a frame begun on the previous page.
   Otherwise the page coincides with the start of a new frame. */
static void add_page(int sz_w, int is_ext) {
  int sz_b = WORD_SZB * (max(sz_w, default_page_szw));
#ifndef NOGC
  int mapsz_b = word_align(MASK_SZB(sz_b/WORD_SZB));
  // XXX it's unclear why we need an extra WORD_SZB, but without it, we get a
  // segfault when WORD_SZB = 8 and sizeof(MASK_TYPE) = 4
  // printf ("add page size = %d, ext = %d, map size = %d\n", sz_b, is_ext, mapsz_b);
  Page *region = malloc(sizeof(Page)+mapsz_b+WORD_SZB);  
#else   
  Page *region = malloc(sizeof(Page));
#endif
  void* memory = malloc(sz_b);
  check (region != NULL);
  check (memory != NULL);
  region->memory = memory;
  region->alloc_ptr = memory;
  region->limit_ptr = (void *)((unsigned long)memory + (unsigned long)sz_b);
  region->frame_ptr = is_ext ? EXT_MARKER : NULL;
  region->prev = top;
  top = region;
}

/* [set_page_szw(w) sets the default page size to [w] words. */
void set_page_szw(int sz_w) {
  default_page_szw = sz_w > MIN_FRAME_SZW ? sz_w : MIN_FRAME_SZW;
}

/* [push_frame()] pushes a new frame on the stack. It attempts to add that
   frame to the current page, if there is a minimum amount of space. It stores the current
   frame pointers at the allocation pointer, updates the frame pointer to point to
   that location, and then advances the allocation pointer (as in a C function call). 
   It also clears the pointermap for the frame pointer's storage. If insufficient
   space exists on the current page to support the frame, then a new page is 
   allocated, establishing the new frame. */
void push_frame(void) {
  if (top != NULL && have_space(MIN_FRAME_SZW)) { // can continue with current page
    //printf("push frame in page\n");
    *((void **)top->alloc_ptr) = top->frame_ptr;
    top->frame_ptr = top->alloc_ptr;
#ifndef NOGC
    int bit = (void **)top->frame_ptr - (void **)top->memory; 
    unsetbit(top->pointermap, bit);
#endif    
    top->alloc_ptr = (void *)((unsigned long)top->alloc_ptr + WORD_SZB);
  } else {
    //printf("push frame on new page\n");
    add_page(MIN_FRAME_SZW,0);
  }
}

/* [pop_frame()] pops the current frame. If this is the last frame on
   the page, then there is one of two situations. If the frame is not
   the last on this page, then we reset the frame pointer to the saved
   one, a change the allocation pointer to the frame pointer (as when
   returning from a C function call). Otherwise, the frame is the last
   on the page and either started on the page (in which case
   top->frame_ptr is NULL), or started on a previous page (in which
   case top->frame is EXT_MARKER). In this case, we free the page and
   the associated memory, and pop it from the stack. If the frame is a
   continuation, we also have to pop it on the previous page.  */
void pop_frame() {
#ifdef DEBUG
  if (top == NULL) {
    printf("warning: popping from empty stack!\n");
    return;
  }
#endif
  if (top->frame_ptr > EXT_MARKER) {
    //printf ("pop frame on page\n");
    top->alloc_ptr = top->frame_ptr;
    top->frame_ptr = *((void **)top->alloc_ptr);
  } else {
    Page *prev = top->prev;
    void **fp = top->frame_ptr;
    //printf ("pop frame and free page\n");
#ifdef DEBUG
    memset(top->memory, 255, ((unsigned long)top->limit_ptr - (unsigned long)top->memory));
#endif
    free(top->memory);
    free(top);
    top = prev;
    if (fp == EXT_MARKER) {
      //printf ("recursively pop frame\n");
      pop_frame();
    }
  }
}

/* [stack_alloc_maskp(w,n,m)] allocates [w] words in the current
   frame. Of these words, there are [n] words that contain pointers,
   as defined by the mask [m]. This mask is an array of integers
   indicating the word-sized offsets in the memory that begin the
   pointers. If [n] is -1 then all words BUT THE FIRST are potential pointers. If
   the current page has enough memory, we simply bump the allocation
   pointer; otherwise, we allocate another page and extend the frame
   onto that page. The pointermap for the allocated memory is set to
   0, and then the bits in the mask are set.
 */
void *stack_alloc_maskp(int sz_w, int nbits, int *mask) {
#ifdef DEBUG
  if (top == NULL) {
    printf ("Warning: allocating on an empty stack\n");
    return NULL;
  }
#endif
 retry: if (have_space(sz_w)) { // can continue with current page
    void *res = top->alloc_ptr;
    //printf("allocated %d bytes\n", sz_b);
    top->alloc_ptr = (void *)((void **)top->alloc_ptr + sz_w);
#ifndef NOGC
    {
      int i, ofs = (void **)res - (void **)top->memory; // #words into the page
      if (nbits < 0) { /* set all object words as possibly pointerful */
	unsetbit(top->pointermap,ofs); // except the first word
	setbit_rng(top->pointermap, ofs+1, sz_w-1);
      } else { /* set just words in the mask */
	unsetbit_rng(top->pointermap, ofs, sz_w);
	for (i = 0; i<nbits; i++) {
	  setbit(top->pointermap, mask[i]+ofs);
	}
      }
    }
#endif    
    return res;
  } else {
    //printf("adding page on demand (size %d)\n", sz_b);
    add_page(sz_w*2,1);
    goto retry;
  }
}

/* vstack_alloc_mask variable-argument wrapper around the stack
   allocation routine. */
void *vstack_alloc_mask(int sz_w, int nbits, va_list argp) {
  int buf[256];
  int i;
  assert(nbits >= -1 && nbits < 256);
  for (i=0; i<nbits; i++) {
    int n = va_arg(argp,int);
    buf[i] = n;
  }
  return stack_alloc_maskp(sz_w,nbits,buf);
}  

/* vstack_alloc_mask variable-argument wrapper around the stack
   allocation routine. */
void *stack_alloc_mask(int sz_w, int nbits, ...) {
  va_list argp;
  void *result;
  va_start(argp, nbits);
  result = vstack_alloc_mask(sz_w, nbits, argp);
  va_end(argp);
  return result;
}

/* stack_alloc is a special case of stack allocation that allocates
   memory that contains no pointers. */
void *stack_alloc(int sz_w) {
  return stack_alloc_mask(sz_w, 0);
}

/* [is_stack_pointer(p)] returns 1 if p is a valid (allocated) stack
   address, and 0 otherwise. */
int is_stack_pointer(void *ptr) {
  Page *tmp = top;
  while (tmp != NULL) {
    if (tmp->memory <= ptr && tmp->alloc_ptr > ptr)
      return 1;
    tmp = tmp->prev;
  }
  return 0;
}

/* [each_marked_pointer(f,e)] is an interator over all marked pointers
   on the stack. Here, [f] is a function of type [ptrfun] (see
   stack.h), which takes as its argument an environment and the
   address of a marked pointer on the stack. We implement this using
   the bitmask iterator, passing to it the function ptrbitfun. This
   function, converts the bit index it is given into the address of
   the relevant stack pointer. It does this using an environment
   struct ptrenv, which contains a pointer to the relevant page's
   memory, and then the function [f], and the environment [e] it was
   called with.
 */

struct ptrenv { 
  void **memory; 
  ptrfun f;
  void *env;
};

void ptrbitfun(void *env, int index) {
  struct ptrenv *penv = (struct ptrenv *)env;
  void **ptr = &(penv->memory[index]);
  penv->f(penv->env,ptr);
}

#ifndef NOGC
void each_marked_pointer(ptrfun f, void *env) {
  Page *tmp = top;
  struct ptrenv penv = { 0, f, env };
  while (tmp != NULL) {
    int maxbit = (void **)tmp->alloc_ptr - (void **)tmp->memory; 
    penv.memory = (void**)tmp->memory;
    eachbit(tmp->pointermap, maxbit, ptrbitfun, (void *)&penv);
    tmp = tmp->prev;
  }
}
#else
void each_marked_pointer(ptrfun f, void *env) {
    printf("this should not be getting called\n");    
    assert(false);
  }
#endif
  

