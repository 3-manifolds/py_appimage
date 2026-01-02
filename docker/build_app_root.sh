#!/usr/bin/bash
docker run -d -t --name app_root_builder appimage_root/2014:v1 bash
docker exec -w /tmp app_root_builder git clone https://github.com/3-manifolds/py_appimage
docker exec -w /tmp app_root_builder make -C py_appimage
#docker exec -w /tmp app_root_builder make -C py_appimage DockerFix
docker exec -w /tmp app_root_builder make -C py_appimage Tarball
docker cp app_root_builder:/tmp/py_appimage/app_root-3.14.tgz .
docker cp app_root_builder:/tmp/py_appimage/app_root-3.14.sha256 .
docker stop app_root_builder
docker container rm app_root_builder
