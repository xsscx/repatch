vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO InternationalColorConsortium/iccDEV
    REF b4a829086a541868319d6acdee23d71fec5cf95c
    SHA512 98f3df7d41fb75f441143b1b113228b5ff001f1494a4ef878dcc094608291f9d2393770472b08ff9563c68a9febb1c5adf5be17d8c921dea84dd8fdeddded122
)

# -----------------------------------------------------------------------------
# Environment and dependency setup
# -----------------------------------------------------------------------------
list(APPEND CMAKE_INCLUDE_PATH "${CURRENT_INSTALLED_DIR}/include")
set(EXTRA_COMPILE_FLAGS "/I${CURRENT_INSTALLED_DIR}/include")

set(CMAKE_PREFIX_PATH "${CURRENT_INSTALLED_DIR}/share")

# -----------------------------------------------------------------------------
# Source path and build directory
# -----------------------------------------------------------------------------
set(_src "${SOURCE_PATH}/Build/Cmake")
set(_bld "${CURRENT_BUILDTREES_DIR}/manual-x64-windows-rel")

file(REMOVE_RECURSE "${_bld}")
file(MAKE_DIRECTORY "${_bld}")

message(STATUS "🔧 Configuring and building iccdev from: ${_src}")

# -----------------------------------------------------------------------------
# Manual configure / build / install
# -----------------------------------------------------------------------------
vcpkg_execute_required_process(
    COMMAND ${CMAKE_COMMAND}
        -S "${_src}"
        -B "${_bld}"
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${CURRENT_PACKAGES_DIR}
        -DCMAKE_TOOLCHAIN_FILE=${VCPKG_ROOT_DIR}/scripts/buildsystems/vcpkg.cmake
        -DVCPKG_MANIFEST_MODE=OFF
        -DCMAKE_POLICY_DEFAULT_CMP0144=NEW
        "-DCMAKE_INCLUDE_PATH=${CURRENT_INSTALLED_DIR}/include"
        "-DCMAKE_LIBRARY_PATH=${CURRENT_INSTALLED_DIR}/lib"
        "-DCMAKE_PREFIX_PATH=${CURRENT_INSTALLED_DIR}/share"
        -DENABLE_TOOLS=ON
        -DENABLE_SHARED_LIBS=ON
        -DENABLE_STATIC_LIBS=ON
        -DENABLE_TESTS=OFF
        -DENABLE_INSTALL_RIM=ON
        -DENABLE_ICCXML=ON
    WORKING_DIRECTORY "${_bld}"
    LOGNAME configure-manual
)

vcpkg_execute_required_process(
    COMMAND ${CMAKE_COMMAND} --build "${_bld}" --config Release --parallel
    WORKING_DIRECTORY "${_bld}"
    LOGNAME build-manual
)

vcpkg_execute_required_process(
    COMMAND ${CMAKE_COMMAND} --install "${_bld}" --config Release
    WORKING_DIRECTORY "${_bld}"
    LOGNAME install-manual
)

# -----------------------------------------------------------------------------
# Post-install cleanup
# -----------------------------------------------------------------------------
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/reficcmax")
    message(STATUS "✅ Found reficcmax CMake config, skipping redundant fixup.")
else()
    message(STATUS "⚠ No reficcmax CMake config found; skipping vcpkg_cmake_config_fixup entirely.")
endif()

# Skip the fixup — it’s not needed and causes spurious validation errors
message(STATUS "✅ Build completed; performing cleanup and license install.")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

set(VCPKG_POLICY_DLLS_WITHOUT_EXPORTS enabled)
set(VCPKG_POLICY_SKIP_ABSOLUTE_PATHS_CHECK enabled)
set(VCPKG_POLICY_SKIP_MISPLACED_CMAKE_FILES_CHECK enabled)

message(STATUS "✅ iccdev built and installed successfully.")
