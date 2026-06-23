# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. Keep this floor conservative for downstream consumers.
cmake_minimum_required(VERSION 3.10)

project(jpl_moshier_ephemeris_dart LANGUAGES CXX)

set(JME_LIB_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../libs")

if(CMAKE_SYSTEM_PROCESSOR MATCHES "^(x86_64|amd64|AMD64)$")
  set(JME_ARCH_DIR "linux-x64")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64|arm64|ARM64)$")
  set(JME_ARCH_DIR "linux-arm64")
else()
  message(FATAL_ERROR "Unsupported Linux architecture: ${CMAKE_SYSTEM_PROCESSOR}")
endif()

set(jpl_moshier_ephemeris_dart_bundled_libraries
  "${JME_LIB_ROOT}/${JME_ARCH_DIR}/libjme.so"
  "${JME_LIB_ROOT}/${JME_ARCH_DIR}/libcalceph.so"
  "${JME_LIB_ROOT}/${JME_ARCH_DIR}/libcalceph.so.2"
  "${JME_LIB_ROOT}/${JME_ARCH_DIR}/libcalceph.so.2.0.5"
  PARENT_SCOPE
)
