@PACKAGE_INIT@

include(CMakeFindDependencyMacro)

# Dependencies (these are vcpkg-managed)
find_dependency(LibXml2 REQUIRED)
find_dependency(PNG REQUIRED)
find_dependency(JPEG REQUIRED)
find_dependency(TIFF REQUIRED)
find_dependency(nlohmann_json REQUIRED)

# Import targets file
include("${CMAKE_CURRENT_LIST_DIR}/iccdevTargets.cmake")

# Provide standard variables
set(ICCDEV_INCLUDE_DIRS "${PACKAGE_PREFIX_DIR}/include")
set(ICCDEV_LIBRARIES iccdev::iccdev)

# Backward-compatible variables for legacy projects
set(iccdev_INCLUDE_DIRS "${ICCDEV_INCLUDE_DIRS}")
set(iccdev_LIBRARIES "${ICCDEV_LIBRARIES}")

message(STATUS "Found iccdev (via vcpkg): ${PACKAGE_PREFIX_DIR}")
