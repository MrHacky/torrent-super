# packages: cmake git make autoconf automake libtool gcc g++ libboost-dev libboost-system-dev libqt4-dev

Cmake_Minimum_Required(VERSION 3.0)

Project("torrent-super")

Include(ExternalProject)

Find_Program(CMD_GIT NAMES git)

File(GLOB PATCHES_LIBTORRENT "${CMAKE_CURRENT_SOURCE_DIR}/patches/libtorrent/*")

Set(FIX_ARM_PATHS FALSE CACHE TYPE BOOL)

If(FIX_ARM_PATHS)
	Set(FIX_ARM_LIBTORRENT --with-boost-system=boost_system)
	Set(FIX_ARM_QBITTORRENT --with-boost-libdir=/usr/lib/arm-linux-gnueabihf)
EndIf()

ExternalProject_Add(libtorrent
    GIT_REPOSITORY "https://github.com/arvidn/libtorrent.git"
    #GIT_TAG "libtorrent-1_0_6"
    GIT_TAG "RC_0_16"

    PATCH_COMMAND "${CMD_GIT}" apply -p0 ${PATCHES_LIBTORRENT}
    BUILD_IN_SOURCE 1

    CONFIGURE_COMMAND ./autotool.sh
    COMMAND ./configure --enable-debug=no --enable-shared=no --enable-static=yes --prefix "${CMAKE_CURRENT_BINARY_DIR}/libtorrent-prefix" ${FIX_ARM_LIBTORRENT}
)

File(GLOB PATCHES_QBITTORRENT "${CMAKE_CURRENT_SOURCE_DIR}/patches/qbittorrent/*")

ExternalProject_Add(qbittorrent
    DEPENDS libtorrent

    #GIT_REPOSITORY "https://github.com/MrHacky/qBittorrent.git"
    GIT_REPOSITORY "https://github.com/qbittorrent/qBittorrent.git"
    GIT_TAG "release-3.2.1"

    PATCH_COMMAND "${CMD_GIT}" apply -p1 ${PATCHES_QBITTORRENT}
    BUILD_IN_SOURCE 1

    CONFIGURE_COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/config-qbittorrent.sh" "${CMAKE_CURRENT_BINARY_DIR}" --disable-gui --with-libtorrent-rasterbar0.16 --prefix=${CMAKE_CURRENT_BINARY_DIR}/qbittorrent-prefix ${FIX_ARM_QBITTORRENT}
)
