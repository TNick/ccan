set( CCAN_MOD_DEPENDENCIES
    ccan_take
    # TODO: libs - talloc

    # ccan_tal # circular dependency
    ccan_tal_str
    ccan_str
    ccan_typesafe_cb
)

ccan_helper_create_module("ccan_tal_talloc" 1 0 0)
