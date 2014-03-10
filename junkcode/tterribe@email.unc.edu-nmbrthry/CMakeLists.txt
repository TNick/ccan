#tterribe@email.unc.edu-nmbrthry\n

set( HEADERS
    choose.h
    crt.h
    egcd.h
    gcd.h
)

set( SRC
    choose.c
    crt.c
    egcd.c
    gcd.c
)

add_library( "ccanj_nmbrthry" STATIC EXCLUDE_FROM_ALL
    ${SRC}
)
