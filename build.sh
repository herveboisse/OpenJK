#!/bin/bash

export CC=clang CXX=clang++ LD=lld

ncpu=$(grep -c '^processor' /proc/cpuinfo)
: ${ncpu:=1}


case "${1}" in

"clean")
	rm -rf build install
	;;

""|"build")
	mkdir -pv build
	cmake \
		-B build/ \
		-DCMAKE_INSTALL_PREFIX=./install \
		-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-DBuildPortableVersion=ON \
		-DBuildJK2SPEngine=ON \
		-DBuildJK2SPGame=ON \
		-DBuildJK2SPRdVanilla=ON \
		-DOpenGL_GL_PREFERENCE=GLVND \
		|| exit 1

	cmake \
		--build build/ \
		-j${ncpu} \
		|| exit 1

	cmake --install build/ || exit 1
	if [ ! -e install/JediOutcast/base ]; then
		ln -sv ../../base_jo install/JediOutcast/base
	fi
	if [ ! -e install/JediAcademy/base ]; then
		ln -sv ../../base_ja install/JediAcademy/base
	fi
	;;

*)
	echo "unknown command" >&2
	exit 1
	;;
esac

