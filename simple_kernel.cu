#include <iostream>
#include <cuda_runtime.h>  // Includes CUDA runtime API

// ==============================
// CUDA Kernel Function (Runs on GPU)
// ==============================
/*
    This function runs on the **GPU** (device).
    - __global__ means it's a CUDA kernel and must be launched from the host.
    - It executes in parallel across multiple threads.
    - Each thread has a unique **threadIdx.x**.
*/
__global__ void hello_cuda(int a) {
    int idx = threadIdx.x;  // Get unique thread index within the block

    // Safety check: Limit the number of prints
    if (a > 1000000) a = 1000000;  // Prevent excessive printing

    // Each thread executes this loop independently
    for (int i = 0; i < a; i++) {
        printf("Hello from CUDA thread %d, iteration %d\n", idx, i);
    }
}

// ==============================
// Host Function (Runs on CPU, Launches GPU Kernel)
// ==============================
/*
    This function is callable from Python via SWIG.
    It launches the CUDA kernel on the GPU and synchronizes with the CPU.
*/
extern "C" __host__ void launch_hello_cuda(int a) {
    // Input validation on CPU side
    if (a <= 0) {
        std::cerr << "Error: 'a' must be positive." << std::endl;
        return;
    }

    std::cout << "Launching CUDA kernel from host..." << std::endl;

    // Launch CUDA kernel with 1 block of 10 threads
    hello_cuda<<<1, 10>>>(a);

    // Synchronize CPU and GPU; wait for kernel to complete
    cudaError_t err = cudaDeviceSynchronize();

    // Error handling: Check for CUDA errors
    if (err != cudaSuccess) {
        std::cerr << "CUDA Error: " << cudaGetErrorString(err) << std::endl;
    }
}
