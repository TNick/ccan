set( CCAN_LIB_DEPENDS
    ccan_ilog
    ccan_likely
    ccan_list
    ccan_time
)

set( CCAN_H_DEPENDS
    ccan_array_size
)

ccan_helper_create_module("ccan_timer" 1 0 0)
