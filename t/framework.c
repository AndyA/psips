/* framework.c */

#include <stddef.h>
#include <stdlib.h>

#include "framework.h"
#include "tap.h"

int main(int argc, char *argv[]) {
  int i, count = 1;
  const char *tc_env = NULL;

  if (argc > 1)
    count = atoi(argv[1]);
  else if (tc_env = getenv("PS_TEST_COUNT"), tc_env)
    count = atoi(tc_env);

  for (i = 0; i < count; i++)
    test_main();

  done_testing();
  return 0;
}

/* vim:ts=2:sw=2:sts=2:et:ft=c
 */
