CMAKE_MINIMUM_REQUIRED (VERSION 3.14)
PROJECT (GSL_Solution C)
SET (CMAKE_C_STANDARD 99)

MESSAGE (STATUS "Solution: " ${CMAKE_PROJECT_NAME})
MESSAGE (STATUS "Dev-Root BINARY dir " ${PROJECT_BINARY_DIR})
MESSAGE (STATUS "Dev-Root SOURCE dir " ${PROJECT_SOURCE_DIR})

include(cmake/Require_CMAKE_BUILD_TYPE.cmake)

include(cmake/display_cmake_variables.cmake)

SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/../lib)
IF (MSVC)
    SET (LIBRARY_OUTPUT_PATH ${LIBRARY_OUTPUT_PATH}/${CMAKE_GENERATOR_PLATFORM})
ELSE()
    STRING(COMPARE NOTEQUAL ${CMAKE_BUILD_TYPE} "" IS_BUILD_TYPE_NOT_EMPTY)
    IF (IS_BUILD_TYPE_NOT_EMPTY)
        SET (LIBRARY_OUTPUT_PATH ${LIBRARY_OUTPUT_PATH}/${CMAKE_BUILD_TYPE})
    ENDIF ()
ENDIF ()

ADD_DEFINITIONS( -D HAVE_CONFIG_H )
ADD_DEFINITIONS( -D GSL_RANGE_CHECK )
ADD_DEFINITIONS( -D _LIB )
ADD_DEFINITIONS( -D _CRT_SECURE_NO_DEPRECATE )
ADD_DEFINITIONS( -D _CRT_SECURE_NO_WARNINGS )
ADD_DEFINITIONS( -D _CRT_NONSTDC_NO_WARNINGS )

SET ( REPO_Dev_DIR ${PROJECT_SOURCE_DIR}/../.. )
SET ( REPO_Src_DIR ${REPO_Dev_DIR}/source )
MESSAGE ( STATUS "REPO_Dev_DIR: " ${REPO_Dev_DIR} )

INCLUDE_DIRECTORIES(
    ${REPO_Dev_DIR}/include
    ${REPO_Dev_DIR}/source
)

# Ref: https://cmake.org/cmake/help/latest/variable/WIN32.html
IF (WIN32)
    INCLUDE_DIRECTORIES(
        ${REPO_Dev_DIR}/platform/MSVC
    )
# Ref: https://cmake.org/cmake/help/latest/variable/UNIX.html
ELSEIF (UNIX)
    INCLUDE_DIRECTORIES(
        ${REPO_Dev_DIR}/platform/Unix
    )
ENDIF ()


file(GLOB_RECURSE SRC_LIST_SubSrc_blas ${REPO_Src_DIR}/blas/*.c )
list(FILTER SRC_LIST_SubSrc_blas EXCLUDE REGEX ".*test.*")

SET ( SRC_LIST_SubSrc_block
    ${REPO_Src_DIR}/block/block.c
    ${REPO_Src_DIR}/block/file.c
    ${REPO_Src_DIR}/block/init.c
)

file(GLOB_RECURSE SRC_LIST_SubSrc_bspline ${REPO_Src_DIR}/bspline/*.c )
list(FILTER SRC_LIST_SubSrc_bspline EXCLUDE REGEX ".*test.*")

file(GLOB_RECURSE SRC_LIST_SubSrc_bst ${REPO_Src_DIR}/bst/*.c )
list(FILTER SRC_LIST_SubSrc_bst EXCLUDE REGEX ".*test.*")

file(GLOB_RECURSE SRC_LIST_Sublib_cblas ${REPO_Src_DIR}/cblas/*.c )
list(FILTER SRC_LIST_Sublib_cblas EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( cblas STATIC ${SRC_LIST_Sublib_cblas} )

file(GLOB_RECURSE SRC_LIST_SubSrc_cdf ${REPO_Src_DIR}/cdf/*.c )
list(FILTER SRC_LIST_SubSrc_cdf EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_cdf EXCLUDE REGEX ".*beta_inc.*")

file(GLOB_RECURSE SRC_LIST_SubSrc_cheb ${REPO_Src_DIR}/cheb/*.c )
list(FILTER SRC_LIST_SubSrc_cheb EXCLUDE REGEX ".*test.*")

SET ( SRC_LIST_LIB_GSL
    ${SRC_LIST_SubSrc_blas}
    ${SRC_LIST_SubSrc_block}
    ${SRC_LIST_SubSrc_bspline}
    ${SRC_LIST_SubSrc_bst}
    ${SRC_LIST_Sublib_cblas}
    ${SRC_LIST_SubSrc_cdf}
    ${SRC_LIST_SubSrc_cheb}
)

ADD_LIBRARY( gsl STATIC ${SRC_LIST_LIB_GSL} )
