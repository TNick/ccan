set( CCAN_LIB_DEPENDS
    ccan_time
    ccan_timer
)

ccan_helper_create_module("ccan_io" 1 0 0)

# TODO: there is also a benchmarks directory
