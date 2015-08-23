#!/bin/sh

CMAKE_CURRENT_BINARY_DIR=$1
export CPPFLAGS=-DBOOST_ASIO_SEPARATE_COMPILATION
export libtorrent_CFLAGS=-I${CMAKE_CURRENT_BINARY_DIR}/libtorrent-prefix/include
export libtorrent_LIBS=${CMAKE_CURRENT_BINARY_DIR}/libtorrent-prefix/lib/libtorrent-rasterbar.a\ -lssl\ -lm\ -lcrypto

shift
./configure "$@"
