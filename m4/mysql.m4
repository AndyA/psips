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
dnl Internal: _BT_CHECK_MYSQL([action-if-found],[action-if-not-found])
AC_DEFUN([_BT_CHECK_MYSQL],[
AC_REQUIRE([AC_CANONICAL_HOST])dnl
BT_CHECK_LIB([mysql],,,[
mysql_darwin_fixups=no
AC_CHECK_PROG([MYSQL_CONFIG],[mysql_config],[mysql_config])
if ! test x"$MYSQL_CONFIG" = x"" ; then
   have_mysql=yes
   MYSQL_CPPFLAGS=`$MYSQL_CONFIG --include`
   MYSQL_LIBDIR=`$MYSQL_CONFIG --variable=pkglibdir`
   if test "$?" -gt 0 ; then
      MYSQL_LIBDIR=""
   fi
   MYSQL_LIBS=`$MYSQL_CONFIG --libs_r`

dnl On Darwin, the MySQL Community Edition is installed without a proper
dnl id of the client library dylib. @mysql_darwin_fixups@ is subtituted into
dnl Makefiles to allow fixups via install_name_tool to be performed
dnl post-build.
	if test x"$cross_compiling" = x"no" ; then
		case "$host_os" in
			darwin*|Darwin*[)]
				if test -r "$MYSQL_LIBDIR/libmysqlclient_r.18.dylib" ; then
					mysql_darwin_fixups=yes
   				fi
				;;
		esac
	fi
fi
AC_SUBST([mysql_darwin_fixups])
AC_SUBST([MYSQL_LIBDIR])
],[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_MYSQL([action-if-found],[action-if-not-found])
AC_DEFUN([BT_CHECK_MYSQL],[
_BT_CHECK_MYSQL([$1],[$2])
])dnl
dnl
dnl - BT_REQUIRE_MYSQL([action-if-found])
AC_DEFUN([BT_REQUIRE_MYSQL],[
_BT_CHECK_MYSQL([$1],[
	AC_MSG_ERROR([cannot locate the MySQL client libraries; check that the mysql_config utility can be found])
])
])dnl
