/* tap.c */

#include <stdlib.h>

#include "tap.h"

#define MAX_PREFIX 10

static int test_no = 0;

static const char *pfx[MAX_PREFIX];
static size_t npfx = 0;

static int (*vfpf)(FILE *f, const char *msg, va_list ap) = vfprintf;

void set_vfpf(int (*nvfpf)(FILE *f, const char *msg, va_list ap)) {
  vfpf = nvfpf;
}

static int fpf(FILE *f, const char *msg, ...) {
  va_list ap;
  int rc;
  va_start(ap, msg);
  rc = vfpf(f, msg, ap);
  va_end(ap);
  return rc;
}

void diag(const char *fmt, ...) {
  va_list ap;
  va_start(ap, fmt);
  fpf(stderr, "# ");
  vfpf(stderr, fmt, ap);
  fpf(stderr, "\n");
  va_end(ap);
}

void die(const char *fmt, ...) {
  va_list ap;
  va_start(ap, fmt);
  vfpf(stderr, fmt, ap);
  fpf(stderr, "\n");
  va_end(ap);
  exit(1);
}

void done_testing(void) {
  if (0 == test_no) die("No tests run!");
  fpf(stdout, "1..%d\n", test_no);
}

int nest_in(const char *p) {
  if (npfx == MAX_PREFIX) die("Too many prefixes");
  pfx[npfx++] = p;
  return 0;
}

int nest_out(void) {
  if (npfx == 0) die("Can't go out a level - we're at the top");
  npfx--;
  return 0;
}

static void prefix(void) {
  unsigned i;
  for (i = 0; i < npfx; i++) {
    fpf(stdout, "%s: ", pfx[i]);
  }
}

int test(int flag, const char *msg, va_list ap) {
  fpf(stdout, "%sok %d - ", flag ? "" : "not ", ++test_no);
  prefix();
  vfpf(stdout, msg, ap);
  fpf(stdout, "\n");
  return flag;
}

int ok(int flag, const char *msg, ...) {
  TF(flag);
}

int pass(const char *msg, ...) {
  TF(1);
}

int fail(const char *msg, ...) {
  TF(0);
}

int is(long long got, long long want, const char *msg, ...) {
  TF(got == want);
}

int not_null(const void *p, const char *msg, ...) {
  TF(!!p);
}

int null(const void *p, const char *msg, ...) {
  TF(!p);
}

/* vim:ts=2:sw=2:sts=2:et:ft=c
 */
