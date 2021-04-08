if(APPLE)
  if(NOT CMAKE_OSX_ARCHITECTURES)
    set(CMAKE_OSX_ARCHITECTURES "x86_64" CACHE STRING "By default, build for 64-bit")
  endif()

  if(NOT CMAKE_OSX_SDK)
    execute_process(
      COMMAND xcrun
              --show-sdk-version
      OUTPUT_VARIABLE
              SDK_VERSION
      RESULT_VARIABLE
              res
      ERROR_QUIET
      OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(res)
      # Probably running on an older version of XCode, instead try to list all available
      # SDKs and extract the version of the first one.
      execute_process(
        COMMAND xcodebuild
                -showsdks
        OUTPUT_VARIABLE
                xcodebuild_sdks
        RESULT_VARIABLE
                res
        OUTPUT_STRIP_TRAILING_WHITESPACE)
      string(REGEX MATCH "sdk macosx([0-9\\. ]+)" output "${xcodebuild_sdks}")
      if(res OR output STREQUAL "")
        message(FATAL_ERROR "Failed to detect CMAKE_OSX_SDK; please set manually (e.g. \"macosx10.6\")")
      endif()
      set(SDK_VERSION ${CMAKE_MATCH_1})
    endif()
    set(CMAKE_OSX_SDK macosx${SDK_VERSION})
  endif()

  if(NOT CMAKE_OSX_SYSROOT)
  endif()
  if(NOT CMAKE_OSX_DEPLOYMENT_TARGET)
  endif()
endif()
