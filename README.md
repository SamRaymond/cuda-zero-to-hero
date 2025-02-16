# CUDA Zero-to-Hero: Python Integration with CUDA via SWIG and CMake

This project demonstrates how to build a simple CUDA example that integrates with Python using SWIG and CMake. The main goal is to launch a CUDA kernel from Python via a host wrapper function.

## Project Structure

cuda-zero-to-hero/
├── CMakeLists.txt           # CMake build script to configure CUDA, SWIG, and Python integration.
├── simple_kernel.cu         # CUDA source file:
│                            - Contains a __global__ kernel (hello_cuda) and a host wrapper (launch_hello_cuda).
├── simple_kernel.i          # SWIG interface file:
│                            - Exposes the host wrapper function to Python.
├── test_simple.py           # Python test script to call the CUDA kernel through SWIG.
└── README.md                # This file.

## Prerequisites

Before building the project, ensure you have:

- CUDA Toolkit (compatible with your GPU, e.g., NVIDIA CUDA 12.0)
- SWIG 4.x (for generating Python wrappers)
- CMake 3.18+
- A C++ compiler (e.g., GNU g++ 13.x)
- Python 3.12 (with development headers)

### Tip: On Ubuntu, you might install prerequisites via:
    sudo apt-get update
    sudo apt-get install build-essential cmake swig python3-dev

## Building the Project

1. Clone the Repository:

    git clone <repository_url>
    cd cuda-zero-to-hero

2. Create and Enter the Build Directory:

    mkdir build && cd build

3. Configure the Project with CMake:

    cmake ..

    CMake will detect CUDA, SWIG, and Python; it will also write a .pth file into your Python user site-packages directory so that Python can find the generated module.

4. Build the Project:

    make -j$(nproc)

    This step compiles:
    - The CUDA source file (simple_kernel.cu) with nvcc.
    - The SWIG-generated C++ wrapper file.
    - The SWIG Python module (simple_kernel_py.so).

## Running the Project

After a successful build, you can run the Python test script:

    python3 ../test_simple.py

    The expected behavior is that the Python script imports the module and calls the function launch_hello_cuda(42), which:
    - Prints a host message.
    - Launches the CUDA kernel on the GPU.
    - The kernel prints messages from each thread.

## Explanation of the Code

- simple_kernel.cu:
    - hello_cuda: A CUDA kernel function (marked with __global__) that runs on the GPU. Each thread prints a message.
    - launch_hello_cuda: A host wrapper function (declared with extern "C" and __host__) that launches the CUDA kernel and synchronizes the device. This function is exposed to Python.

- simple_kernel.i:
    - The SWIG interface file that exposes launch_hello_cuda to Python. It uses a %module directive to name the module and provides an extern "C" declaration for the host function.

- CMakeLists.txt:
    - Configures the build system for compiling the CUDA code, running SWIG to generate Python bindings, and linking everything together.
    - Automatically writes a .pth file to include the build directory in Python’s module search path.

- test_simple.py:
    - A simple Python script that imports the generated module and calls the exposed function to run the CUDA kernel.

## How to Extend

This example lays the groundwork for many advanced projects. Here are a few ideas to take it further:

- Complex CUDA Kernels:
    Extend the CUDA code with more complex kernels (e.g., matrix multiplication, vector addition) and expose them to Python.

- Error Handling & Optimization:
    Improve error handling and performance. Use shared memory, streams, and events for advanced CUDA optimization.

- Object-Oriented Design:
    Create C++ classes that encapsulate CUDA functionality and expose them to Python. This can help build higher-level APIs.

- Integrate with NumPy:
    Convert between NumPy arrays and device memory, enabling fast data processing on the GPU from Python.

- Build a Python Package:
    Use SWIG and CMake to create a full-featured Python package. Add tests, documentation, and packaging tools (like setuptools).

## Further Reading

- NVIDIA CUDA Toolkit Documentation: https://docs.nvidia.com/cuda/
- SWIG Documentation: https://www.swig.org/
- CMake Documentation: https://cmake.org/cmake/help/latest/
- Python C Extensions: https://docs.python.org/3/extending/extending.html

## License

This project is released under the MIT License.

Happy coding! 🚀
