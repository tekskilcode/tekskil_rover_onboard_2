
if(NOT "/home/tch/mpo_500_workspace/src/libsurvive_ros2/build/libsurvive_ros2/libsurvive-prefix/src/libsurvive-stamp/libsurvive-gitinfo.txt" IS_NEWER_THAN "/home/tch/mpo_500_workspace/src/libsurvive_ros2/build/libsurvive_ros2/libsurvive-prefix/src/libsurvive-stamp/libsurvive-gitclone-lastrun.txt")
  message(STATUS "Avoiding repeated git clone, stamp file is up to date: '/home/tch/mpo_500_workspace/src/libsurvive_ros2/build/libsurvive_ros2/libsurvive-prefix/src/libsurvive-stamp/libsurvive-gitclone-lastrun.txt'")
  return()
endif()

execute_process(
  COMMAND ${CMAKE_COMMAND} -E rm -rf "/home/tch/mpo_500_workspace/src/libsurvive_ros2/build/libsurvive_ros2/libsurvive-prefix/src/libsurvive"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to remove directory: '/home/tch/mpo_500_workspace/src/libsurvive_ros2/build/libsurvive_ros2/libsurvive-prefix/src/libsurvive'")
endif()

# try the clone 3 times in case there is an odd git clone issue
set(error_code 1)
set(number_of_tries 0)
while(error_code AND number_of_tries LESS 3)
  execute_process(
    COMMAND "/usr/bin/git"  clone --no-checkout --config "advice.detachedHead=false" "https://github.com/cntools/libsurvive.git" "libsurvive"
    WORKING_DIRECTORY "/home/tch/mpo_500_workspace/src/libsurvive_ros2/build/libsurvive_ros2/libsurvive-prefix/src"
    RESULT_VARIABLE error_code
    )
  math(EXPR number_of_tries "${number_of_tries} + 1")
endwhile()
if(number_of_tries GREATER 1)
  message(STATUS "Had to git clone more than once:
          ${number_of_tries} times.")
endif()
if(error_code)
  message(FATAL_ERROR "Failed to clone repository: 'https://github.com/cntools/libsurvive.git'")
endif()

execute_process(
  COMMAND "/usr/bin/git"  checkout master --
  WORKING_DIRECTORY "/home/tch/mpo_500_workspace/src/libsurvive_ros2/build/libsurvive_ros2/libsurvive-prefix/src/libsurvive"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to checkout tag: 'master'")
endif()

set(init_submodules TRUE)
if(init_submodules)
  execute_process(
    COMMAND "/usr/bin/git"  submodule update --recursive --init 
    WORKING_DIRECTORY "/home/tch/mpo_500_workspace/src/libsurvive_ros2/build/libsurvive_ros2/libsurvive-prefix/src/libsurvive"
    RESULT_VARIABLE error_code
    )
endif()
if(error_code)
  message(FATAL_ERROR "Failed to update submodules in: '/home/tch/mpo_500_workspace/src/libsurvive_ros2/build/libsurvive_ros2/libsurvive-prefix/src/libsurvive'")
endif()

# Complete success, update the script-last-run stamp file:
#
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy
    "/home/tch/mpo_500_workspace/src/libsurvive_ros2/build/libsurvive_ros2/libsurvive-prefix/src/libsurvive-stamp/libsurvive-gitinfo.txt"
    "/home/tch/mpo_500_workspace/src/libsurvive_ros2/build/libsurvive_ros2/libsurvive-prefix/src/libsurvive-stamp/libsurvive-gitclone-lastrun.txt"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to copy script-last-run stamp file: '/home/tch/mpo_500_workspace/src/libsurvive_ros2/build/libsurvive_ros2/libsurvive-prefix/src/libsurvive-stamp/libsurvive-gitclone-lastrun.txt'")
endif()

