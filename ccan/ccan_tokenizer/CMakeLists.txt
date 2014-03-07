set( CCAN_LIB_DEPENDS
    ccan_talloc
)

set( CCAN_H_DEPENDS
    ccan_darray
)

ccan_helper_create_module("ccan_tokenizer" 1 0 0)
