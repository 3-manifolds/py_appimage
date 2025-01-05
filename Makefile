PYTHON_VERSION=3.13

all: Setup OpenSSL TclTk Sqlite Python Smaller

.PHONY: Setup OpenSSL TclTk Sqlite Python Smaller Tarball 

Setup:
	rm -rf app_root
	mkdir -p app_root app_root/lib
	ln -s lib app_root/lib64

OpenSSL:
	bash OpenSSL/build_openssl.sh

TclTk:
	bash TclTk/build_tcltk.sh

Sqlite:
	bash Sqlite/build_sqlite3.sh

Python:
	bash Python/build_python.sh

Smaller:
	find app_root -name '*.a' -delete
	rm -rf app_root/lib/python3.13/lib/test
	rm -f app_root/lib/python3.13/lib-dynload/_test*
	rm -rf app_root/lib/python3.13/idlelib
	rm -f app_root/bin/idle*
	rm -rf app_root/share

DockerFix2014:
	cp /usr/lib64/libncursesw.so.5.9 app_root/lib64
	ln -s libncursesw.so.5.9 app_root/lib64/libncursesw.so
	ln -s libncursesw.so.5.9 app_root/lib/libncursesw.so.5
	cp /usr/lib64/libtinfo.so.5.9 app_root/lib64
	ln -s libtinfo.so.5.9 app_root/lib64/libtinfo.so.5
	ln -s libtinfo.so.5.9 app_root/lib64/libtinfo.so
	patchelf --add-rpath '$ORIGIN/../..' app_root/lib/python3.13/lib-dynload/_curses.cpython-313-x86_64-linux-gnu.so

Tarball:
	tar cfz app_root-${PYTHON_VERSION}.tgz app_root
	sha256sum app_root-${PYTHON_VERSION}.tgz > app_root-${PYTHON_VERSION}.sha256 

