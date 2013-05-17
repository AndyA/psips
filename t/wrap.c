/* wrap.c */

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
  int fd, i;
  char buf[3];
  char **nargv, **nap;
  int (*ef)(const char * path, char * const argv[]);

  if (argc < 2) abort();

  fd = open(argv[1], O_RDONLY);
  if (fd <= 0) {
    perror(NULL);
    return 1;
  }

  ssize_t got = read(fd, buf, sizeof(buf));
  if (got < 0) {
    perror(NULL);
    return 1;
  }

  nargv = malloc(sizeof(char *) * (argc + 1));

  if (!nargv) abort();

  nap = nargv;
  ef = execv;

  if (got >= 3 && buf[0] == '#' && buf[1] == '!' && buf[2] > ' ') {
    *nap++ = "perl";
    ef = execvp;
  }

  for (i = 1; i < argc; i++)
    *nap++ = argv[i];

  *nap++ = NULL;

  ef(nargv[0], nargv);
  perror(NULL);
  abort();

  return 0;
}

/* vim:ts=2:sw=2:sts=2:et:ft=c
 */
