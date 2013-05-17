dnl Copyright 2012-2013 Mo McRoberts.
dnl
dnl  Licensed under the Apache License, Version 2.0 (the "License");
dnl  you may not use this file except in compliance with the License.
dnl  You may obtain a copy of the License at
dnl
dnl      http://www.apache.org/licenses/LICENSE-2.0
dnl
dnl  Unless required by applicable law or agreed to in writing, software
dnl  distributed under the License is distributed on an "AS IS" BASIS,
dnl  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
dnl  See the License for the specific language governing permissions and
dnl  limitations under the License.
dnl
m4_pattern_forbid([^BT_])dnl
m4_pattern_forbid([^_BT_])dnl
AC_DEFUN([BT_ENABLE_NLS],[
AC_MSG_CHECKING([whether to enable native language support (NLS)])
AC_ARG_ENABLE([nls],[AS_HELP_STRING([--disable-nls],[disable native language support (NLS) (default=enabled)])],[build_nls=$enableval],[build_nls=yes])
AC_MSG_RESULT([$build_nls])
if test x"$build_nls" = x"yes" ; then
   AC_CHECK_HEADERS([locale.h nl_types.h])
   AC_CHECK_FUNC([setlocale],,[AC_MSG_ERROR([cannot locate the setlocale() function required for native language support (NLS)])])
   AC_CHECK_FUNC([catopen],,[AC_MSG_ERROR([cannot locate the catopen() function required for native language support (NLS)])])
   AC_CHECK_PROGS([GENCAT],[gencat],[false])
   if test x"$GENCAT" = x"false" ; then
   	  AC_MSG_ERROR([cannot locate the gencat utility required for native language support (NLS); configure with --disable-nls to forcibly disable NLS])
   fi
   AC_DEFINE([ENABLE_NLS],[1],[Define if native language support (NLS) should be enabled])
   localedir=${libdir}/locale
fi
])dnl
