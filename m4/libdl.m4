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
dnl Internal: _BT_CHECK_LIBDL([action-if-found],[action-if-not-found])
AC_DEFUN([_BT_CHECK_LIBDL],[
BT_CHECK_LIB([libdl],,,[
    have_libdl=yes
	AC_CHECK_LIB([dl],[dlopen],[LIBDL_LIBS="-ldl"],[
        AC_CHECK_FUNC([dlopen],,[have_libdl=no])
	])
    if test x"$have_libdl" = x"yes" ; then
        AC_CHECK_HEADER([dlfcn.h],,[have_libdl=no])
    fi
],,[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBDL([action-if-found],[action-if-not-found])
AC_DEFUN([BT_CHECK_LIBDL],[
_BT_CHECK_LIBDL([$1],[$2])
])dnl
dnl
dnl - BT_REQUIRE_LIBDL([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBDL],[
_BT_CHECK_LIBDL([$1],[
	AC_MSG_ERROR([cannot find required library libdl])
])
])dnl
