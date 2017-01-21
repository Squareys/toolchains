#
# Toolchain for cross-compiling to Android ARM.
#
# Modify ANDROID_NDK_ROOT and ANDROID_SYSROOT to your liking. You might also
# need to update ANDROID_TOOLCHAIN_PREFIX and ANDROID_TOOLCHAIN_ROOT to fit
# your system.
#
#  mkdir build-android-arm && cd build-android-arm
#  cmake .. -DCMAKE_TOOLCHAIN_FILE=../toolchains/generic/Android-ARM.cmake
#
# Shared library compiled using this toolchain should behave the same as the
# one compiled with ndk-build. The libraries should be then moved into
# libs/${ANDROID_ABI} to make it available for ant, e.g.:
#
#  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/libs/${ANDROID_ABI}")
#
# In case your Android NDK does not use gcc version 4.9, modify ANDROID_GCC_VERSION
# respectively.
#

set(CMAKE_SYSTEM_NAME Android)
set(ANDROID_ARCHITECTURE "arm")
set(ANDROID_ABI "armeabi-v7a")
set(ANDROID_HOST_PLATFORM "linux-x86_64")

if(WIN32)
    set(CMAKE_COMPILER_EXECUTABLE_SUFFIX ".exe")
    set(ANDROID_HOST_PLATFORM "windows-x86_64")
endif()

if(NOT ANDROID_GCC_VERSION)
    set(ANDROID_GCC_VERSION "4.9")
endif()

# Help CMake find the platform file
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_LIST_DIR}/../modules)

# NDK root. It *has* to be passed as environment variable and not via -D,
# because this toolchain file gets included from project() and then from
# CMakeSystem.cmake, which FOR SOME REASON doesn't propagate stuff passed from
# command-line. I SPENT TWO DAYS FIGHTING THIS, GODDAMIT.
if(DEFINED ENV{ANDROID_NDK})
    set(ANDROID_NDK_ROOT $ENV{ANDROID_NDK})
else()
    if(WINDOWS)
        set(ANDROID_NDK_ROOT "C:/Users/Squareys/Documents/android-ndk-r11b")
    else()
        set(ANDROID_NDK_ROOT "/opt/android-ndk")
    endif()
endif()

# API level to use
set(ANDROID_SYSROOT "${ANDROID_NDK_ROOT}/platforms/android-21/arch-${ANDROID_ARCHITECTURE}/usr")

# Toolchain. See ${ANDROID_NDK_ROOT}/toolchains/ for complete list
set(ANDROID_TOOLCHAIN "arm-linux-androideabi-${ANDROID_GCC_VERSION}")
set(ANDROID_TOOLCHAIN_PREFIX "arm-linux-androideabi")
set(ANDROID_TOOLCHAIN_ROOT "${ANDROID_NDK_ROOT}/toolchains/${ANDROID_TOOLCHAIN}/prebuilt/${ANDROID_HOST_PLATFORM}")

set(CMAKE_C_COMPILER "${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TOOLCHAIN_PREFIX}-gcc${CMAKE_COMPILER_EXECUTABLE_SUFFIX}")
set(CMAKE_CXX_COMPILER "${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TOOLCHAIN_PREFIX}-g++${CMAKE_COMPILER_EXECUTABLE_SUFFIX}")
set(CMAKE_FIND_ROOT_PATH ${CMAKE_FIND_ROOT_PATH}
    ${ANDROID_TOOLCHAIN_ROOT}
    ${ANDROID_SYSROOT})

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Native App Glue
set(ANDROID_NATIVE_APP_GLUE_INCLUDE_DIR "${ANDROID_NDK_ROOT}/sources/android/native_app_glue/")
set(ANDROID_NATIVE_APP_GLUE_SRC "${ANDROID_NATIVE_APP_GLUE_INCLUDE_DIR}/android_native_app_glue.c")

# The rest is shared between ARM and x86
include(${CMAKE_CURRENT_LIST_DIR}/../modules/AndroidSetup.cmake)
