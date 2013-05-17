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
AC_DEFUN([BT_BUILD_DOCS],[
AC_ARG_ENABLE([docs],[AS_HELP_STRING([--disable-docs],[disable re-building documentation (default=auto)])],[build_docs=$enableval],[build_docs=auto])
XML2MAN=true
XML2HTML=true
if test x"$build_docs" = x"yes" || test x"$build_docs" = x"auto" ; then
   AC_CHECK_PROGS([XSLTPROC],[xsltproc],[false])
   if test x"$XSLTPROC" = x"false" ; then
   	  if test x"$build_docs" = x"yes" ; then
	  	 AC_MSG_ERROR([re-building documentation was requested, but the xsltproc utility cannot be found])
	  fi
	  build_docs=no
   else
      build_docs=yes
	  XML2MAN='${XSLTPROC} -nonet \
		-param man.charmap.use.subset 0 \
		-param make.year.ranges 1 \
		-param make.single.year.ranges 1 \
		-param man.authors.section.enabled 0 \
		-param man.copyright.section.enabled 0 \
		http://docbook.sourceforge.net/release/xsl-ns/current/manpages/docbook.xsl'
	  XML2HTML='${XSLTPROC} -nonet \
	    -param docbook.css.link 0 \
		-param generate.css.header 1 \
		-param funcsynopsis.style ansi \
	    http://docbook.sourceforge.net/release/xsl-ns/current/xhtml5/docbook.xsl'
   fi
else
   build_docs=no
fi
AC_MSG_CHECKING([whether to re-build documentation if needed])
AC_MSG_RESULT([$build_docs])
AC_SUBST([XML2MAN])
AC_SUBST([XML2HTML])
])dnl
