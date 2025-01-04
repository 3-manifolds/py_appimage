PREFIX=`pwd`/app_root
PREFIX=`realpath $PREFIX`
cd `dirname $0`
VERSION=3.4
LONG_VERSION=3.4.0
SRC_DIR=openssl-${LONG_VERSION}
SRC_ARCHIVE=openssl-${LONG_VERSION}.tar.gz
URL=https://github.com/openssl/openssl/releases/download/openssl-${LONG_VERSION}/openssl-${LONG_VERSION}.tar.gz
HASH=e15dda82fe2fe8139dc2ac21a36d4ca01d5313c75f99f46c4e8a27709b7294bf

if ! [ -e ${SRC_ARCHIVE} ]; then
    curl -L -O ${URL}
fi
ACTUAL_HASH=`/usr/bin/shasum -a 256 ${SRC_ARCHIVE}  | cut -f 1 -d' '`
if [[ ${ACTUAL_HASH} != ${HASH} ]]; then
    echo Invalid hash value for ${SRC_ARCHIVE}
    exit 1
fi
if ! [ -d ${SRC_ARCHIVE} ]; then
    tar xvfz ${SRC_ARCHIVE}
fi
pushd ${SRC_DIR}
if [ -e Makefile ]; then
    make distclean
fi
./Configure --prefix=${PREFIX}
make -j4 install_runtime
make -j4 install_programs
make -j4 install_ssldirs
make -j4 install_dev
patchelf --add-rpath '$ORIGIN/../lib64' $PREFIX/bin/openssl
rm $PREFIX/bin/c_rehash
popd
