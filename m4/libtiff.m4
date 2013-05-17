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
dnl Internal: _BT_CHECK_LIBTIFF([action-if-found],[action-if-not-found],[localdir])
AC_DEFUN([_BT_CHECK_LIBTIFF],[
BT_CHECK_LIB([libtiff],[$3],,[
	have_libtiff_header=no
	AC_CHECK_HEADER([tiffio.h],[have_libtiff_header=yes],[
		if ! test x"$with_libtiff" = x"auto" ; then
		AC_MSG_WARN([cannot find the libtiff header tiffio.h. You can specify an installation prefix to libtiff with --with-libtiff=PREFIX])
		fi])
	if test x"$have_libtiff_header" = x"yes" ; then
		have_libtiff=yes
		AC_CHECK_LIB([tiff],[TIFFOpen],[LIBTIFF_LIBS="-ltiff $LIBTIFF_LIBS"],[
			have_libtiff=no
			AC_MSG_WARN([cannot find the libtiff library. You can specify an installation prefix to libtiff with --with-libtiff=PREFIX])])
	fi
],[
	AC_CONFIG_SUBDIRS([$3])
	LIBTIFF_CPPFLAGS="-I\${top_builddir}/$3/libtiff -I\${top_srcdir}/$3/libtiff"
	LIBTIFF_LDFLAGS="-L\${top_builddir}/$3/libtiff"
	LIBTIFF_LOCAL_LIBS="\${top_builddir}/$3/libtiff/libtiff.la"
],[$1],[$2])
])
dnl - BT_CHECK_LIBTIFF([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBTIFF],[
_BT_CHECK_LIBTIFF([$1],[$2])
])dnl
dnl - BT_CHECK_LIBTIFF_INCLUDED([action-if-found],[action-if-not-found],[subdir=tiff])
AC_DEFUN([BT_CHECK_LIBTIFF_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBTIFF([$1],[$2],m4_ifval([$3],[$3],[tiff]))
])dnl
dnl - BT_REQUIRE_LIBTIFF([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBTIFF],[
_BT_CHECK_LIBTIFF([$1],[
	AC_MSG_ERROR([cannot find required library libtiff])
])
])dnl
dnl - BT_REQUIRE_LIBTIFF_INCLUDED([action-if-found],[subdir=tiff])
AC_DEFUN([BT_REQUIRE_LIBTIFF_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBTIFF([$1],[
	AC_MSG_ERROR([cannot find required library libtiff])
],m4_ifval([$2],[$2],[tiff]))
])dnl
