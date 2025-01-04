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

Tarball:
	tar cfz app_root-${PYTHON_VERSION}.tgz app_root
	shasum app_root-${PYTHON_VERSION}.tgz > app_root-${PYTHON_VERSION}.sha1 

