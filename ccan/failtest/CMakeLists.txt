set( CCAN_MOD_DEPENDENCIES
    ccan_err
    ccan_hash
    ccan_htable
    ccan_read_write_all
    ccan_str
    ccan_time
    ccan_build_assert
    ccan_compiler
    ccan_tlist
)

ccan_helper_create_module("ccan_failtest" 1 0 0)
