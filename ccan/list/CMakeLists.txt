set( CCAN_LIB_DEPENDS
    ccan_str
)

set( CCAN_H_DEPENDS
    ccan_container_of
    ccan_check_type
)

ccan_helper_create_module("ccan_list" 1 0 0)
