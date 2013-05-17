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
dnl - BT_CHECK_LIB(name,[local-subdir],[pkg-config modules],local-test-code,[use-local-code],[action-if-found],[action-if-not-found])
dnl
dnl test-code is a detection routine; it should set
dnl   have_name        => yes|no
dnl   NAME_CPPFLAGS    => Any CPPFLAGS specific to the library
dnl   NAME_LDFLAGS     => Any LDFLAGS specific to the library
dnl   NAME_LIBS        => The -lxxx linker flags needed to link the library
dnl   NAME_LOCAL_LIBS  => Any in-tree libtool libraries needed to link
dnl
dnl action-if-found defaults to adding the above variables to AM_CPPFLAGS,
dnl AM_LDFLAGS, LIBS and LOCAL_LIBS respectively.
dnl
dnl action-if-not-found defaults to nothing
m4_pattern_forbid([^BT_])dnl
m4_pattern_forbid([^bt_])dnl
m4_pattern_forbid([^_BT_])dnl
AC_DEFUN([BT_CHECK_LIB],[
AC_REQUIRE([PKG_PROG_PKG_CONFIG])dnl

dnl Save these variables, they shouldn't be overwritten
old_CPPFLAGS="$CPPFLAGS"
old_LDFLAGS="$LDFLAGS"
old_LIBS="$LIBS"

dnl Use bt_lprefix and bt_uprefix as shell variable prefixes
m4_ifdef([bt_lprefix], [m4_undefine([bt_lprefix])])dnl
m4_define([bt_lprefix], AS_TR_SH([$1]))dnl
m4_ifdef([bt_uprefix], [m4_undefine([bt_uprefix])])dnl
m4_define([bt_uprefix], AS_TR_CPP([$1]))dnl

dnl Define bt_l_xxx macros to be the names of shell variables that we use
m4_ifdef([bt_l_have], [m4_undefine([bt_l_have])])dnl
m4_ifdef([bt_l_with], [m4_undefine([bt_l_with])])dnl
m4_ifdef([bt_l_local], [m4_undefine([bt_l_local])])dnl
m4_ifdef([bt_l_included], [m4_undefine([bt_l_included])])dnl
m4_ifdef([bt_l_cppflags], [m4_undefine([bt_l_cppflags])])dnl
m4_ifdef([bt_l_ldflags], [m4_undefine([bt_l_ldflags])])dnl
m4_ifdef([bt_l_libs], [m4_undefine([bt_l_libs])])dnl
m4_ifdef([bt_l_local_libs], [m4_undefine([bt_l_local_libs])])dnl
dnl
m4_define([bt_l_have],[m4_join(,[have_],bt_lprefix)])dnl
m4_define([bt_l_local],[m4_join(,[local_],bt_lprefix)])dnl
m4_define([bt_l_with],[m4_join(,[with_],bt_lprefix)])dnl
m4_define([bt_l_included],[m4_join(,[with_included_],bt_lprefix)])dnl
m4_define([bt_l_cppflags],[m4_join(,bt_uprefix,[_CPPFLAGS])])dnl
m4_define([bt_l_ldflags],[m4_join(,bt_uprefix,[_LDFLAGS])])dnl
m4_define([bt_l_libs],[m4_join(,bt_uprefix,[_LIBS])])dnl
m4_define([bt_l_local_libs],[m4_join(,bt_uprefix,[_LOCAL_LIBS])])dnl

AS_VAR_SET(bt_l_have,[no])
AS_VAR_SET(bt_l_local,[no])
AC_ARG_WITH([$1],[AS_HELP_STRING([--with-$1=PATH],[Specify installation prefix of $1])],[AS_VAR_SET(bt_l_with,["$withval"])],[AS_VAR_SET(bt_l_with,[auto])])

dnl If a subdir was specified, look for a bundled tree
m4_ifval([$2],[
if test -r "$srcdir/$2/configure" ; then
	AS_VAR_SET(bt_l_local,[auto])
fi
AC_ARG_WITH([included_$1],[AS_HELP_STRING([--without-included-$1],[Don't use a bundled version of $1 if present])],[
dnl If --with-included-foo was specified explicitly, skip the external tests
if test x"$bt_l_local" = x"yes" && test x"$withval" = x"yes" ; then
	AS_VAR_SET(bt_l_with,[no])
fi
],[AS_VAR_SET(bt_l_included,$bt_l_local)])
if test x"$bt_l_local" = x"no" ; then
	AS_VAR_SET(bt_l_included,[no])
fi
])dnl

case "$bt_l_with" in
	yes)
		AS_VAR_SET(bt_l_included,[no])
		;;
	no|auto)
		;;
	*)
		AS_VAR_SET(bt_l_included,[no])
		AS_VAR_SET(bt_l_cppflags,["-I$]bt_l_with[/include"])
		AS_VAR_SET(bt_l_ldflags,["-L$]bt_l_with[/lib"])
		;;
esac

AS_VAR_SET([CPPFLAGS],["$CPPFLAGS $]bt_l_cppflags")
AS_VAR_SET([LDFLAGS],["$LDFLAGS $]bt_l_ldflags")

if ! test x"$bt_l_included" = x"yes" ; then
	if ! test x"$bt_l_with" = x"no" ; then

m4_ifval([$3],[
	AC_MSG_CHECKING([for $3 with pkg-config])
	AS_VAR_SET(bt_l_cppflags)
	AS_VAR_SET(bt_l_libs)
	unset pkg_modversion
	_PKG_CONFIG(bt_l_cppflags, [cflags], [$3])
	_PKG_CONFIG(bt_l_libs, [libs], [$3])
	_PKG_CONFIG([pkg_modversion], [modversion], [$3])
	if test -n "$pkg_failed" ; then
		AC_MSG_RESULT([no])
	else
		AC_MSG_RESULT([yes ($pkg_modversion)])
		AS_VAR_SET(bt_l_have,[yes])
	fi
])

		if test x"$bt_l_have" = x"no" ; then
			m4_ifval([$4],[$4],true)dnl
		fi
	fi
fi

if test x"$bt_l_have" = x"yes" ; then
	bt_l_included=no
fi

m4_ifval([$2],[
if ! test x"$bt_l_included" = x"no" ; then
	AS_VAR_SET(bt_l_have,[yes])
	m4_ifval([$5],[$5])
fi
])dnl

dnl Restore important variables
CPPFLAGS="$old_CPPFLAGS"
LDFLAGS="$old_LDFLAGS"
LIBS="$old_LIBS"

AC_SUBST(bt_l_have)
AC_SUBST(bt_l_cppflags)
AC_SUBST(bt_l_ldflags)
AC_SUBST(bt_l_libs)
AC_SUBST(bt_l_local_libs)

if test x"$bt_l_have" = x"yes" ; then
	AC_DEFINE_UNQUOTED(m4_join(,[WITH_],bt_uprefix),[1],[Define if $1 is available])
	m4_ifval([$6],[$6],[
		AS_VAR_SET([AM_CPPFLAGS],["$AM_CPPFLAGS $]bt_l_cppflags")
		AC_SUBST([AM_CPPFLAGS])
		AS_VAR_SET([AM_LDFLAGS],["$AM_LDFLAGS $]bt_l_ldflags")
		AC_SUBST([AM_LDFLAGS])
		AS_VAR_SET([LIBS],"$bt_l_libs[ $LIBS"])
		AC_SUBST([LIBS])
		AS_VAR_SET([LOCAL_LIBS],"$bt_l_local_libs[ $LOCAL_LIBS"])
		AC_SUBST([LOCAL_LIBS])
	])
else
	m4_ifval([$7],[$7],[true])
fi
])dnl
