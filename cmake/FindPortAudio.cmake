# - Try to find portaudio library
# Once done this will define
#  PORTAUDIO_FOUND - System has PortAudio
#  PORTAUDIO_INCLUDE_DIRS - The PortAudio include directories
#  PORTAUDIO_LIBRARIES - The libraries needed to use PortAudio
#  PORTAUDIO_DEFINITIONS - Compiler switches required for using PortAudio

# Will also inspect PORTAUDIO_DIR environment variable, 
# PORTAUDIO_LIBRARY and PORTAUDIO_INC

if(PORTAUDIO_FOUND)
    return()
endif(PORTAUDIO_FOUND)

# First, try with PkgConfig if available.
FIND_PACKAGE(PkgConfig)
if(PKGCONFIG_FOUND)
    pkg_check_modules(PC_PORTAUDIO QUIET portaudio)
    set(PORTAUDIO_DEFINITIONS ${PC_PORTAUDIO_CFLAGS_OTHER})
endif(PKGCONFIG_FOUND)

find_path(
    PORTAUDIO_INCLUDE_DIR portaudio/portaudio.h portaudio.h
    HINTS ${PC_PORTAUDIO_INCLUDEDIR} ${PC_PORTAUDIO_INCLUDE_DIRS} 
    PATH_SUFFIXES 
	  include/portaudio include/PORTAUDIO include Headers
    PATHS
        "$ENV{PORTAUDIO_INC}"
        "$ENV{PORTAUDIO_DIR}"
        "$ENV{PORTAUDIO_DIR}/include"
   	~/Library/Frameworks/PORTAUDIO.framework
  	/Library/Frameworks/PORTAUDIO.framework
 	/System/Library/Frameworks/PORTAUDIO.framework # Tiger
)

find_library(
    PORTAUDIO_LIBRARY NAMES portaudio libportaudio portaudio_static libportaudio_static
    HINTS ${PC_PORTAUDIO_LIBDIR} ${PC_PORTAUDIO_LIBRARY_DIRS} 
    PATH_SUFFIXES lib64 lib libs64 libs libs/Win32 libs/Win64
    PATHS
        "$ENV{PORTAUDIO_LIBRARY}"
        "$ENV{PORTAUDIO_DIR}"
        "$ENV{PORTAUDIO_DIR}/lib"
)


set( PORTAUDIO_LIBRARIES ${PORTAUDIO_LIBRARY} )
set( PORTAUDIO_INCLUDE_DIRS ${PORTAUDIO_INCLUDE_DIR} )

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set PORTAUDIO_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(PortAudio  DEFAULT_MSG
                                  PORTAUDIO_LIBRARY PORTAUDIO_INCLUDE_DIR)

mark_as_advanced(PORTAUDIO_INCLUDE_DIR PORTAUDIO_LIBRARY)


# The content of this file was inspired from various sources, including:
# http://gnuradio.org/redmine/projects/gnuradio/repository/revisions/f919f9dcbb54a08e6e26d6c229ce92fb784fa1b2/entry/cmake/Modules/FindPortaudio.cmake

