# ----------------------------------------------------------------------------
# configure the project

set ( LOC_PRJ_NAME "ccan_junkcode" )
# ============================================================================


# ----------------------------------------------------------------------------
# modules

# a fake target to be able to build all modules
add_custom_target( ${LOC_PRJ_NAME} )

# add all level 1 modules
ccan_helper_subdirlist(ccan_top_level_mods ${CMAKE_CURRENT_SOURCE_DIR})
foreach(subdir ${ccan_top_level_mods})
    add_subdirectory(${subdir})
endforeach(subdir ${ccan_top_level_mods})

# add component modules; link them to ccan_modules target
add_dependencies( ${LOC_PRJ_NAME} 
    ccanj_grok
    ccanj_clibutils
    ccanj_bitmaps
    ccanj_pathexpand
    ccanj_timeout
    ccanj_bst
    ccanj_log
    ccanj_polynomial
    ccanj_endianess
    ccanj_snifstat
    ccanj_grawk
    ccanj_nmbrthry
)

# ============================================================================

