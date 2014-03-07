ccan_helper_create_module("ccan_antithread_alloc" 1 0 0)

string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_U)

# the version as known to CMake
set ( ${PROJECT_NAME_U}_MAJOR_VERSION 1)
set ( ${PROJECT_NAME_U}_MINOR_VERSION 0)
set ( ${PROJECT_NAME_U}_PATCH_VERSION 0)
set ( ${PROJECT_NAME_U}_VERSION
  "${${PROJECT_NAME_U}_MAJOR_VERSION}.${${PROJECT_NAME_U}_MINOR_VERSION}.${${PROJECT_NAME_U}_PATCH_VERSION}")

# header files to be installed
set ( HEADER_FILES
    # TODO: do we need headers installed? Where?
)

# our library
add_library( ${PROJECT_NAME} STATIC EXCLUDE_FROM_ALL
    alloc.c
    bitops.c
    tiny.c
)

set( CCAN_LIB_DEPENDS
    ccan_ilog
    ccan_likely
    ccan_short_types
)

set( CCAN_H_DEPENDS
    ccan_alignof
    ccan_build_assert
    ccan_compiler
    ccan_short_types
)

# associate header files with our target
set ( BUILDED_HEADER_FILES )
foreach(HEADER_FILE ${HEADER_FILES})
    add_custom_command(TARGET ${PROJECT_NAME} PRE_BUILD
        COMMAND ${CMAKE_COMMAND} -E
            copy "${CMAKE_CURRENT_SOURCE_DIR}/${HEADER_FILE}" "${PROJECT_BINARY_DIR}/ccamtmp/${HEADER_FILE}"
        VERBATIM
    )
    set ( BUILDED_HEADER_FILES
        ${BUILDED_HEADER_FILES}
        "${PROJECT_BINARY_DIR}/ccamtmp/${HEADER_FILE}"
    )
endforeach()

# install header files only if the target was requested
if( HEADER_FILES )
    install(FILES ${BUILDED_HEADER_FILES}
        DESTINATION "${CCAN_INSTALL_HEADERS}"
        OPTIONAL
    )
endif( HEADER_FILES )

# __EM__

