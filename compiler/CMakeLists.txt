set(TARGET_NAME ${COMPILER_NAME})

file(GLOB SRC_FILES *.cc)
file(GLOB HEADER_FILES *.hh)

include_directories(${PROJECT_SOURCE_DIR}/deps/stb)

set(CMAKE_CXX_STANDARD 17)

add_compile_options(-O3)

add_compile_definitions(COMPILER_VERSION="${COMPILER_VERSION}")
add_compile_definitions(COMPILER_NAME="${COMPILER_NAME}")

add_executable(${TARGET_NAME} ${SRC_FILES} ${HEADER_FILES})