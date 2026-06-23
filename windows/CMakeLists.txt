# The Flutter tooling requires that developers have Visual Studio with
# CMake 3.14 or later. Keep this floor aligned with the template.
cmake_minimum_required(VERSION 3.14)

project(jpl_moshier_ephemeris_dart LANGUAGES CXX)

if(NOT CMAKE_SYSTEM_PROCESSOR MATCHES "^(x86_64|amd64|AMD64)$")
  message(FATAL_ERROR "Unsupported Windows architecture: ${CMAKE_SYSTEM_PROCESSOR}")
endif()

set(JME_LIB_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../libs/windows-x64")

set(jpl_moshier_ephemeris_dart_bundled_libraries
  "${JME_LIB_ROOT}/jme.dll"
  "${JME_LIB_ROOT}/calceph.dll"
  PARENT_SCOPE
)
