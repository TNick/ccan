set( CCAN_H_DEPENDS
    ccan_build_assert # TODO: only if !HAVE_TYPEOF
)

ccan_helper_create_module("ccan_check_type" 1 0 0)
