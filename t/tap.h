/* tap.h */

#ifndef __TAP_H
#define __TAP_H

#include <stdio.h>
#include <stdarg.h>

void set_vfpf(int (*nvfpf)(FILE *f, const char *msg, va_list ap));
int test(int flag, const char *msg, va_list ap);
void diag(const char *fmt, ...);
void die(const char *fmt, ...);
void done_testing(void);
int nest_in(const char *p);
int nest_out(void);
int ok(int flag, const char *msg, ...);
int pass(const char *msg, ...);
int fail(const char *msg, ...);
int is(long long got, long long want, const char *msg, ...);
int not_null(const void *p, const char *msg, ...);
int null(const void *p, const char *msg, ...);

#define subtest(name) \
  for ( int x = nest_in(name); x < 1; x++, nest_out() )

#define TF(flag) \
  va_list ap;          \
  int _c = (flag);     \
  va_start( ap, msg ); \
  test( _c, msg, ap ); \
  va_end( ap );        \
  return _c;

#endif

/* vim:ts=2:sw=2:sts=2:et:ft=c
 */
