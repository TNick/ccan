set( CCAN_LIB_DEPENDS
    ccan_tal
    ccan_list
)

set( CCAN_H_DEPENDS
    ccan_container_of
)

ccan_helper_create_module("ccan_tal_link" 1 0 0)
