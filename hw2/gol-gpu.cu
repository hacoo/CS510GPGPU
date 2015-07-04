/* Henry Cooney - CS510, Accel. Comp. - 4 July 2015

   Conway's game of life, computed on the GPU.
  
   Uses a tiled convolution pattern to achieve good performance
   (hopefully)
*/


#include "gol.h"

int main() {
  
  test_gol(1, HEIGHT, WIDTH);
  //  fill_board
  //gpu_compute(current, HEIGHT, WIDTH, 1);
  return 0;
}


int* gpu_compute(int* initial, int height, int width, int timesteps) {
  // Does GoL on the GPU. Initial is the starting
  // matrix (it is not modified.) The resulting matrix after timesteps
  // iterations is returned.

  printf("Launching GPU computation for %d timesteps... \n", timesteps);
  int n = width * height;
  int* result = (int*) malloc(sizeof(int) * n);
  int* current_dev,* next_dev;
  int tw = 32; // Tile width -- 32 will mean 1024 threads/block.
  // This is the maximum t/blk for the GTX 645
  //int blockThreads = tw*tw;
  int tester[n];
  int i;
  for(i=0; i < n; ++i)
    tester[i] = 0;
  
  // Memory transfer
  printCudaError(cudaMalloc((void**) &current_dev, sizeof(int)*n));
  printCudaError(cudaMalloc((void**) &next_dev, sizeof(int)*n));
  //  printMatrix(tester, height, width);
  
  cudaThreadSynchronize();
  printCudaError(cudaMemcpy(current_dev, tester, sizeof(int)*n, cudaMemcpyHostToDevice));
  
  // Establish dimms - these are for GTX 645

  dim3 dimBlock(tw, tw, 1);
  dim3 dimGrid(divideRoundUp(width, tw), divideRoundUp(height, tw), 1);

  printf("Matrix size (width x height): %d x %d\n", width, height);
  printf("Block dims (x, y, z): %d x %d x %d\n", dimBlock.x, dimBlock.y, dimBlock.z);
  printf("Grid dims (x, y, z): %d x %d x %d\n", dimGrid.x, dimGrid.y, dimGrid.z);
  
  
  //  conway_kernel<<<dim3(1,1,1), dim3(1,1,1)>>>(current_dev, next_dev);
   
  
  return NULL;
}


__global__ 
void conway_kernel(int* current_dev, int* next_dev) {

  return;
}

void printCudaError(cudaError_t err) {
  // Checks the value of input error. If it does not
  // indicate success, prints an error message.
  
  if(err != cudaSuccess) {
    printf("**** CUDA ERROR: ****\n");
    printf("%s in %s at line %d \n", cudaGetErrorString(err), __FILE__, __LINE__);
    exit(EXIT_FAILURE);
  }
  
}


int divideRoundUp(int a, int b) {
  // Divides a by b, but rounds the result up instead of down.
  return (a+(b-1)) / b;
}