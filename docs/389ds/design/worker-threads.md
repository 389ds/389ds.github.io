---
title: "Worker Threads dynamic management"
---

# Worker Threads dynamic management - Software Design Specification

--------------------------------------------------------------------

{% include toc.md %}

Introduction
------------

The current worker threads (that process the ldap operations) implementation has several flaws:
    - need to restart the server after changing the configured number of threads
    - contention at the global mutex and condition variable level
    - configuring too few or too many worker threads noticeably impact the performance

## Current implementation synopsys

--------------------

There is a global mutex and a global condition variable and a global queue

- listener threads push data in in the global queue and wake up the worker threads
- worker threads loops waiting on the global condition variable for new work
  then process it.
- to speed up the queueing and limit the alloc/free a stack of list element is used

## New implementation

--------------------

### Stacked data

  In current implementation there are two stacks to handle:
  - the work queue element
  - the operation struct
  and avoid freeing/allocing them every time. 
  I proposed to:
  - keep the operation in the thread context. (Anyway a thread only works on a single operation at a time)
  - keep a free list of element for the waiting_job list. (That cannot be more than the maximum of connections in the queue so in the worse case the free list will 3*8*64K (i.e around 3 Mb) but I wonder if we should not reduce this list size and let the listening threads sleep for a few ms if there are no more items. ( Anyway if the sleep delay is smaller than the time needed to flush the waiting job queue, no time is wasted.)

### Overload warning (flow control)

A warning is logged if
- The warning has not been logged since some delay (1 minute)
- The waiting job queue size gets higher than a threshold (100*number of worker threads)

### Producters/consumers algorithm

There is still a global mutex and also three lists:

- waiting_threads
- busy_threads
- waiting_jobs
  Access to these lists are protected by the global mutex lock

When pushing new job the listener threads:

- Get global mutex
- Loop forever:
  - if waiting_threads is not empty:
    - Select the first waiting thread
    - Move the thread out of waiting_threads list into the busy_threads list
    - Release global mutex
    - Get thread mutex
    - Assign job to the thread
    - Wake up that threads
    - Release Thread mutex
    - Abort the loop
  - else if job_free_list is not empty:
    - Pick an waiting_job list element out of the free list
    - Set the job in the element
    - push the element at the end of waiting_job list
    - Release global mutex
    - Abort the loop
  - else:
    - Release global mutex
    - if current time > last warning time + warning_delay
       - Log a warning about working thread exhausted and waiting queue full
       - set last warning time to current time
    - Sleep 20 ms
    - Get global mutex

The listener threads while waiting on new work:

- Get the thread mutex
- Loop forever:
    - if conn is provided in the thread context
       - Fill the pblock with conn, op
       - Reset conn in thread context
       - Release the thread mutex
       - return CONN_FOUND_WORK_TO_DO
    - if thread shutdown flag is set:
       - Release the thread mutex
       - return CONN_SHUTDOWN
    - Release the thread mutex
    - Get the global mutex
    - If waiting_job queue is empty
       - Unlink thread from busy threads list
       - Link thread at start of waiting threads list
       - Release the global mutex
       - Get the thread mutex
       - Wait on the thread condition variable
       - Loop again
     - Move first job from waiting_job list to the job_free_list list
       (after storing the conn in a local variable)
     - Release the global mutex
     - Fill the pblock with conn, op
     - return CONN_FOUND_WORK_TO_DO

### Dynamic change of the number of threads

When changing the number threads:

- if adding threads:
  - Get global mutex
  - Compute first new thread index:
      (size of working_thread list + size of busy_thread list) +1
  - For each missing threads:
    - Alloc the thread context struct
    - Init its mutex and condition variable
    - Store the thread index in context then increment it
    - Create the thread (as joinable)
    - Store the thread id in the context
  - Release the global mutex
- else if removing threads:
  - create a local empty "closing" list
  - Walk waiting_threads list:
    - if thread index is higher than wanted number of thread
      - Move thread from waiting_threads list to closing list
  - Walk busy_threads list:
    - if thread index is higher than wanted number of thread
      - Move thread from busy_threads list to closing list
  - Release the global mutex
  - Walk closing list:
    - Get thread mutex
    - Set thread closing flags
    - Wake up the thread
    - Release thread mutex
  - Walk closing list:
    - Join the thread
    - Unlink thread from closing list
    - Free thread context

### Monitoring

The following data should be displayed:

| Data                        | Attribute name | Description                                                   |
| --------------------------- | -------------- | ------------------------------------------------------------- |
| waiting_thread size         | waitingthreads | Number of worker threads that are waiting for jobs            |
| busy_thread size            | busythreads    | Number of worker threads that are processing on  jobs         |
| busy_thread high water mark | maxbusythreads | Highest number of worker threads that are processing on  jobs |
| waiting_job size            | waitingjobs    | Size of the waiting job queue                                 |
| waiting_job high water mark | maxwaitingjobs | Highest size of the waiting job queue                         |


### Test

An automatic test can be done with the following steps:

- create an instance
- get the monitoring results
- check that waitingthreads+busythreads == configured number of threads
- run pstack of server and check that number of connection_threadmain is the expected one 
- increase the number of threads
- check that waitingthreads+busythreads == configured number of threads
- run pstack of server and check that number of connection_threadmain is the expected one
- decrease the number of threads
- check that waitingthreads+busythreads == configured number of threads
- run pstack of server and check that number of connection_threadmain is the expected one

### Considered Alternatives

- improving old worker thread algorithm to be able to change the number of threads dynamically. (Rejected because a prototype showed that on my laptop, when using trivial jobs that atommically increment a counter, the proposed algorithm was 6 time faster than the older)
- Adjusting automatically the number of threads to the load. (Rejected because an hard limit is still needed to limit the resource use if an operation blocks the server for some time - and with the new algorithm useless configured threads should not have a noticeable impact (except on the virtual memory footprint)
- while pushing job in waiting_job queue:
  - Do not limit list size (Rejected because of the risk of exhausting 
     the system resources)
  - alloc job list element (while keeping the global lock or use pre-alloced elements as in current code). Rationnal: This queuing occurs when incomming job load is higher that what the working threads can handle, so the priority is to let the worker threads picks new job as fast as possible and we can slow the listening threads.
- Using NSPR thread / mutex / condvar or using pthreads

---------------------------------

## Detailed Design

### Functions

#### List handling (inline functions):

| Prototype                                         | Description                          |
| ------------------------------------------------- | ------------------------------------ |
| void ll_init(llist_t *elmt, void *data)           | initialize a list element            |
| void ll_link_before(llist_t *list, llist_t *elmt) | insert an element before current one |
| void ll_link_after(llist_t *list, llist_t *elmt)  | insert an element after current one  |
| void ll_unlink(llist_t *elmt)                     | remove an element from the list      |

#### connection_wait_for_new_work

connection_wait_for_new_work(Slapi_PBlock *pb, pc_tinfo_t *tinfo)

This function handles part of the "consumer" side of the algorithm
 it read the job from the tinfo "conn" field or from the waiting_job queue or wait until condition variable is waken up. 

#### add_work_q

static void
add_work_q(work_q_item *wqitem, struct Slapi_op_stack *op_stack_obj)

This function handles the "producer" side of the algorithm 

#### init_op_threads

static void init_op_threads()

Initialize the producers/consumers algorithm

#### op_thread_cleanup

void op_thread_cleanup()

Starts the producers/consumers shutdown procedure 

#### connection_post_shutdown_cleanup

void connection_post_shutdown_cleanup()

Free the producers/consumers algorithm resources

#### op_thread_set_threads_number

static void op_thread_set_threads_number(int threadsnumber)

Change the threads number

#### op_thread_get_stat

static void op_thread_get_stat(op_thread_stats_t *st)

Gather the thread statistics

### Data

#### Lists:

All the lists are doubly linked with a guard element as list head.
allowing for fast item addition in head or tail of the queue and fast removal of an item 
Two statistics are associated with the list head: 

- the list size
- the list high water mark (i.e the maximum value of the list size)
  Access to the lists are protected by the global mutex
  ( with the exception to the "closing" list that is handled locally (i.e in a single thread) and is not protected. )

##### List element: ll_list_t

| Field | Usage                                                                                                                 |
| ----- | --------------------------------------------------------------------------------------------------------------------- |
| next  | next item in the list                                                                                                 |
| prev  | previous item in the list                                                                                             |
| data  | the data associated with the item (thread context for list handling threads and the operation for list handling jobs) |

##### List head: ll_head_t

There is one ImportCtx struct per ImportJob and it contains
the global data needed to perform the import over mdb

| Field | Usage                                                      |
| ----- | ---------------------------------------------------------- |
| h     | The guarding element on which are linked the list elements |
| size  | The list size                                              |
| hwm   | The list high water mark                                   |

#### Producers/Consumers data: pc_t

This is a static variable "pc" in connection.c 

| Field           | Usage                    |
| --------------- | ------------------------ |
| mutex           | The global mutex         |
| waiting_threads | The waiting threads list |
| busy_threads    | The busy threads list    |
| waiting_jobs    | The work queue           |
| shutdown        | Shutdown in progress     |

#### Thread context data: tinfo_t

This is the per thread context provided as argument when the thread is created

| Field    | Usage                                                          |
| -------- | -------------------------------------------------------------- |
| q        | the queue element for that thread (data is the thread context) |
| mutex    | The per thread mutex                                           |
| cv       | The per thread cv                                              |
| conn     | The work to process                                            |
| shutdown | The flag telling to stop the thread                            |
| idx      | The thread index (used for smnp and thread removal)            |
| tid      | The thread id (to join the thread for thread removal           |

#### Statistics data: op_thread_stats_t

| Field          | Usage                                                         |
| -------------- | ------------------------------------------------------------- |
| waitingthreads | Number of worker threads that are waiting for jobs            |
| busythreads    | Number of worker threads that are processing on  jobs         |
| maxbusythreads | Highest number of worker threads that are processing on  jobs |
| waitingjobs    | Size of the waiting job queue                                 |
| maxwaitingjobs | Highest size of the waiting job queue                         |
