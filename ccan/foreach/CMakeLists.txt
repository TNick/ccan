set( CCAN_LIB_DEPENDS
    # only if !HAVE_COMPOUND_LITERALS || !HAVE_FOR_LOOP_DECLARATION
    ccan_list
)

ccan_helper_create_module("ccan_foreach" 1 0 0)
