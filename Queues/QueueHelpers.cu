#include <stdlib.h>

struct JobDescription{
  int JobID;
  int JobType;
  int numThreads;
  void *params;
};
typedef struct JobDescription *JobPointer; //needed to make these volatile

struct QueueRecord {
  JobPointer* Array; //Order matters here, we should improve this later
  int Capacity;
  int Rear;
  int Front;
  int ReadLock;
};

typedef struct QueueRecord *Queue;


////////////////////////////////////////////////////////////
// Locking Functions used to Sync warps access to Queues
////////////////////////////////////////////////////////////
__device__ void getLock(volatile Queue Q, volatile int *kill)
{
  while(atomicCAS(&(Q->ReadLock), 0, 1) != 0) if(*kill)return;
}

__device__ void releaseLock(volatile Queue Q)
{
  atomicExch(&(Q->ReadLock),0);
}

///////////////////////////////////////////////////////////
// Device Helper Functions
///////////////////////////////////////////////////////////

__device__ int d_IsEmpty(volatile Queue Q) {
  volatile int *rear = &(Q->Rear);
  return (*rear+1)%Q->Capacity == Q->Front;
}

__device__ int d_IsFull(volatile Queue Q) {
  volatile int *front = &(Q->Front);
  return (Q->Rear+2)%Q->Capacity == *front;
}


//////////////////////////////////////////////////////////
// Host Helper Functions
//////////////////////////////////////////////////////////
int h_IsEmpty(Queue Q) {
  return (Q->Rear+1)%Q->Capacity == Q->Front;
}

int h_IsFull(Queue Q) {
  return (Q->Rear+2)%Q->Capacity == Q->Front;
}

void *movePointer(void *p, int n){
   char * ret = (char *) p;
   return ((void *)(ret+n));
}

void printAnyErrors()
{
  cudaError_t e = cudaGetLastError();
  if(e!=cudaSuccess){
    printf("CUDA Error: %s\n", cudaGetErrorString( e ) );
  }
}



