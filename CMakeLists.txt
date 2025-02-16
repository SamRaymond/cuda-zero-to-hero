cmake_minimum_required(VERSION 3.18)
project(HelloCUDA_swig LANGUAGES CUDA CXX)

# Find SWIG
find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

# Find Python development headers
find_package(Python REQUIRED COMPONENTS Development)

# Ensure CUDA standard is set
set(CMAKE_CUDA_STANDARD 14)

# --------------------------------------
# Step 1: Create CUDA Shared Library
# --------------------------------------
add_library(simple_kernel SHARED simple_kernel.cu)
set_target_properties(simple_kernel PROPERTIES CUDA_SEPARABLE_COMPILATION ON)

# --------------------------------------
# Step 2: Generate SWIG Python Module
# --------------------------------------

# Ensure SWIG generates a C++ wrapper file instead of C
set_source_files_properties(simple_kernel.i PROPERTIES CPLUSPLUS ON)

# Set the output directory for the generated SWIG Python module
set(CMAKE_SWIG_OUTDIR "${CMAKE_BINARY_DIR}")

# Add SWIG module for Python
swig_add_library(simple_kernel_py
    TYPE SHARED
    LANGUAGE python
    SOURCES simple_kernel.i
)

# Ensure SWIG does not prepend an extra underscore to the module name
set_target_properties(simple_kernel_py PROPERTIES SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON)

# Ensure the output filename is correct (Python needs simple_kernel_py.so)
set_target_properties(simple_kernel_py PROPERTIES PREFIX "")
set_target_properties(simple_kernel_py PROPERTIES SUFFIX ".so")

# Set the linker language to C++ to prevent "Cannot determine linker language" errors
set_target_properties(simple_kernel_py PROPERTIES LINKER_LANGUAGE CXX)

# Ensure Python headers are included
target_include_directories(simple_kernel_py PRIVATE ${Python_INCLUDE_DIRS})

# Link the SWIG-generated Python module to the CUDA shared library
target_link_libraries(simple_kernel_py PRIVATE simple_kernel)

# --------------------------------------
# Step 3: Add Python Path for Import
# --------------------------------------

# Find Python’s user site-packages directory
execute_process(
    COMMAND python3 -c "import site; print(site.getusersitepackages())"
    OUTPUT_STRIP_TRAILING_WHITESPACE
    OUTPUT_VARIABLE PYTHON_SITE_PACKAGES
)

# Ensure Python can find the module by writing a .pth file
file(APPEND ${PYTHON_SITE_PACKAGES}/cuda_zero_to_hero.pth "${CMAKE_BINARY_DIR}\n")

message(STATUS "Added build directory to Python path: ${CMAKE_BINARY_DIR}")
