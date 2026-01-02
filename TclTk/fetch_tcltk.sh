#!/bin/bash
set -e

TCL_VERSION=9.0.3
TK_VERSION=9.0.3

TCL_TARBALL=tcl-core${TCL_VERSION}-src.tar.gz
TK_TARBALL=tk${TK_VERSION}-src.tar.gz

curl -L -O https://prdownloads.sourceforge.net/tcl/${TCL_TARBALL}
curl -L -O https://prdownloads.sourceforge.net/tcl/${TK_TARBALL}

mkdir Tcl Tk
tar xf ${TCL_TARBALL} --directory=Tcl --strip-components=1
tar xf ${TK_TARBALL} --directory=Tk --strip-components=1
