dnl Copyright 2012 Mo McRoberts.
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
AC_DEFUN([BT_DEFINE_PREFIX],[
if test x"$prefix" = x"NONE" ; then
   prefix="$ac_default_prefix"
fi
dir=`eval echo $prefix`
AC_DEFINE_UNQUOTED([PREFIX], ["$dir"], [Installation prefix])

if test x"$exec_prefix" = x"NONE" ; then
   exec_prefix="$prefix"
fi
dir=`eval echo $exec_prefix`
AC_DEFINE_UNQUOTED([EXEC_PREFIX], ["$dir"], [Platform-specific installation prefix])
dir=`eval echo $libdir`
AC_DEFINE_UNQUOTED([LIBDIR], ["$dir"], [Library installation path])
dir=`eval echo $includedir`
AC_DEFINE_UNQUOTED([INCLUDEDIR], ["$dir"], [C headers installation path])
])dnl
