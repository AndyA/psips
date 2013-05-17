DIST_SUBDIRS = m4 t

SUBDIRS = . t

ACLOCAL_AMFLAGS = -I m4

bin_PROGRAMS = psips

psips_SOURCES = psips.c

test: all
	cd t && $(MAKE) test

