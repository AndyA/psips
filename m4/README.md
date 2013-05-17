This is a library of m4 macros which may be useful in autoconf projects.

A Makefile.am if included, so that this tree can be dropped into a project
as a submodule.

Be sure to add the following to your top-level `Makefile.am`:

	ACLOCAL_AMFLAGS = -I m4

And add the following to your top-level `configure.ac`:
	
	AC_CONFIG_MACRO_DIR([m4])

The license terms for each `.m4` file are included within the files
themselves.

All macros are prefixed with `BT_` (standing for "buildtools", the project
which preceded this one).

The included macros are:

* `BT_PROG_CC_WARN`: Enable the `-W -Wall` C compiler flags if using GCC.
* `BT_DEFINE_PREFIX`: Define `PREFIX`, `EXEC_PREFIX`, `LIBDIR` and `INCLUDEDIR` so that they're available at build-time.
* `BT_ENABLE_DOCS`: Enable building HTML and manpages from DocBook-XML.
* `BT_ENABLE_NLS`: Check for NLS support.
* `BT_CHECK_MYSQL`, `BT_REQUIRE_MYSQL`: Check for MySQL client libraries.
* `BT_CHECK_LIBUUID`, `BT_REQUIRE_LIBUUID`: Check for the library containing `uuid_compare()`.
* `BT_CHECK_LIBEDIT`, `BT_REQUIRE_LIBEDIT`: Check for the library containing `libedit`, which may be included in the source tree.
* `BT_CHECK_LIBURI`, `BT_REQUIRE_LIBURI`: Build an in-tree copy of `liburi`.
* `BT_CHECK_LIBTIFF`, `BT_REQUIRE_LIBTIFF`: Check for `libtiff`.

In addition, `lib.m4` defines `BT_CHECK_LIB`, a generic framework for
checking for libraries, including support for dealing with bundled
sub-projects within the source tree.

`BT_CHECK_LIB` is defined as:

	BT_CHECK_LIB(name, [local-subdir], [pkg-config modules], [test-code],
		[use-local-code], [action-if-found],[action-if-not-found])

`name` is the name of the library, such as `libtiff`, and is used to
construct variables and help strings.

If `local-subdir` is specified, it is the name of the subdirectory within
the source tree which will optionally contain a bundled copy of the library.

`pkg-config modules` is a list of `pkg-config` modules which, if specified,
will be tested for and whose `cflags` and `libs` will be used to populate
`NAME_CPPFLAGS` and `NAME_LIBS` if found.

`test-code` is a fragment which will test for the presence of the library,
and set `have_name` to `yes` if it is present (e.g., `have_libtiff=yes`).
The fragment should not invoke `AC_MSG_ERROR` if the library is not found.

`use-local-code` is a fragment which will be invoked if the bundled copy
of the code is selected. It should set the variables `NAME_CPPFLAGS`,
`NAME_LDFLAGS`, `NAME_LIBS` and `NAME_LOCAL_LIBS` as necessary.

If `action-if-found` is omitted, `AM_CPPFLAGS`, `AM_LDFLAGS`, `LIBS` and
`LOCAL_LIBS` will be updated if the library was found. If
`action-if-not-found` is ommitted, no action will be performed if the
library was not found.
