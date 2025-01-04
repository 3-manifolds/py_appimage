set -e
PREFIX=`pwd`/app_root
PREFIX=`realpath $PREFIX`
cd `dirname $0`
pushd Tcl/unix
if [ -e Makefile ]; then
    make distclean
fi
./configure --prefix=$PREFIX
make -j6
make install
popd
pushd Tk/unix
if [ -e Makefile ]; then
    make distclean
fi
./configure --prefix=$PREFIX
make -j6
make install
popd
