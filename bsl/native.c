#include <sys/resource.h>
#include <sys/utsname.h>
#include <caml/alloc.h>
#include <caml/memory.h>

CAMLprim value get_memory_usage() {
  CAMLparam0();

  static struct rusage usage;
  struct rusage *p = &usage;
  getrusage(RUSAGE_SELF, p);
  
  CAMLreturn(Val_long(p->ru_maxrss));
}


static struct utsname g_un;
static struct utsname *gp_un = NULL;

static void uname_init() {
  if(gp_un == NULL) {
    gp_un = &g_un;
    uname(gp_un);
  }

  return;
} 

CAMLprim value get_sys_sysname() {
  CAMLparam0();
  CAMLlocal1(str);

  uname_init();
  str = caml_copy_string(gp_un->sysname);

  CAMLreturn(str);
}

CAMLprim value get_sys_nodename() {
  CAMLparam0();
  CAMLlocal1(str);

  uname_init();
  str = caml_copy_string(gp_un->nodename);

  CAMLreturn(str);
}

CAMLprim value get_sys_release() {
  CAMLparam0();
  CAMLlocal1(str);

  uname_init();
  str = caml_copy_string(gp_un->release);

  CAMLreturn(str);
}

CAMLprim value get_sys_machine() {
  CAMLparam0();
  CAMLlocal1(str);

  uname_init();
  str = caml_copy_string(gp_un->machine);

  CAMLreturn(str);
}
