set -e
PREFIX=`pwd`/app_root
PREFIX=`realpath $PREFIX`
cd `dirname $0`
VERSION=3.14
LONG_VERSION=3.14.2
TCLTK_VERSION=9.0
VRSN=314
SRC_DIR=Python-${LONG_VERSION}
SRC_ARCHIVE=Python-${LONG_VERSION}.tgz
URL=https://www.python.org/ftp/python/${LONG_VERSION}/${SRC_ARCHIVE}
HASH=213fdd3cf28e89e2d779b6ae444ae8aa
TCL_HEADERS=${PREFIX}/include
TCL_LIB=libtcl${TCLTK_VERSION}.so
TK_HEADERS=${PREFIX}/include
TK_LIB=libtcl9tk${TCLTK_VERSION}.so
OPENSSL=${PREFIX}/ssl
SQLITE=${PREFIX}/sqlite

if ! [ -e ${SRC_ARCHIVE} ]; then
    echo Downloading ${URL}
    curl -O ${URL}
fi
ACTUAL_HASH=`md5sum ${SRC_ARCHIVE} | cut -f1 -d' '`
if [[ ${ACTUAL_HASH} != ${HASH} ]]; then
    echo Invalid hash value for ${SRC_ARCHIVE}
    exit 1
fi
if ! [ -d ${SRC_DIR} ]; then
    tar xfz ${SRC_ARCHIVE}
    cd ${SRC_DIR}
    patch -p1 < ../patches/tkinter.patch
    patch -p1 < ../patches/pyrepl.patch
    cd ..
fi
if ! [ -d dist ]; then
    mkdir dist
fi
# Clean the build directory
rm -rf dist/Python.framework
pushd ${SRC_DIR}
if [ -e Makefile ]; then
    make distclean
fi

# Use our custom versions of Tcl and Tk
export TCLTK_CFLAGS="-I${TCL_HEADERS} -I${TK_HEADERS}"
export TCLTK_LIBS="${PREFIX}/lib/${TCL_LIB} ${PREFIX}/lib/${TK_LIB}"

# Configure
./configure \
    LDFLAGS=-L${PREFIX}/lib \
    CPPFLAGS=-I${PREFIX}/include \
    --prefix=${PREFIX} --with-openssl=${PREFIX} \
    --with-openssl-rpath=${PREFIX}/lib \
    --with-readline=no
	    
make -j4
make install
popd

# Create relative rpaths for the  _ssl, _hashlib and _sqlite3 extension modules
LIB_DYNLOAD=${PREFIX}/lib/python${VERSION}/lib-dynload
patchelf --set-rpath '$ORIGIN/../..' ${LIB_DYNLOAD}/_ssl.*.so
patchelf --set-rpath '$ORIGIN/../..' ${LIB_DYNLOAD}/_hashlib.*.so
patchelf --set-rpath '$ORIGIN/../..' ${LIB_DYNLOAD}/_sqlite3.*.so

# Create relative rpaths for the _tkinter extension module
patchelf --replace-needed ${PREFIX}/lib/${TCL_LIB} ${TCL_LIB} \
    ${LIB_DYNLOAD}/_tkinter.*.so
patchelf --replace-needed ${PREFIX}/lib/${TK_LIB} ${TK_LIB} \
    ${LIB_DYNLOAD}/_tkinter.*.so
patchelf --add-rpath '$ORIGIN/../..' ${LIB_DYNLOAD}/_tkinter.*.so 
