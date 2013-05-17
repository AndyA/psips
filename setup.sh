#!/bin/sh

autoreconf -i && cat <<EOT

Ready to rock. Now you can

$ ./configure [options]
$ make
$ make test
$ sudo make install

EOT

# vim:ts=2:sw=2:sts=2:et:ft=sh

