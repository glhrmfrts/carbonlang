set(TARGET_NAME carbonc)

file(GLOB SRC_FILES *.cc)
file(GLOB HEADER_FILES *.hh)

include_directories(${PROJECT_SOURCE_DIR}/deps/stb)

set(CMAKE_CXX_STANDARD 17)

add_compile_options(-g)

add_executable(${TARGET_NAME} ${SRC_FILES} ${HEADER_FILES})