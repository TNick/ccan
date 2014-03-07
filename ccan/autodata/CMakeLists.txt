set( CCAN_LIB_DEPENDS
    ccan_ptr_valid
)

set( CCAN_H_DEPENDS
    ccan_compiler
)

ccan_helper_create_module("ccan_autodata" 1 0 0)
