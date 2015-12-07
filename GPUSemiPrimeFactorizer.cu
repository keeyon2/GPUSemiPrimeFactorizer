#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <cuda.h>
#include <cuda_profiler_api.h>

#define TOTALNUMBERS 100
void startSeq(int number);

int main (int argc, char* argv[]) {
    startSeq(100);
}

__global__ 
void simpleAssign(int* d_solution) {
    d_solution[0] = 69;
}

void startSeq(int number) {

    //Read File
    int *inputPrimes;
    
    dim3 dimGrid(10, 1, 1);
    dim3 dimBlock(10, 1, 1);

    int *d_solution;
    int *solution;

    solution = (int *) malloc(TOTALNUMBERS * sizeof(int));

    for (int i = 0; i < TOTALNUMBERS; i++) {
        solution[i] = 0;
    }

    for (int i = 0; i < TOTALNUMBERS; i++) {
        printf("%d: Before GPU is %d", i, solution[i]);
    }

	//cudaHostAlloc((void**)&solution,sizeof(int),cudaHostAllocDefault);
    //solution[0] = 10;

    //printf("The solution before is %d\n", solution[0]);

    cudaMalloc(&d_solution, sizeof(int) * TOTALNUMBERS);
    simpleAssign<<<dimGrid,dimBlock>>>(d_solution);
    cudaMemcpy(solution, d_solution, sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(d_solution);

    for (int i = 0; i < TOTALNUMBERS; i++) {
        printf("%d: After GPU is %d", i, solution[i]);
    }
}
