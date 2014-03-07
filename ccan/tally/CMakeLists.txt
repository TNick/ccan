set( CCAN_LIB_DEPENDS
    ccan_likely
)

set( CCAN_H_DEPENDS
    ccan_build_assert
)

ccan_helper_create_module("ccan_tally" 1 0 0)
