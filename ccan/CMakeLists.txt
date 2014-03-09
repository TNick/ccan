# ----------------------------------------------------------------------------
# configure the project

set ( LOC_PRJ_NAME "ccan" )
# ============================================================================


# ----------------------------------------------------------------------------
# modules

# a fake target to be able to build all modules
add_custom_target( ccan_modules )

# add all level 1 modules
ccan_helper_subdirlist(ccan_top_level_mods ${CMAKE_CURRENT_SOURCE_DIR})
foreach(subdir ${ccan_top_level_mods})
    add_subdirectory(${subdir})
endforeach(subdir ${ccan_top_level_mods})

# add component modules; link them to ccan_modules target
add_dependencies( ccan_modules ${CCAN_MODS_ALL} )

# ============================================================================

