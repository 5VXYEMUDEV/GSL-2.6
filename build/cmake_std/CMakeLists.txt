CMAKE_MINIMUM_REQUIRED (VERSION 3.14)
PROJECT (GSL_Solution C)
SET (CMAKE_C_STANDARD 99)

MESSAGE (STATUS "Solution: " ${CMAKE_PROJECT_NAME})
MESSAGE (STATUS "Dev-Root BINARY dir " ${PROJECT_BINARY_DIR})
MESSAGE (STATUS "Dev-Root SOURCE dir " ${PROJECT_SOURCE_DIR})

include(cmake/Require_CMAKE_BUILD_TYPE.cmake)

include(cmake/display_cmake_variables.cmake)

SET(EXECUTABLE_OUTPUT_PATH  ${PROJECT_BINARY_DIR}/../bin)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/../lib)
IF (MSVC)
    SET (EXECUTABLE_OUTPUT_PATH ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_GENERATOR_PLATFORM})
    SET (LIBRARY_OUTPUT_PATH ${LIBRARY_OUTPUT_PATH}/${CMAKE_GENERATOR_PLATFORM})
ELSE()
    STRING(COMPARE NOTEQUAL ${CMAKE_BUILD_TYPE} "" IS_BUILD_TYPE_NOT_EMPTY)
    IF (IS_BUILD_TYPE_NOT_EMPTY)
        SET (EXECUTABLE_OUTPUT_PATH ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_BUILD_TYPE})
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

# ===========================================================================
# Libraries Development
# ===========================================================================

file(GLOB_RECURSE SRC_LIST_SubSrc_blas ${REPO_Src_DIR}/blas/*.c )
list(FILTER SRC_LIST_SubSrc_blas EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( blas STATIC ${SRC_LIST_SubSrc_blas} )

SET ( SRC_LIST_SubSrc_block
    ${REPO_Src_DIR}/block/block.c
    ${REPO_Src_DIR}/block/file.c
    ${REPO_Src_DIR}/block/init.c
)
ADD_LIBRARY( block STATIC ${SRC_LIST_SubSrc_block} )

file(GLOB_RECURSE SRC_LIST_SubSrc_bspline ${REPO_Src_DIR}/bspline/*.c )
list(FILTER SRC_LIST_SubSrc_bspline EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( bspline STATIC ${SRC_LIST_SubSrc_bspline} )

file(GLOB_RECURSE SRC_LIST_SubSrc_bst ${REPO_Src_DIR}/bst/*.c )
list(FILTER SRC_LIST_SubSrc_bst EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( bst STATIC ${SRC_LIST_SubSrc_bst} )

file(GLOB_RECURSE SRC_LIST_Sublib_cblas ${REPO_Src_DIR}/cblas/*.c )
list(FILTER SRC_LIST_Sublib_cblas EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( cblas STATIC ${SRC_LIST_Sublib_cblas} )

file(GLOB_RECURSE SRC_LIST_SubSrc_cdf ${REPO_Src_DIR}/cdf/*.c )
list(FILTER SRC_LIST_SubSrc_cdf EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_cdf EXCLUDE REGEX ".*beta_inc.*")
ADD_LIBRARY( cdf STATIC ${SRC_LIST_SubSrc_cdf} )

file(GLOB_RECURSE SRC_LIST_SubSrc_cheb ${REPO_Src_DIR}/cheb/*.c )
list(FILTER SRC_LIST_SubSrc_cheb EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( cheb STATIC ${SRC_LIST_SubSrc_cheb} )

file(GLOB_RECURSE SRC_LIST_SubSrc_combination ${REPO_Src_DIR}/combination/*.c )
list(FILTER SRC_LIST_SubSrc_combination EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( combination STATIC ${SRC_LIST_SubSrc_combination} )

file(GLOB_RECURSE SRC_LIST_SubSrc_complex ${REPO_Src_DIR}/complex/*.c )
list(FILTER SRC_LIST_SubSrc_complex EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( complex STATIC ${SRC_LIST_SubSrc_complex} )


file(GLOB_RECURSE SRC_LIST_SubSrc_err ${REPO_Src_DIR}/err/*.c )
list(FILTER SRC_LIST_SubSrc_err EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( err STATIC ${SRC_LIST_SubSrc_err} )

SET ( SRC_LIST_SubSrc_ieee_utils
    ${REPO_Src_DIR}/ieee-utils/env.c
    ${REPO_Src_DIR}/ieee-utils/fp.c
    ${REPO_Src_DIR}/ieee-utils/make_rep.c
    ${REPO_Src_DIR}/ieee-utils/print.c
    ${REPO_Src_DIR}/ieee-utils/read.c
)
ADD_LIBRARY( ieee_utils STATIC ${SRC_LIST_SubSrc_ieee_utils} )
TARGET_LINK_LIBRARIES( ieee_utils PRIVATE err)

file(GLOB_RECURSE SRC_LIST_SubSrc_linalg ${REPO_Src_DIR}/linalg/*.c )
list(FILTER SRC_LIST_SubSrc_linalg EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_linalg EXCLUDE REGEX ".*apply_givens\.c")
list(FILTER SRC_LIST_SubSrc_linalg EXCLUDE REGEX ".*cholesky_common\.c")
list(FILTER SRC_LIST_SubSrc_linalg EXCLUDE REGEX ".*svdstep\.c")
ADD_LIBRARY( linalg STATIC ${SRC_LIST_SubSrc_linalg} )

IF (UNIX)
    TARGET_LINK_LIBRARIES( linalg PRIVATE m)
ENDIF ()

file(GLOB_RECURSE SRC_LIST_SubSrc_matrix ${REPO_Src_DIR}/matrix/*.c )
list(FILTER SRC_LIST_SubSrc_matrix EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_matrix EXCLUDE REGEX ".*_source\.c")
ADD_LIBRARY( matrix STATIC ${SRC_LIST_SubSrc_matrix} )

file(GLOB_RECURSE SRC_LIST_SubSrc_randist ${REPO_Src_DIR}/randist/*.c )
list(FILTER SRC_LIST_SubSrc_randist EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( randist STATIC ${SRC_LIST_SubSrc_randist} )
TARGET_LINK_LIBRARIES( randist PRIVATE rng)

file(GLOB_RECURSE SRC_LIST_SubSrc_rng ${REPO_Src_DIR}/rng/*.c )
list(FILTER SRC_LIST_SubSrc_rng EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( rng STATIC ${SRC_LIST_SubSrc_rng} )

file(GLOB_RECURSE SRC_LIST_SubSrc_sort ${REPO_Src_DIR}/sort/*.c )
list(FILTER SRC_LIST_SubSrc_sort EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_sort EXCLUDE REGEX ".*_source\.c")
ADD_LIBRARY( sort STATIC ${SRC_LIST_SubSrc_sort} )

file(GLOB_RECURSE SRC_LIST_SubSrc_specfunc ${REPO_Src_DIR}/specfunc/*.c )
list(FILTER SRC_LIST_SubSrc_specfunc EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_specfunc EXCLUDE REGEX ".*_eval.*\.c")
list(FILTER SRC_LIST_SubSrc_specfunc EXCLUDE REGEX ".*_source\.c")
ADD_LIBRARY( specfunc STATIC ${SRC_LIST_SubSrc_specfunc} )
TARGET_LINK_LIBRARIES( specfunc PRIVATE complex)

file(GLOB_RECURSE SRC_LIST_SubSrc_statistics ${REPO_Src_DIR}/statistics/*.c )
list(FILTER SRC_LIST_SubSrc_statistics EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_statistics EXCLUDE REGEX ".*_source\.c")
ADD_LIBRARY( statistics STATIC ${SRC_LIST_SubSrc_statistics} )

file(GLOB_RECURSE SRC_LIST_SubSrc_sys ${REPO_Src_DIR}/sys/*.c )
list(FILTER SRC_LIST_SubSrc_sys EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( sys STATIC ${SRC_LIST_SubSrc_sys} )

file(GLOB_RECURSE SRC_LIST_SubSrc_vector ${REPO_Src_DIR}/vector/*.c )
list(FILTER SRC_LIST_SubSrc_vector EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_vector EXCLUDE REGEX ".*_source\.c")
ADD_LIBRARY( vector STATIC ${SRC_LIST_SubSrc_vector} )

SET ( SRC_LIST_LIB_GSL
    ${SRC_LIST_SubSrc_blas}
    ${SRC_LIST_SubSrc_block}
    # ${SRC_LIST_SubSrc_bspline} // Use TARGET_LINK_LIBRARIES to be involved
    # ${SRC_LIST_SubSrc_bst}    // Use TARGET_LINK_LIBRARIES to be involved
    # ${SRC_LIST_Sublib_cblas}  // Use TARGET_LINK_LIBRARIES to be involved
    # ${SRC_LIST_SubSrc_cdf}    // Use TARGET_LINK_LIBRARIES to be involved
    # ${SRC_LIST_SubSrc_cheb}   // Use TARGET_LINK_LIBRARIES to be involved
    # ${SRC_LIST_SubSrc_combination} // Use TARGET_LINK_LIBRARIES to be involved
)

ADD_LIBRARY( gsl STATIC ${SRC_LIST_LIB_GSL} )

TARGET_LINK_LIBRARIES( gsl
    INTERFACE blas 
    INTERFACE block 
    INTERFACE bspline 
    INTERFACE bst 
    INTERFACE cblas 
    INTERFACE cdf 
    INTERFACE cheb 
    INTERFACE combination 
    INTERFACE complex 
    INTERFACE err 
    INTERFACE ieee_utils
    INTERFACE linalg
    INTERFACE rng 
    INTERFACE sort 
    INTERFACE specfunc 
    INTERFACE randist 
    INTERFACE matrix
    INTERFACE statistics
    INTERFACE sys 
    INTERFACE vector 
)

# ===========================================================================
# Test
# ===========================================================================

file(GLOB_RECURSE SRC_LIST_SubTestSrc_test ${REPO_Src_DIR}/test/*.c )
ADD_LIBRARY( test STATIC ${SRC_LIST_SubTestSrc_test} )

SET ( SRC_LIST_TestSuite_block
    ${REPO_Src_DIR}/block/test.c
)
ADD_EXECUTABLE( test_block ${SRC_LIST_TestSuite_block} )
TARGET_LINK_LIBRARIES( test_block 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_bspline
    ${REPO_Src_DIR}/bspline/test.c
)
IF (WIN32)
    ADD_EXECUTABLE( test_bspline ${SRC_LIST_TestSuite_bspline} )
    TARGET_LINK_LIBRARIES( test_bspline 
        PRIVATE test 
        PRIVATE gsl 
    )
ENDIF ()

SET ( SRC_LIST_TestSuite_bst
    ${REPO_Src_DIR}/bst/test.c
)
ADD_EXECUTABLE( test_bst ${SRC_LIST_TestSuite_bst} )
TARGET_LINK_LIBRARIES( test_bst 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_cblas ${REPO_Src_DIR}/cblas/test*.c )
list(FILTER SRC_LIST_TestSuite_cblas EXCLUDE REGEX ".*tests\.c")
ADD_EXECUTABLE( test_cblas ${SRC_LIST_TestSuite_cblas} )
TARGET_LINK_LIBRARIES( test_cblas 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_cdf
    ${REPO_Src_DIR}/cdf/test.c
)
ADD_EXECUTABLE( test_cdf ${SRC_LIST_TestSuite_cdf} )
TARGET_LINK_LIBRARIES( test_cdf 
    PRIVATE test 
    PRIVATE gsl 
)
