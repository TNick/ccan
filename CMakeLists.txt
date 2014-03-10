# ----------------------------------------------------------------------------
# prepare

cmake_minimum_required(VERSION 2.8.8)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/")
# ============================================================================


# ----------------------------------------------------------------------------
# configure the project

set ( LOC_PRJ_NAME "ccan_top_level" )
project( ${LOC_PRJ_NAME} )

# Find includes in corresponding build directories
set ( CMAKE_INCLUDE_CURRENT_DIR ON)

set ( CCAN_INSTALL_HEADERS "include" CACHE FILEPATH "Install location for header files")

# allow #include <ccan/MODULE/file.h>
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

if   (CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_definitions( -DDEBUG=1 -D_DEBUG=1 )
else (CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_definitions( -DNDEBUG=1 -D_NDEBUG=1 )
endif (CMAKE_BUILD_TYPE STREQUAL "Debug")
add_definitions( -D_GNU_SOURCE )

include(ccanHelperMacros)
include(ccanChecks)

# ============================================================================


# ----------------------------------------------------------------------------
# external libraries

find_package(Vorbis)
include_directories(${VORBIS_INCLUDE_DIRS})

find_package(PortAudio)
include_directories(${PORTAUDIO_INCLUDE_DIRS})

find_package(Judy)
include_directories(${JUDY_INCLUDE_DIRS})

# ============================================================================


# ----------------------------------------------------------------------------
# modules

set( CCAN_MODS_NO_SRC
    "ccan_alignof"
    "ccan_argcheck"
    "ccan_array_size"
    "ccan_asearch"
    "ccan_bitmap"
    "ccan_build_assert"
    "ccan_bytestring"
    "ccan_cast"
    "ccan_check_type"
    "ccan_compiler"
    "ccan_container_of"
    "ccan_darray"
    "ccan_endian"
    "ccan_objset"
    "ccan_short_types"
    "ccan_tcon"
    "ccan_tlist"
    "ccan_typesafe_cb"
    "ccan_version"
)

set( CCAN_MODS_WITH_SRC
    "ccan_version"
    "ccan_"
    "ccan_antithread"
    "ccan_antithread_alloc"
    "ccan_asort"
    "ccan_asprintf"
    "ccan_autodata"
    "ccan_avl"
    "ccan_bdelta"
    "ccan_block_pool"
    "ccan_breakpoint"
    "ccan_btree"
    "ccan_tokenizer"
    "ccan_charset"
    "ccan_ciniparser"
    "ccan_crc"
    "ccan_crcsync"
    "ccan_cpuid"
    "ccan_daemonize"
    "ccan_daemon_with_notify"
    "ccan_dgraph"
    "ccan_err"
    "ccan_failtest"
    "ccan_foreach"
    "ccan_grab_file"
    "ccan_hash"
    "ccan_heap"
    "ccan_htable"
    "ccan_idtree"
    "ccan_ilog"
    "ccan_io"
    "ccan_isaac"
    "ccan_iscsi"
    "ccan_jmap"
    "ccan_json"
    "ccan_jset"
    "ccan_lbalance"
    "ccan_likely"
    "ccan_list"
    "ccan_md4"
    "ccan_net"
    "ccan_nfs"
    "ccan_noerr"
    "ccan_ogg_to_pcm"
    "ccan_opt"
    "ccan_ptr_valid"
    "ccan_rbtree"
    "ccan_rbuf"
    "ccan_read_write_all"
    "ccan_rfc822"
    "ccan_siphash"
    "ccan_sparse_bsearch"
    "ccan_str"
    "ccan_stringmap"
    "ccan_strmap"
    "ccan_strset"
    "ccan_str_talloc"
    "ccan_take"
    "ccan_tal"
    "ccan_tal_link"
    "ccan_tal_path"
    "ccan_tal_str"
    "ccan_tal_talloc"
    "ccan_talloc"
    "ccan_talloc_link"
    "ccan_tally"
    "ccan_tap"
    "ccan_time"
    "ccan_timer"
    "ccan_ttxml"
    "ccan_wwviaudio"
)

set( CCAN_MODS_ALL ${CCAN_MODS_NO_SRC} ${CCAN_MODS_WITH_SRC} )

# ============================================================================


add_subdirectory( "ccan" )
add_subdirectory( "junkcode" )
