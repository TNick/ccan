set( CCAN_LIB_DEPENDS
    ccan_ilog
    ccan_likely
)

set( CCAN_H_DEPENDS
    ccan_alignof
    ccan_build_assert
    ccan_compiler
    ccan_short_types
)

ccan_helper_create_module("ccan_antithread_alloc" 1 0 0)
