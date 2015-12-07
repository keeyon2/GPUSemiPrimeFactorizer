#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TOTAL_PRIMES 1000000

void start(unsigned long semiPrime);
void createPrimesArray(unsigned long *array);

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
    
    unsigned long primes[TOTAL_PRIMES];
    createPrimesArray(&primes[0]);
    printf("Finished Extracting Primes\n");

    unsigned long iValue; 
    unsigned long jValue;
    unsigned long multipliedValue;
    printf("Starting to calculate\n");
    int stop = 0;
    for (int i = 0; i < TOTAL_PRIMES; i++) {
        for (int j = 1; j < TOTAL_PRIMES; j++) {
            iValue = primes[i];
            jValue = primes[j];
            multipliedValue = iValue * jValue;
            if (multipliedValue == semiPrime) {
                stop = 1;
                break;
            }
        }

        if (stop) {
            break;
        }
    }
    
    // We only stop if we find a solution
    // This being hit indicates the semiprime
    // was successfully factored
    if (stop) {
        printf("We have found the factors of %lu\n", semiPrime);
        printf("The factors are:\n %lu and %lu\n", iValue, jValue);
    }

    else {
        printf("No factors were found to %lu\n", semiPrime);
    }
}

void createPrimesArray(unsigned long *array) {
    FILE *inputFile;
    unsigned long mostRecentNumber;
    inputFile = fopen("primes1.txt", "r");
    for (int i = 0; i < TOTAL_PRIMES; i++) {
        fscanf(inputFile, "%lu", &mostRecentNumber);
        array[i] = mostRecentNumber;
    }
}
