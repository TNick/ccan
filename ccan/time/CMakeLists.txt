set( CCAN_MOD_DEPENDENCIES
    # TODO: add rt if HAVE_CLOCK_GETTIME_IN_LIBRT
)

ccan_helper_create_module("ccan_time" 1 0 0)
