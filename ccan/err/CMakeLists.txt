set( CCAN_H_DEPENDS
    # TODO: only if !HAVE_ERR_H
    ccan_compiler
)

ccan_helper_create_module("ccan_err" 1 0 0)
