set( CCAN_MOD_DEPENDENCIES
    # TODO: only if defined(__i386__) || defined(__i386) || defined(__x86_64) \
    #	|| defined(_M_AMD64) || defined(__M_X64)
    ccan_build_assert
)

ccan_helper_create_module("ccan_cpuid" 1 0 0)
