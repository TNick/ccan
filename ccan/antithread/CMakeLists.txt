set( CCAN_LIB_DEPENDS
    ccan_antithread_alloc
    ccan_err
    ccan_list
    ccan_noerr
    ccan_read_write_all
    ccan_talloc
)

ccan_helper_create_module("ccan_antithread" 1 0 0)
