#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define TOTAL_PRIMES 1000000

void start(unsigned long semiPrime);
void createPrimesArray(unsigned int *array);
__global__ void factorSemiprime(unsigned int* d_primes, unsigned int* d_solution, unsigned long semiPrime);

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
    
    printf("\n**************Starting GPU***************\n"); 
    // Initialize primes
    unsigned int primes[TOTAL_PRIMES];
    for (int i = 0; i < TOTAL_PRIMES; i++) {
        primes[i] = 0;
    }

    createPrimesArray(&primes[0]);

    // Allocate host memory
    unsigned int *solution = (unsigned int*) malloc(sizeof(unsigned int) * 2);

    //unsigned int solution[2];
    for (int i = 0; i < 2; i++) {
        solution[i] = 0;
    }

    unsigned int * d_primes;
    unsigned int * d_solution;

    // calculate grid value
    int gridDimensions = (TOTAL_PRIMES / 16) + 1;

    //int totalBlocks = (TOTAL_PRIMES / 512) + 1;
    //int gridDimensions = sqrt(totalBlocks) + 1;
    //printf("The Grid dimension is %d x %d\n", gridDimensions, gridDimensions);

    dim3 dimGrid(gridDimensions, gridDimensions, 1);
    dim3 dimBlock(16, 16, 1);

    cudaMalloc((void**)&d_primes, TOTAL_PRIMES *sizeof(unsigned int));
    cudaMalloc((void**)&d_solution, 2 * sizeof(unsigned int));

    // Copy primes to GPU
    cudaMemcpy(d_primes, primes, TOTAL_PRIMES * sizeof(unsigned int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_solution, solution, 2 * sizeof(unsigned int), cudaMemcpyHostToDevice);
    
    // Kernel Invocation
    factorSemiprime<<<dimGrid,dimBlock>>>(d_primes, d_solution, semiPrime);

    //transfer C_d from device to host
    cudaMemcpy(solution, d_solution, 2*sizeof(unsigned int), cudaMemcpyDeviceToHost);

    int totalPrimes = TOTAL_PRIMES;
    if (solution[0] == 0 && solution[1] == 0) {
        printf("%lu is not a semiprime with factors less than %d\n\n", semiPrime, totalPrimes); 
    }

    else {
        printf("The prime factors of %lu are %u and %u\n\n", semiPrime, solution[0], solution[1]);
    }

    cudaFree(d_solution);
    cudaFree(d_primes);
    free(solution);
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
void factorSemiprime(unsigned int* d_primes, unsigned int* d_solution, unsigned long semiPrime) {
    int xIndex = blockIdx.x * blockDim.x + threadIdx.x;
    int yIndex = blockIdx.y * blockDim.y + threadIdx.y;

    // Exit on the edge threads that exceed our data
    if (xIndex > TOTAL_PRIMES || yIndex > TOTAL_PRIMES) {
        return;
    }

    unsigned int xValue = d_primes[xIndex];
    unsigned int yValue = d_primes[yIndex];

    unsigned long value = (unsigned long)xValue * (unsigned long)yValue;

    if (value == semiPrime) {
        d_solution[0] = xValue;
        d_solution[1] = yValue;
    }
}
