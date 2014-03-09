set( CCAN_MOD_DEPENDENCIES
    ccan_ilog
    ccan_likely
    ccan_alignof
    ccan_build_assert
    ccan_compiler
    ccan_short_types
)

ccan_helper_create_module("ccan_antithread_alloc" 1 0 0)
