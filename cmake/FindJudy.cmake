# - Try to find judy library
# Once done this will define
#  JUDY_FOUND - System has Judy
#  JUDY_INCLUDE_DIRS - The Judy include directories
#  JUDY_LIBRARIES - The libraries needed to use Judy
#  JUDY_DEFINITIONS - Compiler switches required for using Judy

# Will also inspect JUDY_DIR environment variable
# JUDY_LIBRARY and JUDY_INC

if(JUDY_FOUND)
    return()
endif(JUDY_FOUND)

# First, try with PkgConfig if available.
FIND_PACKAGE(PkgConfig)
if(PKGCONFIG_FOUND)
    pkg_check_modules(PC_JUDY QUIET judy)
    set(JUDY_DEFINITIONS ${PC_JUDY_CFLAGS_OTHER})
endif(PKGCONFIG_FOUND)

find_path(
    JUDY_INCLUDE_DIR judy/judy.h judy.h Judy/Judy.h Judy.h judy/Judy.h
    HINTS ${PC_JUDY_INCLUDEDIR} ${PC_JUDY_INCLUDE_DIRS} 
    PATH_SUFFIXES 
	  include/judy include/JUDY include Headers
    PATHS
        "$ENV{JUDY_INC}"
        "$ENV{JUDY_DIR}"
        "$ENV{JUDY_DIR}/include"
   	~/Library/Frameworks/JUDY.framework
  	/Library/Frameworks/JUDY.framework
 	/System/Library/Frameworks/JUDY.framework # Tiger
)

find_library(
    JUDY_LIBRARY NAMES judy libjudy Judy libJudy
    HINTS ${PC_JUDY_LIBDIR} ${PC_JUDY_LIBRARY_DIRS} 
    PATH_SUFFIXES lib64 lib libs64 libs libs/Win32 libs/Win64
    PATHS
        "$ENV{JUDY_LIBRARY}"
        "$ENV{JUDY_DIR}"
        "$ENV{JUDY_DIR}/lib"
)

set(JUDY_LIBRARIES ${JUDY_LIBRARY} )
set(JUDY_INCLUDE_DIRS ${JUDY_INCLUDE_DIR} )

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set JUDY_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(Judy  DEFAULT_MSG
                                  JUDY_LIBRARY JUDY_INCLUDE_DIR)

mark_as_advanced(JUDY_INCLUDE_DIR JUDY_LIBRARY)


