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

IF (MSVC)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4477")
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4018")
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4334")

    SET(CMAKE_STATIC_LINKER_FLAGS "${CMAKE_STATIC_LINKER_FLAGS} /IGNORE:4006  ")
ENDIF ()

# ===========================================================================
# Libraries Development
# ===========================================================================

file(GLOB_RECURSE SRC_LIST_SubSrc_blas ${REPO_Src_DIR}/blas/*.c )
list(FILTER SRC_LIST_SubSrc_blas EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( blas STATIC ${SRC_LIST_SubSrc_blas} )
TARGET_LINK_LIBRARIES( blas PRIVATE cblas)

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

IF (UNIX)
    TARGET_LINK_LIBRARIES( cblas PRIVATE m)
ENDIF ()

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

SET ( SRC_LIST_SubSrc_deriv
    ${REPO_Src_DIR}/deriv/deriv.c
)
ADD_LIBRARY( deriv STATIC ${SRC_LIST_SubSrc_deriv} )

SET ( SRC_LIST_SubSrc_dht
    ${REPO_Src_DIR}/dht/dht.c
)
ADD_LIBRARY( dht STATIC ${SRC_LIST_SubSrc_dht} )

SET ( SRC_LIST_SubSrc_diff
    ${REPO_Src_DIR}/diff/diff.c
)
ADD_LIBRARY( diff STATIC ${SRC_LIST_SubSrc_diff} )

file(GLOB_RECURSE SRC_LIST_SubSrc_eigen ${REPO_Src_DIR}/eigen/*.c )
list(FILTER SRC_LIST_SubSrc_eigen EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_eigen EXCLUDE REGEX ".*step\.c")
ADD_LIBRARY( eigen STATIC ${SRC_LIST_SubSrc_eigen} )
TARGET_LINK_LIBRARIES( eigen PRIVATE linalg)


file(GLOB_RECURSE SRC_LIST_SubSrc_err ${REPO_Src_DIR}/err/*.c )
list(FILTER SRC_LIST_SubSrc_err EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( err STATIC ${SRC_LIST_SubSrc_err} )

SET ( SRC_LIST_SubSrc_fft
    ${REPO_Src_DIR}/fft/fft.c
    ${REPO_Src_DIR}/fft/dft.c
)
ADD_LIBRARY( fft STATIC ${SRC_LIST_SubSrc_fft} )

file(GLOB_RECURSE SRC_LIST_SubSrc_filter ${REPO_Src_DIR}/filter/*.c )
list(FILTER SRC_LIST_SubSrc_filter EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_filter EXCLUDE REGEX ".*ringbuf\.c")
ADD_LIBRARY( filter STATIC ${SRC_LIST_SubSrc_filter} )
TARGET_LINK_LIBRARIES( filter PRIVATE movstat)

file(GLOB_RECURSE SRC_LIST_SubSrc_fit ${REPO_Src_DIR}/fit/*.c )
list(FILTER SRC_LIST_SubSrc_fit EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( fit STATIC ${SRC_LIST_SubSrc_fit} )

file(GLOB_RECURSE SRC_LIST_SubSrc_histogram ${REPO_Src_DIR}/histogram/*.c )
list(FILTER SRC_LIST_SubSrc_histogram EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_histogram EXCLUDE REGEX ".*find.*\.c")
list(FILTER SRC_LIST_SubSrc_histogram EXCLUDE REGEX ".*urand\.c")
ADD_LIBRARY( histogram STATIC ${SRC_LIST_SubSrc_histogram} )

SET ( SRC_LIST_SubSrc_ieee_utils
    ${REPO_Src_DIR}/ieee-utils/env.c
    ${REPO_Src_DIR}/ieee-utils/fp.c
    ${REPO_Src_DIR}/ieee-utils/make_rep.c
    ${REPO_Src_DIR}/ieee-utils/print.c
    ${REPO_Src_DIR}/ieee-utils/read.c
)
ADD_LIBRARY( ieee_utils STATIC ${SRC_LIST_SubSrc_ieee_utils} )
TARGET_LINK_LIBRARIES( ieee_utils PRIVATE err)

file(GLOB_RECURSE SRC_LIST_SubSrc_integration ${REPO_Src_DIR}/integration/*.c )
list(FILTER SRC_LIST_SubSrc_integration EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_integration EXCLUDE REGEX ".*append\.c")
list(FILTER SRC_LIST_SubSrc_integration EXCLUDE REGEX ".*initialise\.c")
list(FILTER SRC_LIST_SubSrc_integration EXCLUDE REGEX ".*positivity\.c")
list(FILTER SRC_LIST_SubSrc_integration EXCLUDE REGEX ".*ptsort\.c")
list(FILTER SRC_LIST_SubSrc_integration EXCLUDE REGEX ".*qc25.*\.c")
list(FILTER SRC_LIST_SubSrc_integration EXCLUDE REGEX ".*qelg\.c")
list(FILTER SRC_LIST_SubSrc_integration EXCLUDE REGEX ".*qpsrt.*\.c")
list(FILTER SRC_LIST_SubSrc_integration EXCLUDE REGEX ".*reset\.c")
list(FILTER SRC_LIST_SubSrc_integration EXCLUDE REGEX ".*set_initial\.c")
list(FILTER SRC_LIST_SubSrc_integration EXCLUDE REGEX ".*util\.c")
ADD_LIBRARY( integration STATIC ${SRC_LIST_SubSrc_integration} )

file(GLOB_RECURSE SRC_LIST_SubSrc_interpolation ${REPO_Src_DIR}/interpolation/*.c )
list(FILTER SRC_LIST_SubSrc_interpolation EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( interpolation STATIC ${SRC_LIST_SubSrc_interpolation} )

file(GLOB_RECURSE SRC_LIST_SubSrc_linalg ${REPO_Src_DIR}/linalg/*.c )
list(FILTER SRC_LIST_SubSrc_linalg EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_linalg EXCLUDE REGEX ".*apply_givens\.c")
list(FILTER SRC_LIST_SubSrc_linalg EXCLUDE REGEX ".*cholesky_common\.c")
list(FILTER SRC_LIST_SubSrc_linalg EXCLUDE REGEX ".*svdstep\.c")
ADD_LIBRARY( linalg STATIC ${SRC_LIST_SubSrc_linalg} )
TARGET_LINK_LIBRARIES( linalg PRIVATE permutation)

TARGET_LINK_LIBRARIES( linalg PRIVATE matrix)
IF (UNIX)
    TARGET_LINK_LIBRARIES( linalg PRIVATE m)
ENDIF ()

file(GLOB_RECURSE SRC_LIST_SubSrc_matrix ${REPO_Src_DIR}/matrix/*.c )
list(FILTER SRC_LIST_SubSrc_matrix EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_matrix EXCLUDE REGEX ".*_source\.c")
ADD_LIBRARY( matrix STATIC ${SRC_LIST_SubSrc_matrix} )
TARGET_LINK_LIBRARIES( matrix PRIVATE blas)
TARGET_LINK_LIBRARIES( matrix PRIVATE block)
TARGET_LINK_LIBRARIES( matrix PRIVATE err)

file(GLOB_RECURSE SRC_LIST_SubSrc_min ${REPO_Src_DIR}/min/*.c )
list(FILTER SRC_LIST_SubSrc_min EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( min STATIC ${SRC_LIST_SubSrc_min} )

file(GLOB_RECURSE SRC_LIST_SubSrc_monte ${REPO_Src_DIR}/monte/*.c )
list(FILTER SRC_LIST_SubSrc_monte EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( monte STATIC ${SRC_LIST_SubSrc_monte} )

file(GLOB_RECURSE SRC_LIST_SubSrc_movstat ${REPO_Src_DIR}/movstat/*.c )
list(FILTER SRC_LIST_SubSrc_movstat EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_movstat EXCLUDE REGEX ".*deque\.c")
list(FILTER SRC_LIST_SubSrc_movstat EXCLUDE REGEX ".*ringbuf\.c")
ADD_LIBRARY( movstat STATIC ${SRC_LIST_SubSrc_movstat} )
TARGET_LINK_LIBRARIES( movstat PRIVATE err)

file(GLOB_RECURSE SRC_LIST_SubSrc_multifit ${REPO_Src_DIR}/multifit/*.c )
list(FILTER SRC_LIST_SubSrc_multifit EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_multifit EXCLUDE REGEX ".*lmiterate\.c")
list(FILTER SRC_LIST_SubSrc_multifit EXCLUDE REGEX ".*lmmisc\.c")
list(FILTER SRC_LIST_SubSrc_multifit EXCLUDE REGEX ".*lmpar\.c")
list(FILTER SRC_LIST_SubSrc_multifit EXCLUDE REGEX ".*lmset\.c")
list(FILTER SRC_LIST_SubSrc_multifit EXCLUDE REGEX ".*lmutil\.c")
list(FILTER SRC_LIST_SubSrc_multifit EXCLUDE REGEX ".*qrsolv\.c")
ADD_LIBRARY( multifit STATIC ${SRC_LIST_SubSrc_multifit} )
TARGET_LINK_LIBRARIES( multifit PRIVATE min)

file(GLOB_RECURSE SRC_LIST_SubSrc_multifit_nlinear ${REPO_Src_DIR}/multifit_nlinear/*.c )
list(FILTER SRC_LIST_SubSrc_multifit_nlinear EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_multifit_nlinear EXCLUDE REGEX ".*common\.c")
list(FILTER SRC_LIST_SubSrc_multifit_nlinear EXCLUDE REGEX ".*qrsolv\.c")
ADD_LIBRARY( multifit_nlinear STATIC ${SRC_LIST_SubSrc_multifit_nlinear} )

file(GLOB_RECURSE SRC_LIST_SubSrc_multilarge ${REPO_Src_DIR}/multilarge/*.c )
list(FILTER SRC_LIST_SubSrc_multilarge EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( multilarge STATIC ${SRC_LIST_SubSrc_multilarge} )

file(GLOB_RECURSE SRC_LIST_SubSrc_multilarge_nlinear ${REPO_Src_DIR}/multilarge_nlinear/*.c )
list(FILTER SRC_LIST_SubSrc_multilarge_nlinear EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_multilarge_nlinear EXCLUDE REGEX ".*common\.c")
ADD_LIBRARY( multilarge_nlinear STATIC ${SRC_LIST_SubSrc_multilarge_nlinear} )
TARGET_LINK_LIBRARIES( multilarge_nlinear PRIVATE multifit)

file(GLOB_RECURSE SRC_LIST_SubSrc_multimin ${REPO_Src_DIR}/multimin/*.c )
list(FILTER SRC_LIST_SubSrc_multimin EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_multimin EXCLUDE REGEX ".*directional_minimize\.c")
list(FILTER SRC_LIST_SubSrc_multimin EXCLUDE REGEX ".*linear_wrapper\.c")
ADD_LIBRARY( multimin STATIC ${SRC_LIST_SubSrc_multimin} )

file(GLOB_RECURSE SRC_LIST_SubSrc_multiroots ${REPO_Src_DIR}/multiroots/*.c )
list(FILTER SRC_LIST_SubSrc_multiroots EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_multiroots EXCLUDE REGEX ".*dogleg\.c")
list(FILTER SRC_LIST_SubSrc_multiroots EXCLUDE REGEX ".*enorm\.c")
ADD_LIBRARY( multiroots STATIC ${SRC_LIST_SubSrc_multiroots} )

file(GLOB_RECURSE SRC_LIST_SubSrc_multiset ${REPO_Src_DIR}/multiset/*.c )
list(FILTER SRC_LIST_SubSrc_multiset EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( multiset STATIC ${SRC_LIST_SubSrc_multiset} )

file(GLOB_RECURSE SRC_LIST_SubSrc_ntuple ${REPO_Src_DIR}/ntuple/*.c )
list(FILTER SRC_LIST_SubSrc_ntuple EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( ntuple STATIC ${SRC_LIST_SubSrc_ntuple} )
TARGET_LINK_LIBRARIES( ntuple PRIVATE histogram)

file(GLOB_RECURSE SRC_LIST_SubSrc_ode_initval ${REPO_Src_DIR}/ode-initval/*.c )
list(FILTER SRC_LIST_SubSrc_ode_initval EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( ode_initval STATIC ${SRC_LIST_SubSrc_ode_initval} )

file(GLOB_RECURSE SRC_LIST_SubSrc_ode_initval2 ${REPO_Src_DIR}/ode-initval2/*.c )
list(FILTER SRC_LIST_SubSrc_ode_initval2 EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_ode_initval2 EXCLUDE REGEX ".*control_utils\.c")
list(FILTER SRC_LIST_SubSrc_ode_initval2 EXCLUDE REGEX ".*rksubs\.c")
list(FILTER SRC_LIST_SubSrc_ode_initval2 EXCLUDE REGEX ".*step_utils\.c")
ADD_LIBRARY( ode_initval2 STATIC ${SRC_LIST_SubSrc_ode_initval2} )

file(GLOB_RECURSE SRC_LIST_SubSrc_permutation ${REPO_Src_DIR}/permutation/*.c )
list(FILTER SRC_LIST_SubSrc_permutation EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_permutation EXCLUDE REGEX ".*_source\.c")
ADD_LIBRARY( permutation STATIC ${SRC_LIST_SubSrc_permutation} )

file(GLOB_RECURSE SRC_LIST_SubSrc_poly ${REPO_Src_DIR}/poly/*.c )
list(FILTER SRC_LIST_SubSrc_poly EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_poly EXCLUDE REGEX ".*balance\.c")
list(FILTER SRC_LIST_SubSrc_poly EXCLUDE REGEX ".*companion\.c")
list(FILTER SRC_LIST_SubSrc_poly EXCLUDE REGEX ".*qr\.c")
ADD_LIBRARY( poly STATIC ${SRC_LIST_SubSrc_poly} )

file(GLOB_RECURSE SRC_LIST_SubSrc_qrng ${REPO_Src_DIR}/qrng/*.c )
list(FILTER SRC_LIST_SubSrc_qrng EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( qrng STATIC ${SRC_LIST_SubSrc_qrng} )

file(GLOB_RECURSE SRC_LIST_SubSrc_randist ${REPO_Src_DIR}/randist/*.c )
list(FILTER SRC_LIST_SubSrc_randist EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( randist STATIC ${SRC_LIST_SubSrc_randist} )
TARGET_LINK_LIBRARIES( randist PRIVATE rng)

file(GLOB_RECURSE SRC_LIST_SubSrc_rng ${REPO_Src_DIR}/rng/*.c )
list(FILTER SRC_LIST_SubSrc_rng EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( rng STATIC ${SRC_LIST_SubSrc_rng} )

file(GLOB_RECURSE SRC_LIST_SubSrc_roots ${REPO_Src_DIR}/roots/*.c )
list(FILTER SRC_LIST_SubSrc_roots EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( roots STATIC ${SRC_LIST_SubSrc_roots} )

file(GLOB_RECURSE SRC_LIST_SubSrc_rstat ${REPO_Src_DIR}/rstat/*.c )
list(FILTER SRC_LIST_SubSrc_rstat EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( rstat STATIC ${SRC_LIST_SubSrc_rstat} )

file(GLOB_RECURSE SRC_LIST_SubSrc_siman ${REPO_Src_DIR}/siman/*.c )
list(FILTER SRC_LIST_SubSrc_siman EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( siman STATIC ${SRC_LIST_SubSrc_siman} )

file(GLOB_RECURSE SRC_LIST_SubSrc_sort ${REPO_Src_DIR}/sort/*.c )
list(FILTER SRC_LIST_SubSrc_sort EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_sort EXCLUDE REGEX ".*_source\.c")
ADD_LIBRARY( sort STATIC ${SRC_LIST_SubSrc_sort} )

file(GLOB_RECURSE SRC_LIST_SubSrc_spblas ${REPO_Src_DIR}/spblas/*.c )
list(FILTER SRC_LIST_SubSrc_spblas EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( spblas STATIC ${SRC_LIST_SubSrc_spblas} )

file(GLOB_RECURSE SRC_LIST_SubSrc_specfunc ${REPO_Src_DIR}/specfunc/*.c )
list(FILTER SRC_LIST_SubSrc_specfunc EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_specfunc EXCLUDE REGEX ".*_eval.*\.c")
list(FILTER SRC_LIST_SubSrc_specfunc EXCLUDE REGEX ".*_source\.c")
ADD_LIBRARY( specfunc STATIC ${SRC_LIST_SubSrc_specfunc} )
TARGET_LINK_LIBRARIES( specfunc PRIVATE complex)
TARGET_LINK_LIBRARIES( specfunc PRIVATE eigen)
TARGET_LINK_LIBRARIES( specfunc PRIVATE poly)

file(GLOB_RECURSE SRC_LIST_SubSrc_splinalg ${REPO_Src_DIR}/splinalg/*.c )
list(FILTER SRC_LIST_SubSrc_splinalg EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( splinalg STATIC ${SRC_LIST_SubSrc_splinalg} )
TARGET_LINK_LIBRARIES( splinalg PRIVATE matrix)
TARGET_LINK_LIBRARIES( splinalg PRIVATE linalg)
TARGET_LINK_LIBRARIES( splinalg PRIVATE spmatrix)

file(GLOB_RECURSE SRC_LIST_SubSrc_spmatrix ${REPO_Src_DIR}/spmatrix/*.c )
list(FILTER SRC_LIST_SubSrc_spmatrix EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_spmatrix EXCLUDE REGEX ".*_source\.c")
ADD_LIBRARY( spmatrix STATIC ${SRC_LIST_SubSrc_spmatrix} )
TARGET_LINK_LIBRARIES( spmatrix PRIVATE bst)

file(GLOB_RECURSE SRC_LIST_SubSrc_statistics ${REPO_Src_DIR}/statistics/*.c )
list(FILTER SRC_LIST_SubSrc_statistics EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_statistics EXCLUDE REGEX ".*_source\.c")
list(APPEND SRC_LIST_SubSrc_statistics ${REPO_Src_DIR}/statistics/ttest.c )
ADD_LIBRARY( statistics STATIC ${SRC_LIST_SubSrc_statistics} )
TARGET_LINK_LIBRARIES( statistics PRIVATE sort)

file(GLOB_RECURSE SRC_LIST_SubSrc_sum ${REPO_Src_DIR}/sum/*.c )
list(FILTER SRC_LIST_SubSrc_sum EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( sum STATIC ${SRC_LIST_SubSrc_sum} )

file(GLOB_RECURSE SRC_LIST_SubSrc_sys ${REPO_Src_DIR}/sys/*.c )
list(FILTER SRC_LIST_SubSrc_sys EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( sys STATIC ${SRC_LIST_SubSrc_sys} )

file(GLOB_RECURSE SRC_LIST_SubSrc_vector ${REPO_Src_DIR}/vector/*.c )
list(FILTER SRC_LIST_SubSrc_vector EXCLUDE REGEX ".*test.*")
list(FILTER SRC_LIST_SubSrc_vector EXCLUDE REGEX ".*_source\.c")
ADD_LIBRARY( vector STATIC ${SRC_LIST_SubSrc_vector} )
TARGET_LINK_LIBRARIES( vector PRIVATE blas)
TARGET_LINK_LIBRARIES( vector PRIVATE block)

file(GLOB_RECURSE SRC_LIST_SubSrc_wavelet ${REPO_Src_DIR}/wavelet/*.c )
list(FILTER SRC_LIST_SubSrc_wavelet EXCLUDE REGEX ".*test.*")
ADD_LIBRARY( wavelet STATIC ${SRC_LIST_SubSrc_wavelet} )

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
    INTERFACE deriv 
    INTERFACE dht
    INTERFACE diff 
    INTERFACE eigen 
    INTERFACE err 
    INTERFACE fft 
    INTERFACE filter 
    INTERFACE fit 
    INTERFACE histogram 
    INTERFACE ieee_utils
    INTERFACE integration 
    INTERFACE interpolation 
    INTERFACE linalg
    INTERFACE matrix
    INTERFACE min 
    INTERFACE monte 
    INTERFACE movstat 
    INTERFACE multifit 
    INTERFACE multifit_nlinear 
    INTERFACE multilarge 
    INTERFACE multilarge_nlinear 
    INTERFACE multimin 
    INTERFACE multiroots
    INTERFACE multiset
    INTERFACE ntuple
    INTERFACE ode_initval
    INTERFACE ode_initval2
    INTERFACE permutation 
    INTERFACE poly 
    INTERFACE qrng
    INTERFACE randist 
    INTERFACE rng 
    INTERFACE roots
    INTERFACE rstat
    INTERFACE siman
    INTERFACE sort 
    INTERFACE spblas
    INTERFACE specfunc 
    INTERFACE splinalg
    INTERFACE spmatrix
    INTERFACE statistics
    INTERFACE sum 
    INTERFACE sys 
    INTERFACE vector 
    INTERFACE wavelet
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
ADD_EXECUTABLE( test_bspline ${SRC_LIST_TestSuite_bspline} )
TARGET_LINK_LIBRARIES( test_bspline 
    PRIVATE test 
    PRIVATE gsl 
)

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

SET ( SRC_LIST_TestSuite_cheb
    ${REPO_Src_DIR}/cheb/test.c
)
ADD_EXECUTABLE( test_cheb ${SRC_LIST_TestSuite_cheb} )
TARGET_LINK_LIBRARIES( test_cheb 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_combination
    ${REPO_Src_DIR}/combination/test.c
)
ADD_EXECUTABLE( test_combination ${SRC_LIST_TestSuite_combination} )
TARGET_LINK_LIBRARIES( test_combination 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_complex
    ${REPO_Src_DIR}/complex/test.c
)
ADD_EXECUTABLE( test_complex ${SRC_LIST_TestSuite_complex} )
TARGET_LINK_LIBRARIES( test_complex 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_const
    ${REPO_Src_DIR}/const/test.c
)
ADD_EXECUTABLE( test_const ${SRC_LIST_TestSuite_const} )
TARGET_LINK_LIBRARIES( test_const 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_deriv
    ${REPO_Src_DIR}/deriv/test.c
)
ADD_EXECUTABLE( test_deriv ${SRC_LIST_TestSuite_deriv} )
TARGET_LINK_LIBRARIES( test_deriv 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_dht
    ${REPO_Src_DIR}/dht/test.c
)
ADD_EXECUTABLE( test_dht ${SRC_LIST_TestSuite_dht} )
TARGET_LINK_LIBRARIES( test_dht 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_diff
    ${REPO_Src_DIR}/diff/test.c
)
ADD_EXECUTABLE( test_diff ${SRC_LIST_TestSuite_diff} )
TARGET_LINK_LIBRARIES( test_diff 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_eigen
    ${REPO_Src_DIR}/eigen/test.c
)
ADD_EXECUTABLE( test_eigen ${SRC_LIST_TestSuite_eigen} )
TARGET_LINK_LIBRARIES( test_eigen 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_err
    ${REPO_Src_DIR}/err/test.c
)
ADD_EXECUTABLE( test_err ${SRC_LIST_TestSuite_err} )
TARGET_LINK_LIBRARIES( test_err 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_fft
    ${REPO_Src_DIR}/fft/signals.c
    ${REPO_Src_DIR}/fft/test.c
)
ADD_EXECUTABLE( test_fft ${SRC_LIST_TestSuite_fft} )
TARGET_LINK_LIBRARIES( test_fft 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_filter
    ${REPO_Src_DIR}/filter/test.c
)
ADD_EXECUTABLE( test_filter ${SRC_LIST_TestSuite_filter} )
TARGET_LINK_LIBRARIES( test_filter 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_fit ${REPO_Src_DIR}/fit/test*.c )
ADD_EXECUTABLE( test_fit ${SRC_LIST_TestSuite_fit} )
TARGET_LINK_LIBRARIES( test_fit 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_histogram ${REPO_Src_DIR}/histogram/test*.c )
ADD_EXECUTABLE( test_histogram ${SRC_LIST_TestSuite_histogram} )
TARGET_LINK_LIBRARIES( test_histogram 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_ieee_utils
    ${REPO_Src_DIR}/ieee-utils/test.c
)
ADD_EXECUTABLE( test_ieee_utils ${SRC_LIST_TestSuite_ieee_utils} )
TARGET_LINK_LIBRARIES( test_ieee_utils 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_integration ${REPO_Src_DIR}/integration/test*.c )
ADD_EXECUTABLE( test_integration ${SRC_LIST_TestSuite_integration} )
TARGET_LINK_LIBRARIES( test_integration 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_interpolation
    ${REPO_Src_DIR}/interpolation/test.c
)
ADD_EXECUTABLE( test_interpolation ${SRC_LIST_TestSuite_interpolation} )
TARGET_LINK_LIBRARIES( test_interpolation 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_linalg
    ${REPO_Src_DIR}/linalg/test.c
)
ADD_EXECUTABLE( test_linalg ${SRC_LIST_TestSuite_linalg} )
TARGET_LINK_LIBRARIES( test_linalg 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_matrix
    ${REPO_Src_DIR}/matrix/test.c
)
ADD_EXECUTABLE( test_matrix ${SRC_LIST_TestSuite_matrix} )
TARGET_LINK_LIBRARIES( test_matrix 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_min ${REPO_Src_DIR}/min/test*.c )
list(FILTER SRC_LIST_TestSuite_min EXCLUDE REGEX ".*tests\.c")
ADD_EXECUTABLE( test_min ${SRC_LIST_TestSuite_min} )
TARGET_LINK_LIBRARIES( test_min 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_monte
    ${REPO_Src_DIR}/monte/test.c
)
ADD_EXECUTABLE( test_monte ${SRC_LIST_TestSuite_monte} )
TARGET_LINK_LIBRARIES( test_monte 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_movstat
    ${REPO_Src_DIR}/movstat/test.c
)
ADD_EXECUTABLE( test_movstat ${SRC_LIST_TestSuite_movstat} )
TARGET_LINK_LIBRARIES( test_movstat 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_multifit
    ${REPO_Src_DIR}/multifit/test.c
)
ADD_EXECUTABLE( test_multifit ${SRC_LIST_TestSuite_multifit} )
TARGET_LINK_LIBRARIES( test_multifit 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_multifit_nlinear
    ${REPO_Src_DIR}/multifit_nlinear/test.c
)
ADD_EXECUTABLE( test_multifit_nlinear ${SRC_LIST_TestSuite_multifit_nlinear} )
TARGET_LINK_LIBRARIES( test_multifit_nlinear 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_multilarge
    ${REPO_Src_DIR}/multilarge/test.c
)
ADD_EXECUTABLE( test_multilarge ${SRC_LIST_TestSuite_multilarge} )
TARGET_LINK_LIBRARIES( test_multilarge 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_multilarge_nlinear
    ${REPO_Src_DIR}/multilarge_nlinear/test.c
)
ADD_EXECUTABLE( test_multilarge_nlinear ${SRC_LIST_TestSuite_multilarge_nlinear} )
TARGET_LINK_LIBRARIES( test_multilarge_nlinear 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_multimin ${REPO_Src_DIR}/multimin/test*.c )
ADD_EXECUTABLE( test_multimin ${SRC_LIST_TestSuite_multimin} )
TARGET_LINK_LIBRARIES( test_multimin 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_multiroots ${REPO_Src_DIR}/multiroots/test*.c )
ADD_EXECUTABLE( test_multiroots ${SRC_LIST_TestSuite_multiroots} )
TARGET_LINK_LIBRARIES( test_multiroots 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_multiset
    ${REPO_Src_DIR}/multiset/test.c
)
ADD_EXECUTABLE( test_multiset ${SRC_LIST_TestSuite_multiset} )
TARGET_LINK_LIBRARIES( test_multiset 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_ntuple
    ${REPO_Src_DIR}/ntuple/test.c
)
ADD_EXECUTABLE( test_ntuple ${SRC_LIST_TestSuite_ntuple} )
TARGET_LINK_LIBRARIES( test_ntuple 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_ode_initval
    ${REPO_Src_DIR}/ode-initval/test.c
)
ADD_EXECUTABLE( test_ode_initval ${SRC_LIST_TestSuite_ode_initval} )
TARGET_LINK_LIBRARIES( test_ode_initval 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_ode_initval2
    ${REPO_Src_DIR}/ode-initval2/test.c
)
ADD_EXECUTABLE( test_ode_initval2 ${SRC_LIST_TestSuite_ode_initval2} )
TARGET_LINK_LIBRARIES( test_ode_initval2 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_permutation
    ${REPO_Src_DIR}/permutation/test.c
)
ADD_EXECUTABLE( test_permutation ${SRC_LIST_TestSuite_permutation} )
TARGET_LINK_LIBRARIES( test_permutation 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_poly
    ${REPO_Src_DIR}/poly/test.c
)
ADD_EXECUTABLE( test_poly ${SRC_LIST_TestSuite_poly} )
TARGET_LINK_LIBRARIES( test_poly 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_qrng
    ${REPO_Src_DIR}/qrng/test.c
)
ADD_EXECUTABLE( test_qrng ${SRC_LIST_TestSuite_qrng} )
TARGET_LINK_LIBRARIES( test_qrng 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_randist
    ${REPO_Src_DIR}/randist/test.c
)
ADD_EXECUTABLE( test_randist ${SRC_LIST_TestSuite_randist} )
TARGET_LINK_LIBRARIES( test_randist 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_rng
    ${REPO_Src_DIR}/rng/test.c
)
ADD_EXECUTABLE( test_rng ${SRC_LIST_TestSuite_rng} )
TARGET_LINK_LIBRARIES( test_rng 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_roots ${REPO_Src_DIR}/roots/test*.c )
ADD_EXECUTABLE( test_roots ${SRC_LIST_TestSuite_roots} )
TARGET_LINK_LIBRARIES( test_roots 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_rstat ${REPO_Src_DIR}/rstat/test*.c )
ADD_EXECUTABLE( test_rstat ${SRC_LIST_TestSuite_rstat} )
TARGET_LINK_LIBRARIES( test_rstat 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_siman ${REPO_Src_DIR}/siman/test*.c )
ADD_EXECUTABLE( test_siman ${SRC_LIST_TestSuite_siman} )
TARGET_LINK_LIBRARIES( test_siman 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_sort
    ${REPO_Src_DIR}/sort/test.c
)
ADD_EXECUTABLE( test_sort ${SRC_LIST_TestSuite_sort} )
TARGET_LINK_LIBRARIES( test_sort 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_spblas ${REPO_Src_DIR}/spblas/test*.c )
ADD_EXECUTABLE( test_spblas ${SRC_LIST_TestSuite_spblas} )
TARGET_LINK_LIBRARIES( test_spblas 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_splinalg ${REPO_Src_DIR}/splinalg/test*.c )
ADD_EXECUTABLE( test_splinalg ${SRC_LIST_TestSuite_splinalg} )
TARGET_LINK_LIBRARIES( test_splinalg 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_specfunc ${REPO_Src_DIR}/specfunc/test*.c )
ADD_EXECUTABLE( test_specfunc ${SRC_LIST_TestSuite_specfunc} )
TARGET_LINK_LIBRARIES( test_specfunc 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_statistics ${REPO_Src_DIR}/statistics/test*.c )
list(FILTER SRC_LIST_TestSuite_statistics EXCLUDE REGEX ".*_source\.c")
ADD_EXECUTABLE( test_statistics ${SRC_LIST_TestSuite_statistics} )
TARGET_LINK_LIBRARIES( test_statistics 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_sum ${REPO_Src_DIR}/sum/test*.c )
ADD_EXECUTABLE( test_sum ${SRC_LIST_TestSuite_sum} )
TARGET_LINK_LIBRARIES( test_sum 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_sys ${REPO_Src_DIR}/sys/test*.c )
ADD_EXECUTABLE( test_sys ${SRC_LIST_TestSuite_sys} )
TARGET_LINK_LIBRARIES( test_sys 
    PRIVATE test 
    PRIVATE gsl 
)

SET ( SRC_LIST_TestSuite_vector
    ${REPO_Src_DIR}/vector/test.c
)
ADD_EXECUTABLE( test_vector ${SRC_LIST_TestSuite_vector} )
TARGET_LINK_LIBRARIES( test_vector 
    PRIVATE test 
    PRIVATE gsl 
)

file(GLOB_RECURSE SRC_LIST_TestSuite_wavelet ${REPO_Src_DIR}/wavelet/test*.c )
ADD_EXECUTABLE( test_wavelet ${SRC_LIST_TestSuite_wavelet} )
TARGET_LINK_LIBRARIES( test_wavelet 
    PRIVATE test 
    PRIVATE gsl 
)
