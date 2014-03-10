# henryeshbaugh@gmail.com-log\n
set( SRC
    log.c
)

set( HEADERS
    log.h
)

add_library( "ccanj_log" STATIC EXCLUDE_FROM_ALL
    ${SRC}
)
