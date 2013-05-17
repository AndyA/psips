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
AC_DEFUN([BT_PROG_XCODE],[
AC_REQUIRE([AC_CANONICAL_HOST])
case "$build_os" in
	darwin*)
		AC_CHECK_PROG([XCRUN],[xcrun],[xcrun])
		;;
esac
if ! test x"$XCRUN" = x"" ; then
	AC_MSG_CHECKING([for current Xcode developer tools path])
	XCDEVTOOLS=`xcode-select --print-path 2>/dev/null`
	if test x"$XCDEVTOOLS" = x"" ; then
		AC_MSG_RESULT([none])
	else
		AC_MSG_RESULT([$XCDEVTOOLS])
		AC_MSG_CHECKING([which Xcode SDK to use])
		AC_ARG_WITH([sdk],[
			AS_HELP_STRING([--with-sdk=SDKNAME],[specify name or path of Xcode SDK to use])
			],[XCSDK="$withval"],[
			case "$host" in
				arm*-apple-darwin*)
					XCSDK=iphoneos
					;;
				x86_64-apple-darwin*|i?86-apple-darwin*)
					XCSDK=macosx
					;;
			esac])
		if test x"$XCSDK" = x"" || test x"$XCSDK" = x"no" ; then
			XCSDK=""
			AC_MSG_RESULT([none])
		else
			AC_MSG_RESULT([$XCSDK])
		fi
	fi
	if ! test x"$XCSDK" = x"" ; then
		test -z "$CC" && CC="$XCRUN -sdk $XCSDK clang"
		test -z "$CPP" && CPP="$XCRUN -sdk $XCSDK clang -E"
		test -z "$CXX" && CXX="$XCRUN -sdk $XCSDK clang -x c++"
		test -z "$CXXCPP" && CXXCPP="$XCRUN -sdk $XCSDK clang -x c++ -E"
		test -z "$NM" && NM="$XCRUN -sdk $XCSDK nm"
		test -z "$AR" && AR="$XCRUN -sdk $XCSDK ar"
		test -z "$RANLIB" && RANLIB="$XCRUN -sdk $XCSDK ranlib"
		test -z "$AS" && AS="$XCRUN -sdk $XCSDK as"
	fi
fi
])
