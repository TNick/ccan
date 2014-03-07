set( CCAN_LIB_DEPENDS
    ccan_take
    # TODO: libs - talloc

    ccan_tal
    ccan_tal_str
    ccan_str

)

set( CCAN_H_DEPENDS
    ccan_typesafe_cb
)

ccan_helper_create_module("ccan_tal_talloc" 1 0 0)
