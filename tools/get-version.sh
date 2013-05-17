#! /bin/sh

perl tools/version.pl > version.h
version=`cat VERSION`
printf "$version"
