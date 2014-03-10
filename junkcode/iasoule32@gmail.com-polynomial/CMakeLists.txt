# iasoule32@gmail.com-polynomial\n
set( SRC
    polynomial_adt.c
)

set( HEADERS
    polynomial_adt.h
)

add_library( "ccanj_polynomial" STATIC EXCLUDE_FROM_ALL
    ${SRC}
)
