#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <caml/alloc.h>
#include <caml/memory.h>

#include "markdown.h"
#include "html.h"
#include "buffer.h"

#define READ_UNIT 1024
#define OUTPUT_UNIT 64

CAMLprim value caml_upskirt_render(value caml_input) {
  CAMLparam1(caml_input);
  struct buf *ib;
  struct buf *ob;
  struct buf *ob2;

  /* Read */
  size_t ilen = caml_string_length(caml_input);
  ib = bufnew(READ_UNIT);
  bufgrow(ib, ilen);
  ib->size = ilen;
  memcpy(ib->data, String_val(caml_input), ilen);

  /* Convert to markdown */
  ob = bufnew(OUTPUT_UNIT);
  struct mkd_renderer renderer;
  ob->size = 0;
  upshtml_renderer(&renderer, 0);
  ups_markdown(ob, ib, &renderer, ~0);
  upshtml_free_renderer(&renderer);

  /* Now smartypants */
  ob2 = bufnew(OUTPUT_UNIT);
  ob2->size = 0;
  upshtml_smartypants(ob2, ob);

  /* Marshal to OCaml string & return */
  CAMLlocal1(caml_output);
  caml_output = caml_alloc_string(ob2->size);
  memcpy(String_val(caml_output), ob2->data, ob2->size); // copy output buffer

  bufrelease(ib);
  bufrelease(ob);
  bufrelease(ob2);

  CAMLreturn(caml_output);
}
