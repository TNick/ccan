# ----------------------------------------------------------------------------
# prepare

cmake_minimum_required(VERSION 2.8.8)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/")
# ============================================================================



# ----------------------------------------------------------------------------
# configure the project

set ( LOC_PRJ_NAME "ccan_top_level" )
project( ${LOC_PRJ_NAME} )

# Find includes in corresponding build directories
set ( CMAKE_INCLUDE_CURRENT_DIR ON)

set ( CCAN_INSTALL_HEADERS "include" CACHE FILEPATH "Install location for header files")

# allow #include <ccan/MODULE/file.h>
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

if   (CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_definitions( -DDEBUG=1 -D_DEBUG=1 )
else (CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_definitions( -DNDEBUG=1 -D_NDEBUG=1 )
endif (CMAKE_BUILD_TYPE STREQUAL "Debug")
add_definitions( -D_GNU_SOURCE )
# ============================================================================



# ----------------------------------------------------------------------------
# find various characteristics of the system

include(CheckStructHasMember)
include(CheckTypeSize)
include(TestBigEndian)

CHECK_TYPE_SIZE(timespec STRUCT_TIMESPEC)
TEST_BIG_ENDIAN(WORDS_BIGENDIAN)
# ============================================================================



# ----------------------------------------------------------------------------
# external libraries

find_package(Vorbis)
include_directories(${VORBIS_INCLUDE_DIRS})

find_package(PortAudio)
include_directories(${PORTAUDIO_INCLUDE_DIRS})

find_package(Judy)
include_directories(${JUDY_INCLUDE_DIRS})

# ============================================================================

# ----------------------------------------------------------------------------
# helper macros

# module definitions
macro(ccan_helper_define_module ____PROJECT_NAME____ __VER_MAJOR__ __VER_MINOR__ __VER_PATCH__)
    set ( PROJECT_NAME ${____PROJECT_NAME____})

    string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_U)

    # the version as known to CMake
    set ( ${PROJECT_NAME_U}_MAJOR_VERSION __VER_MAJOR__)
    set ( ${PROJECT_NAME_U}_MINOR_VERSION __VER_MINOR__)
    set ( ${PROJECT_NAME_U}_PATCH_VERSION __VER_PATCH__)
    set ( ${PROJECT_NAME_U}_VERSION
      "${${PROJECT_NAME_U}_MAJOR_VERSION}.${${PROJECT_NAME_U}_MINOR_VERSION}.${${PROJECT_NAME_U}_PATCH_VERSION}")
endmacro(ccan_helper_define_module)

# gather headers and sources
macro(ccan_helper_collect_files)
    file(GLOB HEADER_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" *.h)
    file(GLOB SOURCE_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" *.c)
endmacro(ccan_helper_collect_files)

# create either a custom target or a library
macro(ccan_helper_create_target)
    if( SOURCE_FILES )
        add_library( ${PROJECT_NAME} STATIC EXCLUDE_FROM_ALL
            ${SOURCE_FILES}
        )
        if( CCAN_LIB_DEPENDS )
            target_link_libraries( ${PROJECT_NAME}
                ${CCAN_LIB_DEPENDS}
            )
        endif( CCAN_LIB_DEPENDS )
        if( CCAN_H_DEPENDS )
            set( CCAN_H_DEPENDS
                ${CCAN_H_DEPENDS}
            )
        endif( CCAN_H_DEPENDS )
    else( SOURCE_FILES )
        add_custom_target( ${PROJECT_NAME} )
        if( CCAN_LIB_DEPENDS )
            set( CCAN_H_DEPENDS
                ${CCAN_LIB_DEPENDS}
            )
        endif( CCAN_LIB_DEPENDS )
        if( CCAN_H_DEPENDS )
            set( CCAN_H_DEPENDS
                ${CCAN_H_DEPENDS}
            )
        endif( CCAN_H_DEPENDS )
    endif( SOURCE_FILES )
endmacro(ccan_helper_create_target)

# simply install the headers in the list
macro(ccan_helper_install_headers __BUILDED_HEADER_FILES__)
    if( ${__BUILDED_HEADER_FILES__} )
        install(FILES ${${__BUILDED_HEADER_FILES__}}
            DESTINATION "${CCAN_INSTALL_HEADERS}"
            OPTIONAL
        )
    endif( ${__BUILDED_HEADER_FILES__} )
endmacro(ccan_helper_install_headers)

# associate header copy command with a target
macro(ccan_helper_associate_headers __HEADER_FILES__ __BUILDED_HEADER_FILES__)
    set ( __BUILDED_HEADER_FILES__ )
    foreach(HEADER_FILE ${${__HEADER_FILES__}})
        add_custom_command(TARGET ${PROJECT_NAME} PRE_BUILD
            COMMAND ${CMAKE_COMMAND} -E
                copy "${CMAKE_CURRENT_SOURCE_DIR}/${HEADER_FILE}" "${PROJECT_BINARY_DIR}/ccamtmp/${HEADER_FILE}"
            VERBATIM
        )
        set ( ${__BUILDED_HEADER_FILES__}
            ${${__BUILDED_HEADER_FILES__}}
            "${PROJECT_BINARY_DIR}/ccamtmp/${HEADER_FILE}"
        )
    endforeach()
endmacro(ccan_helper_associate_headers)

# inserts the statement to generate a config.h file from a config.h.in file
macro(ccan_helper_config_header)
    configure_file (
        "${CMAKE_CURRENT_SOURCE_DIR}/config.h.in"
        "${CMAKE_CURRENT_BINARY_DIR}/config.h"
        @ONLY
    )
endmacro(ccan_helper_config_header)

# for simple modules this is enough
macro(ccan_helper_create_module ____PROJECT_NAME____ __VER_MAJOR__ __VER_MINOR__ __VER_PATCH__)
    ccan_helper_define_module(${____PROJECT_NAME____} ${__VER_MAJOR__} ${__VER_MINOR__} ${__VER_PATCH__})

    # header files to be installed
    ccan_helper_collect_files()

    # a fake target to be able to add dependencies
    ccan_helper_create_target()

    # associate header files with our target
    ccan_helper_associate_headers(HEADER_FILES BUILDED_HEADER_FILES)

    # install header files only if the target was requested
    ccan_helper_install_headers(BUILDED_HEADER_FILES)

    # generate the config file for this module
    ccan_helper_config_header()
endmacro(ccan_helper_create_module)

# ============================================================================


# ----------------------------------------------------------------------------
# modules
set ( ccan_tlds
    # "web"
    # "tools"
    # "licenses"
    # "junkcode"
    # "doc"
    "ccan"
)

# generated libraries are accumulated in modules_libs
FOREACH ( mod ${ccan_tlds} )
    add_subdirectory( "${mod}" )
ENDFOREACH(mod)
# ============================================================================

