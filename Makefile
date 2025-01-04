PYTHON_VERSION=3.13

all: Setup OpenSSL TclTk Sqlite Python

.PHONY: Setup OpenSSL TclTk Sqlite Python Tarball 

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
	bash Python-${PYTHON_VERSION}/build_python.sh

Tarball:
	tar cfz app_root-${PYTHON_VERSION}.tgz app_root
	shasum app_root-${PYTHON_VERSION}.tgz > app_root-${PYTHON_VERSION}.sha1 

### Need to install snappy inside the app root before running this
SnapPyApp:
	find app_root -name '*.a' -delete
	rm -rf app_root/lib/python3.13/test
	rm -rf app_root/lib/python3.13/idlelib/
	cp app_files/* app_root
	mv app_root SnapPy-3.2a-x86_64.AppDir
	bin/appimagetool SnapPy-3.2a-x86_64.AppDir
