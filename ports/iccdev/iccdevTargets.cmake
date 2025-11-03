include(CMakeFindDependencyMacro)

# Define a simple imported target for iccdev library
if(NOT TARGET iccdev::iccdev)
    add_library(iccdev::iccdev INTERFACE IMPORTED)
    set_target_properties(iccdev::iccdev PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${PACKAGE_PREFIX_DIR}/include"
        INTERFACE_LINK_LIBRARIES "jpeg;png;tiff;xml2;nlohmann_json"
    )
endif()

# Provide optional tool targets (installed under tools/iccdev)
set(ICCDEV_TOOL_DIR "${PACKAGE_PREFIX_DIR}/tools/iccdev")
set(ICCDEV_TOOLS
    iccApplyNamedCmm iccApplyToLink iccDumpProfile iccFromCube
    iccFromXml iccJpegDump iccRoundTrip iccToXml iccV5DspObsToV4Dsp
)
foreach(tool ${ICCDEV_TOOLS})
    if(EXISTS "${ICCDEV_TOOL_DIR}/${tool}${CMAKE_EXECUTABLE_SUFFIX}")
        add_executable(iccdev::${tool} IMPORTED)
        set_target_properties(iccdev::${tool} PROPERTIES
            IMPORTED_LOCATION "${ICCDEV_TOOL_DIR}/${tool}${CMAKE_EXECUTABLE_SUFFIX}"
        )
    endif()
endforeach()
