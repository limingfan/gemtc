

//int first = 1;
void synchronizeAndPrint(cudaStream_t stream, char *s){
  cudaError_t e = cudaStreamSynchronize(stream);
  if(e!=cudaSuccess){
    //if(first){printf("CUDA Error:   %s   at %s\n", cudaGetErrorString( e ), s);first=0;}
    //first=0;
    printf("GEMTC Error:   %s   at %s\n", cudaGetErrorString( e ), s);
  }
}

int copies=0;
void cudaSafeMemcpy(void *destination, void *source, int size, enum cudaMemcpyKind direction, cudaStream_t stream, char *errorStatement)
{
  copies++;
  //Get Lock
  pthread_mutex_lock(&memcpyLock);

  //Memcpy
  cudaMemcpyAsync(destination, source, size, direction, stream);

  //Synchronize and Print Errors
  synchronizeAndPrint(stream, errorStatement);

  //Release Lock
  pthread_mutex_unlock(&memcpyLock);
}

inline int _ConvertSMVer2Cores(int major, int minor)
{
    // Defines for GPU Architecture types (using the SM version to determine the # of cores per SM
    typedef struct
    {
        int SM; // 0xMm (hexidecimal notation), M = SM Major version, and m = SM minor version
        int Cores;
    } sSMtoCores;

    sSMtoCores nGpuArchCoresPerSM[] =
    {
        { 0x10,  8 }, // Tesla Generation (SM 1.0) G80 class
        { 0x11,  8 }, // Tesla Generation (SM 1.1) G8x class
        { 0x12,  8 }, // Tesla Generation (SM 1.2) G9x class
        { 0x13,  8 }, // Tesla Generation (SM 1.3) GT200 class
        { 0x20, 32 }, // Fermi Generation (SM 2.0) GF100 class
        { 0x21, 48 }, // Fermi Generation (SM 2.1) GF10x class
        { 0x30, 192}, // Kepler Generation (SM 3.0) GK10x class
        { 0x35, 192}, // Kepler Generation (SM 3.5) GK11x class
        {   -1, -1 }
    };

    int index = 0;

    while (nGpuArchCoresPerSM[index].SM != -1)
    {
        if (nGpuArchCoresPerSM[index].SM == ((major << 4) + minor))
        {
            return nGpuArchCoresPerSM[index].Cores;
        }

        index++;
    }

    // If we don't find the values, we default use the previous one to run properly
    printf("MapSMtoCores for SM %d.%d is undefined.  Default to use %d Cores/SM\n", major, minor, nGpuArchCoresPerSM[7].Cores);
    return nGpuArchCoresPerSM[7].Cores;
}

