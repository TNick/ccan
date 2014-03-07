set( CCAN_LIB_DEPENDS
    ccan_ilog
)

ccan_helper_create_module("ccan_isaac" 1 0 0)

# TODO: only build *64 when building for x64?
