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

include(CheckFunctionExists)
include(CheckStructHasMember)
include(CheckTypeSize)
include(CheckCSourceCompiles)
include(CheckSymbolExists)
include(CheckIncludeFiles)
include(TestBigEndian)

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

ccan_helper_check_header("byteswap.h" HAVE_BYTESWAP_H)
ccan_helper_check_header("err.h" HAVE_ERR_H)
ccan_helper_check_header("sys/filio.h" HAVE_SYS_FILIO_H)
ccan_helper_check_header("sys/termios.h" HAVE_SYS_TERMIOS_H)

ccan_helper_check_function(HAVE_ASPRINTF "asprintf" "stdio.h" "-D_GNU_SOURCE")
ccan_helper_check_function(HAVE_FCHDIR "fchdir" "sys/types.h;sys/stat.h;fcntl.h;unistd.h" "")
ccan_helper_check_function(HAVE_UTIME "utime" "sys/types.h;utime.h" "")

ccan_helper_check_symbol_hdr(HAVE_BACKTRACE "backtrace" "execinfo.h")
ccan_helper_check_symbol_hdr(HAVE_BSWAP_64 "bswap_64" "byteswap.h")
ccan_helper_check_symbol_hdr(HAVE_CLOCK_GETTIME "clock_gettime" "time.h")
ccan_helper_check_symbol_hdr(HAVE_GETPAGESIZE "getpagesize" "unistd.h")
set(CMAKE_REQUIRED_DEFINITIONS "-D_GNU_SOURCE")
ccan_helper_check_symbol_hdr(HAVE_ISBLANK "isblank" "ctype.h")
ccan_helper_check_symbol_hdr(HAVE_MEMMEM "memmem" "string.h")
set(CMAKE_REQUIRED_DEFINITIONS)
ccan_helper_check_symbol_hdr(HAVE_MMAP "mmap" "sys/mman.h")

ccan_helper_check_compile( 
    "int main(int argc, const char *argv[]) { return __alignof__(double) > 0 ? 0 : 1; }"
    HAVE_ALIGNOF)
ccan_helper_check_compile(
    "static int __attribute__((cold)) func(int x) { return x; }
    int main(int argc, const char *argv[]) { return func(0); }"
    HAVE_ATTRIBUTE_COLD)
ccan_helper_check_compile(
    "static int __attribute__((const)) func(int x) { return x; }
    int main(int argc, const char *argv[]) { return func(0); }"
    HAVE_ATTRIBUTE_CONST)
ccan_helper_check_compile(
    "typedef short __attribute__((__may_alias__)) short_a;
    int main(int argc, const char *argv[]) { return 0; }"
    HAVE_ATTRIBUTE_MAY_ALIAS)
ccan_helper_check_compile(
    "#include <stdlib.h>
    static void __attribute__((noreturn)) func(int x) {
        exit(x);
    }
    int main(int argc, const char *argv[]) { 
        return 0;
    }"
    HAVE_ATTRIBUTE_NORETURN)
ccan_helper_check_compile(
    "static void __attribute__((format(__printf__, 1, 2))) func(const char *fmt, ...) {
    }
    int main(int argc, const char *argv[]) {
        return 0;
    }"
    HAVE_ATTRIBUTE_PRINTF)
ccan_helper_check_compile(
    "static int __attribute__((unused)) func(int x) {
        return x;
    }
    int main(int argc, const char *argv[]) {
        return func(0);
    }"
    HAVE_ATTRIBUTE_UNUSED)
ccan_helper_check_compile(
    "static int __attribute__((used)) func(int x) { return x; }
    int main(int argc, const char *argv[]) { return func(0); }"
    HAVE_ATTRIBUTE_USED)
ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) {return __builtin_choose_expr(1, 0, \"garbage\"); }"
	HAVE_BUILTIN_CHOOSE_EXPR)
ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) {return __builtin_clz(1) == (sizeof(int)*8 - 1) ? 0 : 1; }"
	HAVE_BUILTIN_CLZ)
ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) {return __builtin_clzl(1) == (sizeof(long)*8 - 1) ? 0 : 1; }"
	HAVE_BUILTIN_CLZL)
ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) {return __builtin_clzll(1) == (sizeof(long long)*8 - 1) ? 0 : 1; }"
	HAVE_BUILTIN_CLZLL)
ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) {return __builtin_constant_p(1) ? 0 : 1; }"
	HAVE_BUILTIN_CONSTANT_P)
ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) {return __builtin_expect(argc == 1, 1) ? 0 : 1; }"
	HAVE_BUILTIN_EXPECT)
ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) {return __builtin_ffsl(0L) == 0 ? 0 : 1; }"
	HAVE_BUILTIN_FFSL)
ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) {return __builtin_ffsll(0LL) == 0 ? 0 : 1; }"
	HAVE_BUILTIN_FFSLL)
ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) {return __builtin_popcountl(255L) == 8 ? 0 : 1; }"
	HAVE_BUILTIN_POPCOUNTL)
ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) {return __builtin_types_compatible_p(char *, int) ? 1 : 0; }"
	HAVE_BUILTIN_TYPES_COMPATIBLE_P)
set( CMAKE_REQUIRED_LIBRARIES "rt")
ccan_helper_check_compile(
    "#include <time.h>
    int main(int argc, const char *argv[]) {
        struct timespec ts; 
        clock_gettime(CLOCK_REALTIME, &ts); 
        return 0;
    }"
    HAVE_CLOCK_GETTIME_IN_LIBRT)
set( CMAKE_REQUIRED_LIBRARIES)

ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) {
        int *foo = (int[]) { 1, 2, 3, 4 }; 
        return foo[0] ? 0 : 1; 
    }"
    HAVE_COMPOUND_LITERALS)
ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) { for (int i = 0; i < argc; i++); return 0; }"
    HAVE_FOR_LOOP_DECLARATION)
ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) { struct foo { unsigned int x; int arr[]; }; return 0; }"
    HAVE_FLEXIBLE_ARRAY_MEMBER)
ccan_helper_check_compile(
    "static void *__attribute__((__section__(\"mysec\"))) p = &p;
    int main(int argc, const char *argv[]) {
        extern void *__start_mysec[], *__stop_mysec[];
        return __stop_mysec - __start_mysec;
    }"
    HAVE_SECTION_START_STOP)
ccan_helper_check_compile(
    "int main(int argc, const char *argv[]) { return ({ int x = argc; x == argc ? 0 : 1; }); }"
    HAVE_STATEMENT_EXPR)
ccan_helper_check_compile(
    "static __attribute__((warn_unused_result)) 
    int func(int i) {return i + 1;} 
    int main(int argc, const char *argv[]) { return func(0); }"
    HAVE_WARN_UNUSED_RESULT)


ccan_helper_check_run(
    "#define _FILE_OFFSET_BITS 64
    #include <sys/types.h>
    int main(int argc, char *argv[]) {
        return sizeof(off_t) == 8 ? 0 : 1;
    }"
    HAVE_FILE_OFFSET_BITS)
ccan_helper_check_run(
    "#include <sys/types.h>
    #include <sys/stat.h>
    #include <fcntl.h>
    int main(int argc, const char *argv[]) { 
        return open(\"/proc/self/maps\", O_RDONLY) != -1 ? 0 : 1;
    }"
    HAVE_PROC_SELF_MAPS)
ccan_helper_check_run(
    "#define _GNU_SOURCE 1
    #include <stdlib.h>
    static int cmp(const void *lp, const void *rp, void *priv) {
        *(unsigned int *)priv = 1;
        return *(const int *)lp - *(const int *)rp; 
    }
    int main(int argc, const char *argv[]) {
        int array[] = { 9, 2, 5 };
        unsigned int called = 0;
        qsort_r(array, 3, sizeof(int), cmp, &called);
        return called && array[0] == 2 && array[1] == 5 && array[2] == 9 ? 0 : 1;
    }"
    HAVE_QSORT_R_PRIVATE_LAST)
ccan_helper_check_run(
    "static long nest(const void *base, unsigned int i) {
        if (i == 0)
            return (const char *)&i - (const char *)base;
        return nest(base, i-1);
    }
    int main(int argc, char *argv[]) {
        return (nest(&argc, argc) > 0) ? 0 : 1;
    }"
    HAVE_STACK_GROWS_UPWARDS)
ccan_helper_check_run(
    "int main(int argc, const char *argv[]) { 
        __typeof__(argc) i;
        i = argc;
        return i == argc ? 0 : 1;
    }"
    HAVE_TYPEOF)






# HAVE_32BIT_OFF_T
CHECK_TYPE_SIZE(off_t OFF_T_SIZE)
if(${HAVE_OFF_T_SIZE})
    if(${OFF_T_SIZE} STREQUAL "4")
        set(HAVE_32BIT_OFF_T 1)
    else(${OFF_T_SIZE} STREQUAL "4")
        set(HAVE_32BIT_OFF_T 0)
    endif(${OFF_T_SIZE} STREQUAL "4")
else(${HAVE_OFF_T_SIZE})
    set(HAVE_32BIT_OFF_T 0)
endif(${HAVE_OFF_T_SIZE})



# HAVE_BIG_ENDIAN
TEST_BIG_ENDIAN(HAVE_BIG_ENDIAN)
if(${HAVE_BIG_ENDIAN})
    set(HAVE_BIG_ENDIAN 1)
    set(HAVE_LITTLE_ENDIAN 0)
else(${HAVE_BIG_ENDIAN})
    set(HAVE_BIG_ENDIAN 0)
    set(HAVE_LITTLE_ENDIAN 1)
endif(${HAVE_BIG_ENDIAN})


set( CMAKE_REQUIRED_INCLUDES "time.h")
CHECK_TYPE_SIZE("struct timespec" HAVE_STRUCT_TIMESPEC)
if(${HAVE_STRUCT_TIMESPEC})
    set(HAVE_STRUCT_TIMESPEC 1)
else(${HAVE_STRUCT_TIMESPEC})
    set(HAVE_STRUCT_TIMESPEC 0)
endif(${HAVE_STRUCT_TIMESPEC})
set( CMAKE_REQUIRED_INCLUDES)

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

