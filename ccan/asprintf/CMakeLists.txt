set( CCAN_H_DEPENDS
    ccan_compiler
)

ccan_helper_create_module("ccan_asprintf" 1 0 0)

# TODO: must add asprintf.c if the platform does not have one
