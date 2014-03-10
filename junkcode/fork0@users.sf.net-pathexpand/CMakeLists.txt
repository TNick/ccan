# fork0@users.sf.net-pathexpand\n

set( SRC
    pathexpand.c
)

set( HEADERS
)

add_library( "ccanj_pathexpand" STATIC EXCLUDE_FROM_ALL
    ${SRC}
)
