PYTHON_VERSION=3.13

all: Setup OpenSSL TclTk Sqlite Python Smaller

.PHONY: Setup OpenSSL TclTk Sqlite Python Smaller DockerFix Tarball 

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
	rm -rf app_root/share/man

# This does not work well enough to provide a readline module.
# Currently we disable the readline module when configuring Python.

DockerFix:
	cp -rp /usr/share/terminfo app_root/share
	cp /usr/lib64/libncursesw.so.5.9 app_root/lib64
	patchelf --add-rpath '$$ORIGIN' app_root/lib64/libncursesw.so.5.9
	ln -s libncursesw.so.5.9 app_root/lib64/libncursesw.so
	ln -s libncursesw.so.5.9 app_root/lib/libncursesw.so.5
	cp /usr/lib64/libtinfo.so.5.9 app_root/lib64
	ln -s libtinfo.so.5.9 app_root/lib64/libtinfo.so.5
	ln -s libtinfo.so.5.9 app_root/lib64/libtinfo.so
	cp /usr/lib64/libeditline.so.1.0.2 app_root/lib64
	ln -s libeditline.so.1.0.2 app_root/lib64/libeditline.so.1
	ln -s libeditline.so.1.0.2 app_root/lib64/libeditline.so
	cp /usr/lib64/libedit.so.0.0.42 app_root/lib64
	patchelf --add-rpath '$$ORIGIN' app_root/lib64/libedit.so.0.0.42
	ln -s libedit.so.0.0.42 app_root/lib64/libedit.so.0
	ln -s libedit.so.0.0.42 app_root/lib64/libedit.so
	patchelf --add-rpath '$$ORIGIN/../..' app_root/lib/python3.13/lib-dynload/_curses.cpython-313-x86_64-linux-gnu.so
	patchelf --add-rpath '$$ORIGIN/../..' app_root/lib/python3.13/lib-dynload/readline.cpython-313-x86_64-linux-gnu.so

Tarball:
	tar cfz app_root-${PYTHON_VERSION}.tgz app_root
	sha256sum app_root-${PYTHON_VERSION}.tgz > app_root-${PYTHON_VERSION}.sha256 

