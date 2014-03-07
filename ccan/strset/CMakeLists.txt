set( CCAN_LIB_DEPENDS
    ccan_ilog
    ccan_str
    ccan_likely
)

set( CCAN_H_DEPENDS
    ccan_short_types
    ccan_typesafe_cb
)

ccan_helper_create_module("ccan_strset" 1 0 0)
