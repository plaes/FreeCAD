# Try to find Coin3D
# Once done this will define
#
# COIN3D_FOUND        - system has Coin3D - Open Inventor
# COIN3D_INCLUDE_DIRS - where the Inventor include directory can be found
# COIN3D_LIBRARIES    - Link this to use Coin3D
#
 
SET( COIN3D_FOUND "NO" )

IF (WIN32)
  IF (CYGWIN)

    FIND_PATH(COIN3D_INCLUDE_DIRS Inventor/So.h
      /usr/include
      /usr/local/include
      /usr/include/coin
    )

    FIND_LIBRARY(COIN3D_LIBRARIES Coin
      /usr/lib
      /usr/local/lib
    )

  ELSE (CYGWIN)

    FIND_PATH(COIN3D_INCLUDE_DIRS Inventor/So.h
      "[HKEY_LOCAL_MACHINE\\SOFTWARE\\SIM\\Coin3D\\2;Installation Path]/include"
    )

    FIND_LIBRARY(COIN3D_LIBRARY_DEBUG coin2d
      "[HKEY_LOCAL_MACHINE\\SOFTWARE\\SIM\\Coin3D\\2;Installation Path]/lib"
    )

    FIND_LIBRARY(COIN3D_LIBRARY_RELEASE coin2
      "[HKEY_LOCAL_MACHINE\\SOFTWARE\\SIM\\Coin3D\\2;Installation Path]/lib"
    )

    IF (COIN3D_LIBRARY_DEBUG AND COIN3D_LIBRARY_RELEASE)
      SET(COIN3D_LIBRARIES optimized ${COIN3D_LIBRARY_RELEASE}
                           debug ${COIN3D_LIBRARY_DEBUG})
    ELSE (COIN3D_LIBRARY_DEBUG AND COIN3D_LIBRARY_RELEASE)
      IF (COIN3D_LIBRARY_DEBUG)
        SET (COIN3D_LIBRARIES ${COIN3D_LIBRARY_DEBUG})
      ENDIF (COIN3D_LIBRARY_DEBUG)
      IF (COIN3D_LIBRARY_RELEASE)
        SET (COIN3D_LIBRARIES ${COIN3D_LIBRARY_RELEASE})
      ENDIF (COIN3D_LIBRARY_RELEASE)
    ENDIF (COIN3D_LIBRARY_DEBUG AND COIN3D_LIBRARY_RELEASE)

    IF (COIN3D_LIBRARIES)
    #  ADD_DEFINITIONS ( -DCOIN_NOT_DLL )
    #ELSE (COIN3D_LIBRARIES)
    #  SET (COIN3D_LIBRARIES coin2d CACHE STRING "Coin3D Library (Debug) - Open Inventor API")
    ENDIF (COIN3D_LIBRARIES)

  ENDIF (CYGWIN)

ELSE (WIN32)
  IF(APPLE)
    FIND_PATH(COIN3D_INCLUDE_DIRS Inventor/So.h
     /Library/Frameworks/Inventor.framework/Headers 
     /usr/local/include
     /usr/include
    )
    FIND_LIBRARY(COIN3D_LIBRARIES Coin
      /Library/Frameworks/Inventor.framework/Libraries
      /usr/lib
      /usr/local/lib
    )   
    SET(COIN3D_LIBRARIES "-framework Coin3d" CACHE STRING "Coin3D library for OSX")
  ELSE(APPLE)
    # Try to use pkg-config first..
    pkg_check_modules(COIN3D Coin)
    # .. then fall back to manual lookup
    if(NOT COIN3D_FOUND)
      FIND_PATH(COIN3D_INCLUDE_DIRS Inventor/So.h
        /usr/include/Coin3
        /usr/include
        /usr/local/include
      )

      FIND_LIBRARY(COIN3D_LIBRARIES Coin
        /usr/lib
        /usr/local/lib
        PATH_SUFFIXES Coin2 Coin3
      )
    endif()
  ENDIF(APPLE)
ENDIF (WIN32)

IF(COIN3D_LIBRARIES)
  SET( COIN3D_FOUND "YES" )
ENDIF(COIN3D_LIBRARIES)
