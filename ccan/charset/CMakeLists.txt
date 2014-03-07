set( CCAN_LIB_DEPENDS
    ccan_antithread_alloc
    # TODO: libm
)

set( CCAN_H_DEPENDS
    ccan_likely
)

ccan_helper_create_module("ccan_charset" 1 0 0)
