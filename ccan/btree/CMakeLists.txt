set( CCAN_MOD_DEPENDENCIES
    ccan_antithread_alloc
    ccan_err
    ccan_list
    ccan_noerr
    ccan_read_write_all
    ccan_talloc
    ccan_likely
    ccan_compiler
)

ccan_helper_create_module("ccan_btree" 1 0 0)
