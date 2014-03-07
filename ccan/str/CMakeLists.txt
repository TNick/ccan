set( CCAN_H_DEPENDS
    ccan_build_assert
)

# TODO
#if( ${CMAKE_BUILD_TYPE} STREQUAL "" )
#set ( SOURCE_FILES
#    ${SOURCE_FILES}
#    debug.c
#)
#endif( ${CMAKE_BUILD_TYPE} STREQUAL "" )

ccan_helper_create_module("ccan_str" 1 0 0)
