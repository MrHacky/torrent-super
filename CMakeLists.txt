# packages: cmake git autoconf automake libtool gcc libboost-dev libboost-system-dev libqt4-dev BOOST_DATETIME BOOST++

Cmake_Minimum_Required(VERSION 3.0)

Project("torrent-super")

Include(ExternalProject)

Find_Program(CMD_GIT NAMES git)

File(GLOB PATCHES_LIBTORRENT "${CMAKE_CURRENT_SOURCE_DIR}/patches/libtorrent/*")

ExternalProject_Add(libtorrent
    GIT_REPOSITORY "https://github.com/arvidn/libtorrent.git"
    #GIT_TAG "libtorrent-1_0_6"
    GIT_TAG "RC_0_16"

    PATCH_COMMAND "${CMD_GIT}" apply -p0 ${PATCHES_LIBTORRENT}
    BUILD_IN_SOURCE 1

    CONFIGURE_COMMAND ./autotool.sh
    COMMAND ./configure --enable-debug=no --enable-shared=no --enable-static=yes --prefix "${CMAKE_CURRENT_BINARY_DIR}/libtorrent-prefix"
)

#File(GLOB PATCHES_QBITTORRENT "${CMAKE_CURRENT_SOURCE_DIR}/patches/qbittorrent/*")

ExternalProject_Add(qbittorrent
    DEPENDS libtorrent

    #GIT_REPOSITORY "https://github.com/MrHacky/qBittorrent.git"
    GIT_REPOSITORY "https://github.com/qbittorrent/qBittorrent.git"
    GIT_TAG "release-3.2.1"

    #PATCH_COMMAND "${CMD_GIT}" apply -p1 ${PATCHES_QBITTORRENT}
    BUILD_IN_SOURCE 1

    CONFIGURE_COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/config-qbittorrent.sh" ${CMAKE_CURRENT_BINARY_DIR}
)
