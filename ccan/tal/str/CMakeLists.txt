set( CCAN_MOD_DEPENDENCIES
    ccan_str
    # ccan_tal # circular dependency
    # ccan_tal_talloc # circular dependency
    ccan_take
)

ccan_helper_create_module("ccan_tal_str" 1 0 0)
