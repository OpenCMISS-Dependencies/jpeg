
 # ***** BEGIN LICENSE BLOCK *****
 # Version: MPL 1.1/GPL 2.0/LGPL 2.1
 #
 # The contents of this file are subject to the Mozilla Public License Version
 # 1.1 (the "License"); you may not use this file except in compliance with
 # the License. You may obtain a copy of the License at
 # http://www.mozilla.org/MPL/
 #
 # Software distributed under the License is distributed on an "AS IS" basis,
 # WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 # for the specific language governing rights and limitations under the
 # License.
 #
 # The Original Code is cmgui
 #
 # The Initial Developer of the Original Code is
 # Auckland Uniservices Ltd, Auckland, New Zealand.
 # Portions created by the Initial Developer are Copyright (C) 2005
 # the Initial Developer. All Rights Reserved.
 #
 # Contributor(s): 
 #
 # Alternatively, the contents of this file may be used under the terms of
 # either the GNU General Public License Version 2 or later (the "GPL"), or
 # the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 # in which case the provisions of the GPL or the LGPL are applicable instead
 # of those above. If you wish to allow use of your version of this file only
 # under the terms of either the GPL or the LGPL, and not to allow others to
 # use your version of this file under the terms of the MPL, indicate your
 # decision by deleting the provisions above and replace them with the notice
 # and other provisions required by the GPL or the LGPL. If you do not delete
 # the provisions above, a recipient may use your version of this file under
 # the terms of any one of the MPL, the GPL or the LGPL.
 #
 # ***** END LICENSE BLOCK ***** */

# Set the minimum version of cmake required to 2.6
cmake_minimum_required( VERSION 3.10 )

project(JPEG VERSION 9.4.0 LANGUAGES C)
set(CMAKE_POSITION_INDEPENDENT_CODE YES)

set( LIBRARY_TARGET_NAME jpeg )
string( TOUPPER ${LIBRARY_TARGET_NAME} UPPERCASE_LIBRARY_TARGET_NAME )
set( ADDITIONAL_TARGETS CJPEG DJPEG JPEGTRAN RDJPGCOM WRJPGCOM )
foreach( ADDITIONAL_TARGET ${ADDITIONAL_TARGETS} )
        string( TOLOWER ${ADDITIONAL_TARGET} LOWERCASE_ADDITIONAL_TARGET )
        set( ${ADDITIONAL_TARGET}_TARGET_NAME ${LOWERCASE_ADDITIONAL_TARGET} )
endforeach( ADDITIONAL_TARGET ${ADDITIONAL_TAGETS} )

macro(CACHE_VAR_WITH_DEFAULT OPTION_NAME OPTION_DEFAULT OPTION_TYPE OPTION_DESCRIPTION)
    set(${UPPERCASE_LIBRARY_TARGET_NAME}_${OPTION_NAME} "${OPTION_DEFAULT}" CACHE ${OPTION_TYPE} "${OPTION_STRING}")
    if(DEFINED ${OPTION_NAME})
        set(${UPPERCASE_LIBRARY_TARGET_NAME}_${OPTION_NAME} "${${OPTION_NAME}}" CACHE STRING "${OPTION_STRING}" FORCE)
    endif()
    unset(${OPTION_NAME} CACHE)
endmacro()


# Set up library options
# Generic library options
cache_var_with_default(BUILD_TYPE "Release" STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel")
set(CMAKE_BUILD_TYPE ${${UPPERCASE_LIBRARY_TARGET_NAME}_BUILD_TYPE} CACHE
	INTERNAL "Internalise this variable and manipulate with
        ${UPPERCASE_LIBRARY_TARGET_NAME}_BUILD_TYPE" FORCE)

cache_var_with_default(INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}" PATH "Install path prefix, prepended onto install directories.")
set(CMAKE_INSTALL_PREFIX ${${UPPERCASE_LIBRARY_TARGET_NAME}_INSTALL_PREFIX}
    CACHE INTERNAL "Internalise this variable and manipulate with
    ${UPPERCASE_LIBRARY_TARGET_NAME}_INSTALL_PREFIX" FORCE )

set(_CONFIG_DIR "cmake")
if(UNIX)
    set(_CONFIG_DIR "share/${_CONFIG_DIR}")
endif()

cache_var_with_default(PACKAGE_CONFIG_DIR "${_CONFIG_DIR}" STRING "Relative path for CMake package configuration files.")
cache_var_with_default(BUILD_STATIC_LIB TRUE BOOL "Build static zlib")
cache_var_with_default(INSTALL_CONFIG FALSE BOOL "Install a config file for the library")

# Specific library options
cache_var_with_default( BUILD_CJPEG TRUE BOOL "Build cjpeg${CMAKE_EXECUTABLE_SUFFIX}")
cache_var_with_default( BUILD_DJPEG TRUE BOOL "Build djpeg${CMAKE_EXECUTABLE_SUFFIX}")
cache_var_with_default( BUILD_JPEGTRAN TRUE BOOL "Build jpegtran${CMAKE_EXECUTABLE_SUFFIX}")
cache_var_with_default( BUILD_RDJPGCOM TRUE BOOL "Build rdjpgcom${CMAKE_EXECUTABLE_SUFFIX}")
cache_var_with_default( BUILD_WRJPGCOM TRUE BOOL "Build wrjpgcom${CMAKE_EXECUTABLE_SUFFIX}")

foreach( ADDITIONAL_TARGET ${ADDITIONAL_TARGETS} )
    if( NOT ${UPPERCASE_LIBRARY_TARGET_NAME}_BUILD_${ADDITIONAL_TARGET} )
        set( EXCLUDE_${ADDITIONAL_TARGET} EXCLUDE_FROM_ALL )
    endif( NOT ${UPPERCASE_LIBRARY_TARGET_NAME}_BUILD_${ADDITIONAL_TARGET} )
endforeach( ADDITIONAL_TARGET ${ADDITIONAL_TARGETS} )

IF( MSVC )
	ADD_DEFINITIONS( -D_CRT_SECURE_NO_WARNINGS )
ENDIF( MSVC )
IF( ${UPPERCASE_LIBRARY_TARGET_NAME}_BUILD_STATIC_LIB )
	SET( LIBRARY_BUILD_TYPE STATIC )
	SET( LIBRARY_INSTALL_TYPE ARCHIVE )
ELSE( ${UPPERCASE_LIBRARY_TARGET_NAME}_BUILD_STATIC_LIB )
	SET( LIBRARY_BUILD_TYPE SHARED )
	SET( LIBRARY_INSTALL_TYPE LIBRARY )
	IF( WIN32 )
		SET( LIBRARY_INSTALL_TYPE RUNTIME )
	ENDIF( WIN32 )
ENDIF( ${UPPERCASE_LIBRARY_TARGET_NAME}_BUILD_STATIC_LIB )

IF ( MAC )
	SET( SYSTEM_DEPENDENT_SRCS jmemmac.c )
ELSE( MAC )
	SET( SYSTEM_DEPENDENT_SRCS jmemnobs.c )
ENDIF ( MAC )

SET( LIBRARY_SRCS
    jaricom.c jcapimin.c jcapistd.c jcarith.c
    jccoefct.c jccolor.c jcdctmgr.c jchuff.c jcinit.c
    jcmainct.c jcmarker.c jcmaster.c jcomapi.c jcparam.c
    jcprepct.c jcsample.c jctrans.c jdapimin.c jdapistd.c
    jdarith.c jdatadst.c jdatasrc.c jdcoefct.c jdcolor.c
    jddctmgr.c jdhuff.c jdinput.c jdmainct.c jdmarker.c
    jdmaster.c jdmerge.c jdpostct.c jdsample.c jdtrans.c
    jerror.c jfdctflt.c jfdctfst.c jfdctint.c jidctflt.c
    jidctfst.c jidctint.c jquant1.c jquant2.c jutils.c
    jmemmgr.c )
SET( LIBRARY_PUBLIC_HDRS
	jpeglib.h jmorecfg.h jerror.h )
SET( LIBRARY_PRIVATE_HDRS
        jdct.h jinclude.h jmemsys.h
	jpegint.h jversion.h cdjpeg.h cderror.h transupp.h )
SET( CJPEG_SRCS
	cjpeg.c cdjpeg.c rdppm.c rdgif.c 
	rdtarga.c rdrle.c rdbmp.c rdswitch.c )
SET( DJPEG_SRCS
	djpeg.c cdjpeg.c wrppm.c wrgif.c 
	wrtarga.c wrrle.c wrbmp.c rdcolmap.c )
SET( JPEGTRAN_SRCS
	jpegtran.c rdswitch.c cdjpeg.c transupp.c )
SET( RDJPGCOM_SRCS
	rdjpgcom.c )
SET( WRJPGCOM_SRCS
	wrjpgcom.c )

SET( CMAKE_DEBUG_POSTFIX d )
SET( CMAKE_MFC_FLAG 0 )

if( WIN32 AND NOT ${UPPERCASE_LIBRARY_TARGET_NAME}_BUILD_STATIC_LIB )
    set(LIBRARY_WIN32_XTRAS
        libjpeg.def)
endif( WIN32 AND NOT ${UPPERCASE_LIBRARY_TARGET_NAME}_BUILD_STATIC_LIB )

# Set defines for jconfig.h
SET( JCONFIG_HDR_FILE ${CMAKE_CURRENT_BINARY_DIR}/jconfig.h )
IF( WIN32 )
    CONFIGURE_FILE( ${CMAKE_CURRENT_SOURCE_DIR}/jconfig.vc ${JCONFIG_HDR_FILE} )
ELSE( WIN32 )
    INCLUDE( CheckIncludeFile )
    INCLUDE( CheckSymbolExists )
    INCLUDE( CheckTypeSize )
    CHECK_INCLUDE_FILE( stddef.h HAVE_STDDEF_H )
    CHECK_INCLUDE_FILE( stdlib.h HAVE_STDLIB_H )
    CHECK_INCLUDE_FILE( string.h HAVE_STRING_H )
    CHECK_INCLUDE_FILE( strings.h HAVE_STRINGS_H )
    IF( NOT HAVE_STRING_H AND HAVE_STRINGS_H )
        SET( NEED_BSD_STRINGS 1 )
    ENDIF( NOT HAVE_STRING_H AND HAVE_STRINGS_H )
    CHECK_TYPE_SIZE( size_t HAVE_SIZE_T )
    CHECK_TYPE_SIZE( "unsigned char" HAVE_UNSIGNED_CHAR )
    CHECK_TYPE_SIZE( "unsigned short" HAVE_UNSIGNED_SHORT )
    IF( NOT HAVE_SIZE_T )
        CHECK_SYMBOL_EXISTS( size_t sys/types.h NEED_SYS_TYPES_H )
    ENDIF( NOT HAVE_SIZE_T )
    SET( NEED_SHORT_EXTERNAL_NAMES 0 )
    SET( HAVE_PROTOTYPES 1 )
    CONFIGURE_FILE( ${CMAKE_CURRENT_SOURCE_DIR}/jconfig.cmake ${JCONFIG_HDR_FILE} )
ENDIF( WIN32 )

SET( LIBRARY_PUBLIC_HDRS ${LIBRARY_PUBLIC_HDRS} ${JCONFIG_HDR_FILE} )

add_library(${LIBRARY_TARGET_NAME} ${LIBRARY_BUILD_TYPE}
    ${LIBRARY_SRCS} ${SYSTEM_DEPENDENT_SRCS} ${LIBRARY_PUBLIC_HDRS} ${LIBRARY_PRIVATE_HDRS} ${LIBRARY_WIN32_XTRAS})
target_include_directories(${LIBRARY_TARGET_NAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
foreach( ADDITIONAL_TARGET ${ADDITIONAL_TARGETS} )
    add_executable( ${${ADDITIONAL_TARGET}_TARGET_NAME} ${EXCLUDE_${ADDITIONAL_TARGET}} ${${ADDITIONAL_TARGET}_SRCS} )
    target_link_libraries(${${ADDITIONAL_TARGET}_TARGET_NAME} ${LIBRARY_TARGET_NAME})
    target_include_directories(${${ADDITIONAL_TARGET}_TARGET_NAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
endforeach()

IF( WIN32 AND NOT BUILD_STATIC_LIB )
	SET_TARGET_PROPERTIES( ${LIBRARY_TARGET_NAME} PROPERTIES IMPORT_SUFFIX _dll.lib )
	INSTALL( TARGETS ${LIBRARY_TARGET_NAME} ARCHIVE
		DESTINATION lib )
ENDIF()

install(TARGETS ${LIBRARY_TARGET_NAME} 
    EXPORT ${LIBRARY_TARGET_NAME}-config ${LIBRARY_INSTALL_TYPE}
	DESTINATION lib
	INCLUDES DIRECTORY include )
install(FILES ${LIBRARY_PUBLIC_HDRS}
	DESTINATION include)
FOREACH( ADDITIONAL_TARGET ${ADDITIONAL_TARGETS} )
	IF( ${UPPERCASE_LIBRARY_TARGET_NAME}_BUILD_${ADDITIONAL_TARGET} )
		INSTALL( TARGETS ${${ADDITIONAL_TARGET}_TARGET_NAME} RUNTIME DESTINATION bin )
	ENDIF()
ENDFOREACH()

install(EXPORT ${LIBRARY_TARGET_NAME}-config 
        DESTINATION ${${UPPERCASE_LIBRARY_TARGET_NAME}_PACKAGE_CONFIG_DIR})
include(CMakePackageConfigHelpers)
WRITE_BASIC_PACKAGE_VERSION_FILE(${CMAKE_CURRENT_BINARY_DIR}/jpeg-config-version.cmake
    COMPATIBILITY AnyNewerVersion)
install(FILES 
    ${CMAKE_CURRENT_BINARY_DIR}/jpeg-config-version.cmake
    #${CMAKE_CURRENT_BINARY_DIR}/hypre-config-dependencies.cmake
    DESTINATION ${${UPPERCASE_LIBRARY_TARGET_NAME}_PACKAGE_CONFIG_DIR})

