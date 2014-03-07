set( CCAN_LIB_DEPENDS
    ccan_err
    ccan_hash
    ccan_htable
    ccan_read_write_all
    ccan_str
    ccan_time
)

set( CCAN_H_DEPENDS
    ccan_build_assert
    ccan_compiler
    ccan_tlist
)

ccan_helper_create_module("ccan_failtest" 1 0 0)
