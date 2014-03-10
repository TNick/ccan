# dongre.avinash@gmail.com-clibutils\n

set( SRC
    src/c_array.c
    src/c_heap.c
    src/c_rb.c
    src/c_slist.c
    src/c_util.c
    src/c_deque.c
    src/c_map.c
    src/c_set.c
    src/c_stack.c
)

set( HEADERS
    inc/c_array.h
    inc/c_errors.h
    inc/c_lib.h
    inc/c_rb.h
    inc/c_slist.h
    inc/c_deque.h
    inc/c_heap.h
    inc/c_map.h
    inc/c_set.h
    inc/c_stack.h
)

include_directories("${CMAKE_CURRENT_SOURCE_DIR}/inc")
add_library( "ccanj_clibutils" STATIC EXCLUDE_FROM_ALL
    ${SRC}
)
