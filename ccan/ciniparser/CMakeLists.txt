set( CCAN_LIB_DEPENDS
    ccan_antithread_alloc
)

set( CCAN_H_DEPENDS
    ccan_likely
)

ccan_helper_create_module("ccan_ciniparser" 1 0 0)
