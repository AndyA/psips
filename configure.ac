AC_INIT([psips],[m4_esyscmd(sh tools/get-version.sh)])

AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([foreign])
AM_MAINTAINER_MODE

AC_CONFIG_HEADER([config.h])

BT_PROG_XCODE
AC_PROG_CC([clang gcc c99 cc])

LT_INIT

AC_PROG_CC_C99
AC_SYS_LARGEFILE
BT_PROG_CC_WARN

AC_CONFIG_FILES([
Makefile
m4/Makefile
t/Makefile
])

AC_OUTPUT
