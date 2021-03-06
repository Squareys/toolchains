#
# Toolchain for compiling NaCl applications for x86-64 using newlib.
#
# Modify NACL_PREFIX to your liking.
#
#  mkdir build-nacl-x86-64 && cd build-nacl-x86-64
#  cmake .. -DCMAKE_TOOLCHAIN_FILE=../toolchains/generic/NaCl-newlib-x86-64.cmake
#

set(CMAKE_SYSTEM_NAME NaCl)

# Help CMake find the platform file
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_LIST_DIR}/../modules)

set(NACL_PREFIX "/usr/nacl")

set(NACL_TOOLCHAIN newlib)
set(NACL_BITS 64)
set(NACL_ARCH x86_64)

set(NACL_ARCH_GCC -m${NACL_BITS})
set(NACL_ARCH_NMF x86-${NACL_BITS})
set(NACL_TOOLCHAIN_PATH "${NACL_PREFIX}/toolchain/linux_x86_${NACL_TOOLCHAIN}/")
set(CMAKE_C_COMPILER "${NACL_TOOLCHAIN_PATH}/bin/${NACL_ARCH}-nacl-gcc")
set(CMAKE_CXX_COMPILER "${NACL_TOOLCHAIN_PATH}/bin/${NACL_ARCH}-nacl-g++")
set(CMAKE_FIND_ROOT_PATH ${CMAKE_FIND_ROOT_PATH}
    "${NACL_TOOLCHAIN_PATH}/x86_64-nacl"
    "${NACL_PREFIX}")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

include_directories("${NACL_PREFIX}/include")
