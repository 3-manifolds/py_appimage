#!/bin/bash
set -e

TCL_VERSION=9.0.1
TK_VERSION=9.0.1

TCL_TARBALL=tcl-core${TCL_VERSION}-src.tar.gz
TK_TARBALL=tk${TK_VERSION}-src.tar.gz

mkdir Tcl Tk

curl -L -O https://prdownloads.sourceforge.net/tcl/${TCL_TARBALL}
curl -L -O https://prdownloads.sourceforge.net/tcl/${TK_TARBALL}

tar xf ${TCL_TARBALL} --directory=Tcl --strip-components=1
tar xf ${TK_TARBALL} --directory=Tk --strip-components=1
