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
    
    printf("\n**************Starting Sequential***************\n"); 
    unsigned long primes[TOTAL_PRIMES];
    createPrimesArray(&primes[0]);

    unsigned long iValue; 
    unsigned long jValue;
    unsigned long multipliedValue;
    int stop = 0;
    int i;
    int j;
    for (i = 0; i < TOTAL_PRIMES; i++) {
        for (j = 0; j < TOTAL_PRIMES; j++) {
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
        printf("The prime factors of %lu are %lu and %lu\n\n", semiPrime, 
                iValue, jValue);
    }
    else {
        int totalPrimes = TOTAL_PRIMES;
        printf("%lu is not a semiprime with factors less than %d\n\n", semiPrime, totalPrimes); 
    }
}

void createPrimesArray(unsigned long *array) {
    FILE *inputFile;
    unsigned long mostRecentNumber;
    inputFile = fopen("primes1.txt", "r");
    int i;
    for (i = 0; i < TOTAL_PRIMES; i++) {
        fscanf(inputFile, "%lu", &mostRecentNumber);
        array[i] = mostRecentNumber;
    }
}
