# ----------------------------------------------------------------------------
# prepare

cmake_minimum_required(VERSION 2.8.8)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")
# ============================================================================



# ----------------------------------------------------------------------------
# configure the project

set ( LOC_PRJ_NAME "ccan" )
# project( ${LOC_PRJ_NAME} )
# ============================================================================



# ----------------------------------------------------------------------------
# external libraries

# ============================================================================



# ----------------------------------------------------------------------------
# modules

# a fake target to be able to build all modules
add_custom_target( ccan_modules )

set ( ccan_modules_list
    "alignof"
    "antithread"
    "argcheck"
    "array_size"
    "asearch"
    "asort"
    "asprintf"
    "autodata"
    "avl"
    "bdelta"
    "bitmap"
    "block_pool"
    "breakpoint"
    "btree"
    "build_assert"
    "bytestring"
    "cast"
    "ccan_tokenizer"
    "charset"
    "check_type"
    "ciniparser"
    "compiler"
    "container_of"
    "cpuid"
    "crc"
    "crcsync"
    "daemonize"
    "daemon_with_notify"
    "darray"
    "dgraph"
    "endian"
    "err"
    "failtest"
    "foreach"
    "grab_file"
    "hash"
    "heap"
    "htable"
    "idtree"
    "ilog"
    "io"
    "isaac"
    "iscsi"
    "jmap"
    "jset"
    "json"
    "lbalance"
    "likely"
    "list"
    "md4"
    "net"
    "nfs"
    "noerr"
    "objset"
    "ogg_to_pcm"
    "opt"
    "ptr_valid"
    "rbtree"
    "rbuf"
    "read_write_all"
    "rfc822"
    "short_types"
    "siphash"
    "sparse_bsearch"
    "str"
    "stringmap"
    "strmap"
    "strset"
    "str_talloc"
    "take"
    "tal"
    "talloc"
    "talloc_link"
    "tally"
    "tap"
    "tcon"
    "time"
    "timer"
    "tlist"
    "ttxml"
    "typesafe_cb"
    "version"
    "wwviaudio"
)


# add component modules; link them to ccan_modules terget
FOREACH ( mod ${ccan_modules_list} )
    add_subdirectory( "${mod}" )
    add_dependencies( ccan_modules
        "ccan_${mod}"
    )
ENDFOREACH(mod)
# ============================================================================

