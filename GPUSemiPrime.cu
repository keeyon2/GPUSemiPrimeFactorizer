#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define TOTAL_PRIMES 1000000

void start(unsigned long semiPrime);
void createPrimesArray(unsigned int *array);

int main ( int argc, char *argv[] ) {
    // Read in file
    if (argc < 2) {
        printf("Sorry, we need a command line argument\n"); 
        printf("Run again with Semiprime you would like to factor\n");
        exit(0);
    }

    else {
        char* semiPrime = argv[1];
        char* ptr;
        unsigned long longSemiPrime;
        longSemiPrime = strtoul(semiPrime, &ptr, 10);
        start(longSemiPrime); 
    }
}

void start(unsigned long semiPrime) {
    //unsigned long *primes;
    //primes = malloc(sizeof(unsigned long) * TOTAL_PRIMES);
    
    unsigned int primes[TOTAL_PRIMES];
    createPrimesArray(&primes[0]);
    printf("Finished Extracting Primes\n");

    unsigned int * d_primes;
    unsigned int * d_solution;

    // calculate grid value
    int totalBlocks = (TOTAL_PRIMES / 512) + 1;
    int gridDimensions = sqrt(totalBlocks) + 1;

    dim3 dimGrid(gridDimensions, gridDimensions, 1);
    dim3 dimBlock(16, 16, 1);

    // Allocate host memory
    unsigned int solution[2];
    for (int i = 0; i < 2; i++) {
        solution[i] = 0;
    }

    cudaMalloc(&d_primes, TOTAL_PRIMES *sizeof(unsigned int));
    cudaMalloc(&d_solution, 2*sizeof(unsigned int));
    
    // Kernel Invocation
    vecAddKernel<<<dimGrid,dimBlock>>>(device);

    //transfer C_d from device to host
    cudaMemcpy(solution, d_solution, 2*sizeof(unsigned int), cudaMemcpyDeviceToHost);
  
    cudaFree(d_solution);
    cudaFree(d_primes);

    int totalPrimes = TOTAL_PRIMES;
    if (solution[0] == 0 && solution[1] == 0) {
        printf("%lu is not a semiprime with factors less than %d\n", semiPrime, totalPrimes); 
    }

    else {
        printf("The factors of %lu are %u and %u\n", semiPrime, solution[0], solution[1]);
    }
}

void createPrimesArray(unsigned int *array) {
    FILE *inputFile;
    unsigned int mostRecentNumber;
    inputFile = fopen("primes1.txt", "r");
    for (int i = 0; i < TOTAL_PRIMES; i++) {
        fscanf(inputFile, "%u", &mostRecentNumber);
        array[i] = mostRecentNumber;
    }
}

__global__ 
void simpleAssign(int* d_array,int* d_solution, unsigned long semiPrime) {
    d_solution[0] = 69;
    int xIndex = blockIdx.x * blockDim.x + threadIdx.x;
    int yIndex = blockIdx.y * blockDim.y + threadIdx.y
    unsigned int xValue = d_primes[xIndex];
    unsigned int yValue = d_primes[yIndex];

    unsigned long value = (unsigned long)xValue * (unsigned long)yValue;

    if (value == semiPrime) {
        d_solution[0] = xValue;
        d_solution[1] = yValue;
    }
}
