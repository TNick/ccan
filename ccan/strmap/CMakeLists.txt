set( CCAN_LIB_DEPENDS
    ccan_ilog
    ccan_str
)

set( CCAN_H_DEPENDS
    ccan_short_types
    ccan_tcon
    ccan_typesafe_cb
)

ccan_helper_create_module("ccan_strmap" 1 0 0)
