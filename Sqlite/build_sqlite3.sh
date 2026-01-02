set -e
PREFIX=`pwd`/app_root
PREFIX=`realpath $PREFIX`
cd `dirname $0`
VERSION=3.51.1
VN=3510100
SRC_DIR=sqlite-autoconf-${VN}
SRC_ARCHIVE=${SRC_DIR}.tar.gz
URL=https://sqlite.org/2025/sqlite-autoconf-${VN}.tar.gz
HASH=4f2445cd70479724d32ad015ec7fd37fbb6f6130013bd4bfbc80c32beb42b7e0

if ! [ -e ${SRC_ARCHIVE} ]; then
    curl -L -O ${URL}
fi
ACTUAL_HASH=`/usr/bin/sha256sum ${SRC_ARCHIVE}  | cut -f 1 -d' '`
if [[ ${ACTUAL_HASH} != ${HASH} ]]; then
    echo Invalid hash value for ${SRC_ARCHIVE}
    exit 1
fi
if ! [ -d ${SRC_ARCHIVE} ]; then
    tar xfz ${SRC_ARCHIVE}
fi
pushd ${SRC_DIR}
if [ -e Makefile ]; then
    make distclean
fi
./configure --prefix=${PREFIX}
make install
popd
