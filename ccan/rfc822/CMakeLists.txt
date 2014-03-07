set( CCAN_H_DEPENDS
    ccan_bytestring
)

set( CCAN_LIB_DEPENDS
    #ifdef TAL_USE_TALLOC
    ccan_tal_talloc
    #else
    #ccan_tal
    #endif

    ccan_list
    ccan_str
)

ccan_helper_create_module("ccan_rfc822" 1 0 0)

# TODO: examples
