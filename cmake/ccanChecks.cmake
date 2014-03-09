
include(CheckFunctionExists)
include(CheckStructHasMember)
include(CheckTypeSize)
include(CheckCSourceCompiles)
include(CheckSymbolExists)
include(CheckIncludeFiles)
include(TestBigEndian)

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

