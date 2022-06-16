#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb/stb_image_write.h"

#include <time.h>

void PROCESS_ASM(unsigned char* data, const int size, unsigned char* outputData);

char maxRGB(const int index, unsigned char* data)
{
    if((data[index] > data[index+1]) && (data[index] > data[index + 2])){
        return data[index];
    }
    else if(data[index+1] > data[index+2]){
        return data[index+1];
    }
    else
        return data[index+2];
}

void imgProcessing(unsigned char* data, const int size, unsigned char* outputData)
{
    for(int i = 0; i < size*3; i += 3){
        outputData[i/3] = maxRGB(i, data);
        int time = 0;
    }
}

int main() {
    clock_t t1;
    int inputData[3] = {0, 0, 0};
    unsigned char* data = stbi_load("cat2.png", inputData, inputData+1, inputData+2, 3);
    int size = inputData[0]*inputData[1];
    unsigned char* outputData = malloc(size*sizeof(char));
    unsigned char* outputData2 = malloc(size*sizeof(char));
    t1 = clock();
    imgProcessing(data, size, outputData);
    printf("Time in C: %lf\n",(((double)clock())-t1) / CLOCKS_PER_SEC);
    t1 = clock();
    PROCESS_ASM(data, size, outputData2);
    printf("Time in ASM: %lf\n",(((double)clock())-t1) / CLOCKS_PER_SEC);
    stbi_write_png("result.png", inputData[0], inputData[1], 1, outputData, 0);
    stbi_write_png("result2.png", inputData[0], inputData[1], 1, outputData2, 0);
    return 0;
}



