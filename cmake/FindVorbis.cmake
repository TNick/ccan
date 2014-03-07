# - Try to find vorbis library
# Once done this will define
#  VORBIS_FOUND - System has Vorbis
#  VORBIS_INCLUDE_DIRS - The Vorbis include directories
#  VORBIS_LIBRARIES - The libraries needed to use Vorbis
#  VORBIS_DEFINITIONS - Compiler switches required for using Vorbis

# Will also inspect VORBIS_DIR environment variable
# VORBIS_LIBRARY and VORBIS_INC

if(VORBIS_FOUND)
    return()
endif(VORBIS_FOUND)

# First, try with PkgConfig if available.
FIND_PACKAGE(PkgConfig)
if(PKGCONFIG_FOUND)
    pkg_check_modules(PC_VORBIS QUIET vorbis)
    set(VORBIS_DEFINITIONS ${PC_VORBIS_CFLAGS_OTHER})
endif(PKGCONFIG_FOUND)

find_path(
    VORBIS_INCLUDE_DIR vorbis/vorbisfile.h vorbisfile.h
    HINTS ${PC_VORBIS_INCLUDEDIR} ${PC_VORBIS_INCLUDE_DIRS} 
    PATH_SUFFIXES 
	  include/vorbis include/VORBIS include Headers
    PATHS
        "$ENV{VORBIS_INC}"
        "$ENV{VORBIS_DIR}"
        "$ENV{VORBIS_DIR}/include"
   	~/Library/Frameworks/VORBIS.framework
  	/Library/Frameworks/VORBIS.framework
 	/System/Library/Frameworks/VORBIS.framework # Tiger
)

find_library(
    VORBIS_LIBRARY NAMES vorbis libvorbis vorbis_static libvorbis_static
    HINTS ${PC_VORBIS_LIBDIR} ${PC_VORBIS_LIBRARY_DIRS} 
    PATH_SUFFIXES lib64 lib libs64 libs libs/Win32 libs/Win64
    PATHS
        "$ENV{VORBIS_LIBRARY}"
        "$ENV{VORBIS_DIR}"
        "$ENV{VORBIS_DIR}/lib"
)

find_library(
    VORBISFILE_LIBRARY NAMES vorbisfile libvorbisfile vorbisfile_static libvorbisfile_static
    HINTS ${PC_VORBIS_LIBDIR} ${PC_VORBIS_LIBRARY_DIRS} 
    PATH_SUFFIXES lib64 lib libs64 libs libs/Win32 libs/Win64
    PATHS
        "$ENV{VORBIS_LIBRARY}"
        "$ENV{VORBIS_DIR}"
        "$ENV{VORBIS_DIR}/lib"
)

set(VORBIS_LIBRARIES ${VORBIS_LIBRARY} ${VORBISFILE_LIBRARY} )
set(VORBIS_INCLUDE_DIRS ${VORBIS_INCLUDE_DIR} )

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set VORBIS_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(Vorbis  DEFAULT_MSG
                                  VORBIS_LIBRARY VORBISFILE_LIBRARY VORBIS_INCLUDE_DIR)

mark_as_advanced(VORBIS_INCLUDE_DIR VORBIS_LIBRARY VORBISFILE_LIBRARY)


# The content of this file was inspired from various sources:
# http://code.ohloh.net/file?fid=5QZoBwvY6WELC_M8UjZj4qXVooM&cid=PmjbOW9QdQs&s=&fp=300711&mp&projSelected=true#L0
# http://code.ohloh.net/file?fid=XeUdS3duH5F6Mm1J0_btNAse_lI&cid=eg3r6uCfsfk&s=&fp=236555&mp&projSelected=true#L0
# http://code.ohloh.net/file?fid=0w9QYo7YNH2X8rJz4KLx51ODJyo&cid=3e3B59PEoQA&s=&fp=312212&mp&projSelected=true#L0
# http://sourceforge.net/p/alleg/allegro/ci/5.1/tree/cmake/FindVorbis.cmake

