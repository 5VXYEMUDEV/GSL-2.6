# Prompt to require CMAKE_BUILD_TYPE parameter in [Debug, Release]
IF (CMAKE_BUILD_TYPE MATCHES Debug)
    MESSAGE( ">>> CMake in Debug mode! <<<" )
ELSEIF (CMAKE_BUILD_TYPE MATCHES Release)
    MESSAGE( ">>> CMake in Release mode! <<<" )
ELSE()
    
    IF (CMAKE_SYSTEM_NAME MATCHES "Windows")
        include(CmdTips_Require_CMAKE_BUILD_TYPE_Win32.cmake)
    ELSE()
        include(CmdTips_Require_CMAKE_BUILD_TYPE_Default.cmake)
    ENDIF (CMAKE_SYSTEM_NAME MATCHES "Windows")
    
    MESSAGE( FATAL_ERROR "" )
ENDIF (CMAKE_BUILD_TYPE MATCHES Debug)