set -e
PREFIX=`pwd`/app_root
PREFIX=`realpath $PREFIX`
cd `dirname $0`
VERSION=3.47.2
VN=3470200
SRC_DIR=sqlite-autoconf-${VN}
SRC_ARCHIVE=${SRC_DIR}.tar.gz
URL=https://www.sqlite.org/2024/${SRC_ARCHIVE}
HASH=f1b2ee412c28d7472bc95ba996368d6f0cdcf00362affdadb27ed286c179540b

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
