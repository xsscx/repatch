vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO InternationalColorConsortium/iccDEV
    REF b4a829086a541868319d6acdee23d71fec5cf95c
    SHA512 98f3df7d41fb75f441143b1b113228b5ff001f1494a4ef878dcc094608291f9d2393770472b08ff9563c68a9febb1c5adf5be17d8c921dea84dd8fdeddded122
)

# Make libxml2/iconv headers visible
list(APPEND CMAKE_INCLUDE_PATH "${CURRENT_INSTALLED_DIR}/include")

# Common options for one configure
set(_COMMON_OPTS
    -DENABLE_TESTS=OFF
    -DENABLE_INSTALL_RIM=ON
    -DENABLE_ICCXML=ON
    -DENABLE_SHARED_LIBS=ON
    -DENABLE_STATIC_LIBS=ON
    -DENABLE_TOOLS=ON
    -DCMAKE_DEBUG_POSTFIX=
    # Hint paths if upstream does any find_library fallback
    "-DCMAKE_PREFIX_PATH=${CURRENT_PACKAGES_DIR};${CURRENT_INSTALLED_DIR}"
    "-DCMAKE_LIBRARY_PATH=${CURRENT_PACKAGES_DIR}/lib;${CURRENT_PACKAGES_DIR}/debug/lib"
    "-DCMAKE_INCLUDE_PATH=${CURRENT_INSTALLED_DIR}/include"
    # CRITICAL: tell IccXML to link the *target*, not a raw .lib path
    -DTARGET_LIB_ICCPROFLIB=IccProfLib2
)

# DO NOT override MSVC runtime; keep vcpkg defaults (/MD, /MDd)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/Build/Cmake"
    OPTIONS ${_COMMON_OPTS}
)

# --- Stage 1:
# If upstream ever renames these, swap the target names accordingly.
vcpkg_cmake_build(TARGET IccProfLib2)   # core color lib
vcpkg_cmake_build(TARGET IccXML2)       # XML lib depends on the core lib
vcpkg_cmake_install()

# --- Stage 2:
vcpkg_cmake_build()
vcpkg_cmake_install()

# Fix CMake package layout if upstream uses a custom subdir
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/reficcmax)

# Housekeeping
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")

# Policies actually needed
set(VCPKG_POLICY_SKIP_ABSOLUTE_PATHS_CHECK enabled)
set(VCPKG_POLICY_SKIP_MISPLACED_CMAKE_FILES_CHECK enabled)
set(VCPKG_POLICY_DLLS_WITHOUT_EXPORTS enabled)