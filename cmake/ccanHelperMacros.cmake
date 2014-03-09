# tell if a module is a header-only module
macro(ccan_helper_is_header_only __MODULE_NAME__ __OUTPUT_VAR__)
    list(FIND CCAN_MODS_NO_SRC "${__MODULE_NAME__}" CCAN_TMP_FOUND)
    if( "${CCAN_TMP_FOUND}" STREQUAL "-1")
        list(FIND CCAN_MODS_WITH_SRC "${__MODULE_NAME__}" CCAN_TMP_FOUND)
        if( "${CCAN_TMP_FOUND}" STREQUAL "-1")
            message(FATAL_ERROR "${__MODULE_NAME__} is not a ccan module.")
        endif( "${CCAN_TMP_FOUND}" STREQUAL "-1")
        set( ${__OUTPUT_VAR__} "0" )
    else( "${CCAN_TMP_FOUND}" STREQUAL "-1")
        set( ${__OUTPUT_VAR__} "1" )
    endif( "${CCAN_TMP_FOUND}" STREQUAL "-1")
endmacro(ccan_helper_is_header_only __MODULE_NAME__ __OUTPUT_VAR__)

# module definitions
macro(ccan_helper_define_module __PROJECT_NAME__ __VER_MAJOR__ __VER_MINOR__ __VER_PATCH__)
    set ( PROJECT_NAME ${__PROJECT_NAME__})

    string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_U)

    # the version as known to CMake
    set ( ${PROJECT_NAME_U}_MAJOR_VERSION __VER_MAJOR__)
    set ( ${PROJECT_NAME_U}_MINOR_VERSION __VER_MINOR__)
    set ( ${PROJECT_NAME_U}_PATCH_VERSION __VER_PATCH__)
    set ( ${PROJECT_NAME_U}_VERSION
      "${${PROJECT_NAME_U}_MAJOR_VERSION}.${${PROJECT_NAME_U}_MINOR_VERSION}.${${PROJECT_NAME_U}_PATCH_VERSION}")

    # check if is a header-only or a library kind
    list(FIND CCAN_MODS_NO_SRC "${__PROJECT_NAME__}" CCAN_TMP_FOUND)
    if( "${CCAN_TMP_FOUND}" STREQUAL "-1")
        list(FIND CCAN_MODS_WITH_SRC "${__PROJECT_NAME__}" CCAN_TMP_FOUND)
        if( "${CCAN_TMP_FOUND}" STREQUAL "-1")
            message(FATAL_ERROR "The module must be added to the list in top level CMakeLists.txt, either in CCAN_MODS_WITH_SRC or in CCAN_MODS_NO_SRC")
        endif( "${CCAN_TMP_FOUND}" STREQUAL "-1")
    endif( "${CCAN_TMP_FOUND}" STREQUAL "-1")

endmacro(ccan_helper_define_module)

# gather headers and sources
macro(ccan_helper_collect_files)
    file(GLOB HEADER_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" *.h)
    file(GLOB SOURCE_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" *.c)
endmacro(ccan_helper_collect_files)

# create either a custom target or a library
macro(ccan_helper_create_target)

    # we're either create a static library if there are source files ...
    if( SOURCE_FILES )
        ccan_helper_is_header_only( ${PROJECT_NAME} CCAN_TMP_IS_HEADER_ONLY )
        if( ${CCAN_TMP_IS_HEADER_ONLY} STREQUAL "1" )
            message(FATAL_ERROR "The module ${PROJECT_NAME} is declared headers-only but it has source files")
        endif( ${CCAN_TMP_IS_HEADER_ONLY} STREQUAL "1" )

        add_library( ${PROJECT_NAME} STATIC EXCLUDE_FROM_ALL
            ${SOURCE_FILES}
        )

        foreach(CCAN_TMP_DEPEND ${CCAN_MOD_DEPENDENCIES})
            ccan_helper_is_header_only( ${CCAN_TMP_DEPEND} CCAN_TMP_IS_HEADER_ONLY )
            if( ${CCAN_TMP_IS_HEADER_ONLY} STREQUAL "0" )
                add_dependencies( ${PROJECT_NAME}
                    ${CCAN_TMP_DEPEND}
                )
            elseif( ${CCAN_TMP_IS_HEADER_ONLY} STREQUAL "0" )
                target_link_libraries( ${PROJECT_NAME}
                    ${CCAN_TMP_DEPEND}
                )
            endif( ${CCAN_TMP_IS_HEADER_ONLY} STREQUAL "0" )
        endforeach(CCAN_TMP_DEPEND ${CCAN_MOD_DEPENDENCIES})

    # ... or a custom target that only copies headers
    else( SOURCE_FILES )
        ccan_helper_is_header_only( ${PROJECT_NAME} CCAN_TMP_IS_HEADER_ONLY )
        if( ${CCAN_TMP_IS_HEADER_ONLY} STREQUAL "0" )
            message(FATAL_ERROR "The module ${PROJECT_NAME} is declared library but it has no source files")
        endif( ${CCAN_TMP_IS_HEADER_ONLY} STREQUAL "0" )

        add_custom_target( ${PROJECT_NAME} )

        if( "${CCAN_MOD_DEPENDENCIES}" )
            add_dependencies( ${PROJECT_NAME}
                ${CCAN_MOD_DEPENDENCIES}
            )
        endif( "${CCAN_MOD_DEPENDENCIES}" )
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
macro(ccan_helper_create_module __PROJECT_NAME__ __VER_MAJOR__ __VER_MINOR__ __VER_PATCH__)
    ccan_helper_define_module(${__PROJECT_NAME__} ${__VER_MAJOR__} ${__VER_MINOR__} ${__VER_PATCH__})

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


macro(ccan_helper_subdirlist result curdir)
  file(GLOB children RELATIVE ${curdir} ${curdir}/*)
  set(dirlist "")
  foreach(child ${children})
    if(IS_DIRECTORY ${curdir}/${child})
        set(dirlist ${dirlist} ${child})
    endif(IS_DIRECTORY ${curdir}/${child})
  endforeach(child ${children})
  set(${result} ${dirlist})
endmacro(ccan_helper_subdirlist result curdir)


macro(ccan_helper_check_symbol_hdr ____TEST_VAR____ __VAR_NAME__ __HEADERS__ )
    CHECK_SYMBOL_EXISTS(${__VAR_NAME__} ${__HEADERS__} ${____TEST_VAR____})
    if(${${____TEST_VAR____}})
        set(${____TEST_VAR____} "1")
    else(${${____TEST_VAR____}})
        set(${____TEST_VAR____} "0")
    endif(${${____TEST_VAR____}})
endmacro(ccan_helper_check_symbol_hdr ____TEST_VAR____ __VAR_NAME__ __HEADERS__ )

macro(ccan_helper_check_symbol ____TEST_VAR____ __VAR_NAME__ )
    ccan_helper_check_symbol_hdr(${____TEST_VAR____} ${__VAR_NAME__} "stdio.h;stddef.h;stdlib.h" )
endmacro(ccan_helper_check_symbol ____TEST_VAR____ __VAR_NAME__ )

macro(ccan_helper_check_function ____TEST_VAR____ __FUNC_NAME__ __HEADERS__ __DEFINITIONS__)
    set( CMAKE_REQUIRED_INCLUDES ${__HEADERS__})
    set( CMAKE_REQUIRED_DEFINITIONS ${__DEFINITIONS__})
    CHECK_FUNCTION_EXISTS(${__FUNC_NAME__} ${____TEST_VAR____})
    if(${${____TEST_VAR____}})
        set(${____TEST_VAR____} "1")
    else(${${____TEST_VAR____}})
        set(${____TEST_VAR____} "0")
    endif(${${____TEST_VAR____}})
    set( CMAKE_REQUIRED_DEFINITIONS )
    set( CMAKE_REQUIRED_INCLUDES)
endmacro(ccan_helper_check_function ____TEST_VAR____ __FUNC_NAME__ __HEADERS__ __DEFINITIONS__)

macro(ccan_helper_check_compile ____TEST_STRING____ __VAR_NAME__ )
    CHECK_C_SOURCE_COMPILES(
        "${____TEST_STRING____}"
        "${__VAR_NAME__}")
    if(${${__VAR_NAME__}})
        set(${__VAR_NAME__} 1)
    else(${${__VAR_NAME__}})
        set(${__VAR_NAME__} 0)
    endif(${${__VAR_NAME__}})
endmacro(ccan_helper_check_compile ____TEST_STRING____ __VAR_NAME__ )

macro(ccan_helper_check_run ____TEST_STRING____ __VAR_NAME__ )
    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/ctime_test.c"  
        "${____TEST_STRING____}"
    )
    try_run(
        CTIME_TEST_RUN_RESULT_VAR 
        CTIME_TEST_COMPILE_RESULT_VAR
        "${CMAKE_CURRENT_BINARY_DIR}"  
        "${CMAKE_CURRENT_BINARY_DIR}/ctime_test.c"
        COMPILE_OUTPUT_VARIABLE CMP_OUT
        RUN_OUTPUT_VARIABLE RUN_OUT
    )
    if(${CTIME_TEST_RUN_RESULT_VAR} STREQUAL "0")
        set( ${__VAR_NAME__} 1)
    else(${CTIME_TEST_RUN_RESULT_VAR} STREQUAL "0")
        set( ${__VAR_NAME__} 0)
    endif(${CTIME_TEST_RUN_RESULT_VAR} STREQUAL "0")
endmacro(ccan_helper_check_run ____TEST_STRING____ __VAR_NAME__ )

macro(ccan_helper_check_header ____TEST_HEADER____ __VAR_NAME__ )
    CHECK_INCLUDE_FILES(
        "${____TEST_HEADER____}"
        "${__VAR_NAME__}")
    if(${${__VAR_NAME__}})
        set(${__VAR_NAME__} 1)
    else(${${__VAR_NAME__}})
        set(${__VAR_NAME__} 0)
    endif(${${__VAR_NAME__}})
endmacro(ccan_helper_check_header ____TEST_HEADER____ __VAR_NAME__ )



