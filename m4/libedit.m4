dnl Copyright 2013 Mo McRoberts.
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
dnl Internal: _BT_CHECK_LIBEDIT([action-if-found],[action-if-not-found],[localdir])
AC_DEFUN([_BT_CHECK_LIBEDIT],[
BT_CHECK_LIB([libedit],[$3],,[
	AC_CHECK_LIB([edit],[el_init],[have_libedit=yes ; LIBEDIT_LIBS="-ledit"])
],[
	AC_CONFIG_SUBDIRS([$3])
	LIBEDIT_CPPFLAGS="-I\${top_builddir}/$3/src -I\${top_srcdir}/libedit/src"
	LIBEDIT_LOCAL_LIBS="\${top_builddir}/$3/src/libedit.la"
],[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBEDIT([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBEDIT],[
_BT_CHECK_LIBEDIT([$1],[$2])
])dnl
dnl - BT_CHECK_LIBEDIT_INCLUDED([action-if-found],[action-if-not-found],[subdir=libedit])
AC_DEFUN([BT_CHECK_LIBEDIT_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBEDIT([$1],[$2],m4_ifval([$3],[$3],[libedit]))
])dnl
dnl - BT_REQUIRE_LIBEDIT([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBEDIT],[
_BT_CHECK_LIBEDIT([$1],[
	AC_MSG_ERROR([cannot find required library libedit])
])
])dnl
dnl - BT_REQUIRE_LIBEDIT_INCLUDED([action-if-found],[subdir=libedit])
AC_DEFUN([BT_REQUIRE_LIBEDIT_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBEDIT([$1],[
	AC_MSG_ERROR([cannot find required library libedit])
],m4_ifval([$2],[$2],[libedit]))
])dnl
