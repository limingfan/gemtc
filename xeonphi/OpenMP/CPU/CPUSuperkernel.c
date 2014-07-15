#include "Queue.h"
#include <stdlib.h>
#include "Kernels/addsleep.c"
#include "Kernels/vectoradd.c"
#include "Kernels/matrix_mul.c"
#include "CPUgemtcOpenMP.h"
#include "omp.h"

JobPointer executeJob(JobPointer currentJob);

/*struct Parameter_t{
  Queue incoming;
  Queue results;
  int *kill;
};*/

extern int kill;


void *superKernel(struct Parameter_t *val)
{
   /*struct Parameter_t *params = (struct Parameter_t *) val;
   Queue incoming = params->incoming;
   Queue results =  params->results;
   int *kill =      params->kill;*/
   JobPointer currentJob;
   //This is the function that all worker threads execute
   //while(!(kill))
   #pragma omp critical
   {
      if (!kill)
      {
	    //dequeue a task
	 currentJob = Front(val->incoming);
	 Dequeue(val->incoming);

	    //execute the task
	 JobPointer retval;
	 retval = executeJob(currentJob);

	    //enqueue the result
	 EnqueueJob(retval, val->results);
	 printf("Resultado empilhado\n\n");
      }
   }
   return NULL;
}

JobPointer executeJob(JobPointer currentJob){

  int JobType = currentJob->JobType;

  // large switch
  switch(JobType){
    case 0:
      addsleep(currentJob->params);
      break;
    case 1:
      vectoradd(currentJob->params);
      break;
    case 2:
      matrix_mul(currentJob->params);
      break;
  }
  return currentJob;
}




