cmake_minimum_required(VERSION 3.15)
project(inference-proto LANGUAGES CXX)

find_package(Protobuf REQUIRED)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

function(buildInferenceProto PROTOBUF_DEFINITION_FILES)
   set(PROTOBUF_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
   foreach(file ${PROTOBUF_DEFINITION_FILES})
      get_filename_component(FILE_WE ${file} NAME_WE)
      get_filename_component(OUT_PATH ${file} DIRECTORY)
      string(REGEX REPLACE ".+/(.+)\\..*" "\\1" FILE_NAME ${file})
      string(REGEX REPLACE "(.+)\\${FILE_NAME}.*" "\\1" FILE_PATH ${file})
      set(ProtoSrc "${CMAKE_CURRENT_BINARY_DIR}/${OUT_PATH}/${FILE_WE}.pb.cc")
      set(ProtoHdr "${CMAKE_CURRENT_BINARY_DIR}/${OUT_PATH}/${FILE_WE}.pb.h")
      execute_process(
              COMMAND ${PROTOBUF_PROTOC_EXECUTABLE} -I proto/ --cpp_out=${PROTOBUF_OUTPUT_DIRECTORY} ${file}
              WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
              RESULT_VARIABLE PROTOBUF_RESULT
              OUTPUT_VARIABLE PROTOBUF_OUTPUT_VARIABLE)
      list(APPEND ProtoSources ${ProtoSrc})
      list(APPEND ProtoHeaders ${ProtoHdr})
   endforeach()
   set(ProtoSources ${ProtoSources} PARENT_SCOPE)
   set(ProtoHeaders ${ProtoHeaders} PARENT_SCOPE)
endfunction()

buildInferenceProto("pipeline/audio-filters.proto")
buildInferenceProto("pipeline/video-filters.proto")
buildInferenceProto("pipeline/pipeline.proto")
buildInferenceProto("providers/providers.proto")

set_source_files_properties(${ProtoSources} ${ProtoHeaders} PROPERTIES GENERATED TRUE)

add_library(${PROJECT_NAME} ${ProtoSources} ${ProtoHeaders})
target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_BINARY_DIR} ${PROTOBUF_INCLUDE_DIR})
target_link_libraries(${PROJECT_NAME} PUBLIC ${PROTOBUF_LIBRARY})