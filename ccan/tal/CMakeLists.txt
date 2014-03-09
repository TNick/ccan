set( CCAN_MOD_DEPENDENCIES
    ccan_str
    ccan_tal
    ccan_tal_talloc
    ccan_take
)

ccan_helper_create_module("ccan_tal" 1 0 0)

add_subdirectory(str)
add_subdirectory(link)
add_subdirectory(path)
add_subdirectory(talloc)
