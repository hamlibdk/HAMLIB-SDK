Supply of CMAKE is now optional as it is delivered with Qt

Download from https://cmake.org/download/

Note that C:\JTSDK64-Tools\tools\cmake\4.x.x\share\cmake-4.1\Modules\undleUtilities.cmake needs an adjustment:

File: BundleUtilities.cmake

....
function(copy_resolved_item_into_bundle resolved_item resolved_embedded_item)

  if(WIN32)
    # ignore case on Windows
    string(TOLOWER "${resolved_item}" resolved_item_compare)
    string(TOLOWER "${resolved_embedded_item}" resolved_embedded_item_compare)
  else()
    set(resolved_item_compare "${resolved_item}")
    set(resolved_embedded_item_compare "${resolved_embedded_item}")
  endif()

# ORIGINAL CODE COMMENTED OUT

#  if(resolved_item_compare STREQUAL resolved_embedded_item_compare)
#    message(STATUS "warning: resolved_item == resolved_embedded_item - not copying...")
#  else()
#    #message(STATUS "copying COMMAND ${CMAKE_COMMAND} -E copy ${resolved_item} ${resolved_embedded_item}")
#    execute_process(COMMAND ${CMAKE_COMMAND} -E copy "${resolved_item}" "${resolved_embedded_item}")
#    if(UNIX AND NOT APPLE)
#      file(RPATH_REMOVE FILE "${resolved_embedded_item}")
#    endif()
# endif()
	
  # From Uwe DG2YCB's suggestions - See: https://groups.io/g/JTSDK/message/3162
  # Sources now Qt version agnostic Steve I VK3VM 2025-05-24
  if(resolved_item_compare STREQUAL resolved_embedded_item_compare)
    message(STATUS "warning: resolved_item == resolved_embedded_item - not copying...")
  elseif(${resolved_item} MATCHES "libhamlib-4.dll")
    # message(STATUS "copying COMMAND ${CMAKE_COMMAND} -E copy ${resolved_item} ${resolved_embedded_item}")
    # execute_process(COMMAND ${CMAKE_COMMAND} -E copy "C:/JTSDK64-Tools/tools/hamlib/qt/5.15.2/bin/libhamlib-4.dll" "${resolved_embedded_item}")
    execute_process(COMMAND ${CMAKE_COMMAND} -E copy "$ENV{JTSDK_TOOLS}/hamlib/bin/libhamlib-4.dll" "${resolved_embedded_item}")
  elseif(${resolved_item} MATCHES "libusb-1.0.dll")
    # message(STATUS "copying COMMAND ${CMAKE_COMMAND} -E copy ${resolved_item} ${resolved_embedded_item}")
    # execute_process(COMMAND ${CMAKE_COMMAND} -E copy "C:/JTSDK64-Tools/tools/hamlib/qt/5.15.2/bin/libusb-1.0.dll" "${resolved_embedded_item}")
    execute_process(COMMAND ${CMAKE_COMMAND} -E copy "$ENV{JTSDK_TOOLS}/hamlib/bin/libusb-1.0.dll" "${resolved_embedded_item}")
#  elseif(${resolved_item} MATCHES "libgcc_s_sjlj-1.dll")
    # message(STATUS "copying COMMAND ${CMAKE_COMMAND} -E copy ${resolved_item} ${resolved_embedded_item}")
    # execute_process(COMMAND ${CMAKE_COMMAND} -E copy "C:/JTSDK64-Tools/tools/hamlib/qt/5.15.2/bin/libgcc_s_sjlj-1.dll" "${resolved_embedded_item}")
#    execute_process(COMMAND ${CMAKE_COMMAND} -E copy "$ENV{JTSDK_TOOLS}/hamlib/bin/libgcc_s_sjlj-1.dll "${resolved_embedded_item}")
  elseif(${resolved_item} MATCHES "libgcc_s_seh-1.dll")
    # message(STATUS "copying COMMAND ${CMAKE_COMMAND} -E copy ${resolved_item} ${resolved_embedded_item}")
    # execute_process(COMMAND ${CMAKE_COMMAND} -E copy "C:/JTSDK64-Tools/tools/hamlib/qt/5.15.2/bin/libgcc_s_seh-1.dll" "${resolved_embedded_item}")
    execute_process(COMMAND ${CMAKE_COMMAND} -E copy "$ENV{JTSDK_TOOLS}/hamlib/bin/libgcc_s_seh-1.dll" "${resolved_embedded_item}")
  elseif(${resolved_item} MATCHES "libwinpthread-1.dll")
    # message(STATUS "copying COMMAND ${CMAKE_COMMAND} -E copy ${resolved_item} ${resolved_embedded_item}")
    # execute_process(COMMAND ${CMAKE_COMMAND} -E copy "C:/JTSDK64-Tools/tools/hamlib/qt/5.15.2/bin/libwinpthread-1.dll" "${resolved_embedded_item}")
    execute_process(COMMAND ${CMAKE_COMMAND} -E copy "$ENV{JTSDK_TOOLS}/hamlib/bin/libwinpthread-1.dll" "${resolved_embedded_item}")
  else()
    #message(STATUS "copying COMMAND ${CMAKE_COMMAND} -E copy ${resolved_item} ${resolved_embedded_item}")
    execute_process(COMMAND ${CMAKE_COMMAND} -E copy "${resolved_item}" "${resolved_embedded_item}")
    if(UNIX AND NOT APPLE)
      file(RPATH_REMOVE FILE "${resolved_embedded_item}")
    endif()
  endif()

endfunction()