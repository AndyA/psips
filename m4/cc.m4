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
AC_DEFUN([BT_PROG_CC_WARN],[
AC_MSG_CHECKING([whether to enable compiler warnings])
if test x"$GCC" = x"yes" ; then
   AC_MSG_RESULT([yes, -W -Wall])
   AM_CPPFLAGS="$AM_CPPFLAGS -W -Wall"
else
   AC_MSG_RESULT([no])
fi
AC_SUBST([AM_CPPFLAGS])
])dnl
