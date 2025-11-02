## Windows vcpkg ports reproduction

02-NOV-2025

## VCPKG Ports File

```
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO InternationalColorConsortium/iccDEV
    REF 1c50f5479c395cca9cbc7bcb5ff69f5f7e6357eb
    SHA512 6faab14844e0cf6b2ff701a8975ae834279cd25592a524850af201f35701bc41c468fdff2ef3aacd35b501a1dbf75e59ce3d48b6f72bdad92b0ef4a958d442ad
)

# Inject include paths to satisfy libxml2's iconv.h dependency
list(APPEND CMAKE_INCLUDE_PATH "${CURRENT_INSTALLED_DIR}/include")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/Build/Cmake"
    OPTIONS
        -DENABLE_TOOLS=OFF
        -DENABLE_SHARED_LIBS=ON
        -DENABLE_STATIC_LIBS=ON
        -DENABLE_TESTS=OFF
        -DENABLE_INSTALL_RIM=ON
        -DENABLE_ICCXML=ON
        "-DCMAKE_C_FLAGS=/I${CURRENT_INSTALLED_DIR}/include"
        "-DCMAKE_CXX_FLAGS=/I${CURRENT_INSTALLED_DIR}/include"
    OPTIONS_RELEASE -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
    OPTIONS_DEBUG -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug
)

vcpkg_cmake_build()
vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/reficcmax)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

set(VCPKG_POLICY_SKIP_ABSOLUTE_PATHS_CHECK enabled)
set(VCPKG_POLICY_SKIP_MISPLACED_CMAKE_FILES_CHECK enabled)

```



### Reproduction

```
C:\test>vcpkg\vcpkg.exe --classic install iccdev iccdev:x64-windows --overlay-ports=ports

...

Computing installation plan...
The following packages will be built and installed:
    iccdev:x64-windows@2.2.50 -- C:\test\ports\iccdev
Detecting compiler hash for triplet x64-windows...
Compiler found: C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/Hostx64/x64/cl.exe
Restored 0 package(s) from C:\Users\User\AppData\Local\vcpkg\archives in 122 us. Use --debug to see more details.
Installing 1/1 iccdev:x64-windows@2.2.50...
Building iccdev:x64-windows@2.2.50...
C:\test\ports\iccdev: info: installing overlay port from here
Downloading https://github.com/InternationalColorConsortium/iccDEV/archive/1c50f5479c395cca9cbc7bcb5ff69f5f7e6357eb.tar.gz -> InternationalColorConsortium-iccDEV-1c50f5479c395cca9cbc7bcb5ff69f5f7e6357eb.tar.gz
Successfully downloaded InternationalColorConsortium-iccDEV-1c50f5479c395cca9cbc7bcb5ff69f5f7e6357eb.tar.gz
-- Extracting source C:/test/vcpkg/downloads/InternationalColorConsortium-iccDEV-1c50f5479c395cca9cbc7bcb5ff69f5f7e6357eb.tar.gz
-- Using source at C:/test/vcpkg/buildtrees/iccdev/src/5f7e6357eb-a1fcea8901.clean
-- Configuring x64-windows
-- Building x64-windows-dbg
-- Building x64-windows-rel
-- Building x64-windows-dbg
-- Building x64-windows-rel
-- Installing: C:/test/vcpkg/packages/iccdev_x64-windows/share/iccdev/copyright
-- Performing post-build validation
C:\test\ports\iccdev\portfile.cmake: warning: the following DLLs were built without any exports. DLLs without exports are likely bugs in the build script. If this is intended, add set(VCPKG_POLICY_DLLS_WITHOUT_EXPORTS enabled)
C:\test\vcpkg\packages\iccdev_x64-windows: note: the DLLs are relative to ${CURRENT_PACKAGES_DIR} here
note: debug/bin/IccProfLib2.dll
note: debug/bin/IccXML2.dll
note: bin/IccProfLib2.dll
note: bin/IccXML2.dll
C:\test\ports\iccdev\portfile.cmake: warning: Found 1 post-build check problem(s). These are usually caused by bugs in portfile.cmake or the upstream build system. Please correct these before submitting this port to the curated registry.
Starting submission of iccdev:x64-windows@2.2.50 to 1 binary cache(s) in the background
Elapsed time to handle iccdev:x64-windows: 24 s
iccdev:x64-windows package ABI: ca20de376f2a9c44464d5573dba6848ad3cdbdfd81448e27bab6d12712a6e180
Total install time: 24 s
Installed contents are licensed to you by owners. Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
Packages installed in this vcpkg installation declare the following licenses:
MIT
Waiting for 1 remaining binary cache submissions...
Completed submission of iccdev:x64-windows@2.2.50 to 1 binary cache(s) in 3.4 s (1/1)
All requested installations completed successfully in: 24 s
```