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
dnl Internal: _BT_CHECK_LIBUUID([action-if-found],[action-if-not-found])
AC_DEFUN([_BT_CHECK_LIBUUID],[
BT_CHECK_LIB([libuuid],,,[
    have_libuuid=yes
    AC_CHECK_FUNC([uuid_compare],,[
	    AC_CHECK_LIB([uuid],[uuid_compare],[LIBUUID_LIBS="-luuid"],[have_libuuid=no])
	])
    if test x"$have_libuuid" = x"yes" ; then
        AC_CHECK_HEADER([uuid/uuid.h],,[have_libuuid=no])
    fi
],,[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBUUID([action-if-found],[action-if-not-found])
AC_DEFUN([BT_CHECK_LIBUUID],[
_BT_CHECK_LIBUUID([$1],[$2])
])dnl
dnl
dnl - BT_REQUIRE_LIBUUID([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBUUID],[
_BT_CHECK_LIBUUID([$1],[
	AC_MSG_ERROR([cannot find required library libuuid])
])
])dnl
