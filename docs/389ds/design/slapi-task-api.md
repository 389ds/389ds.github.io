---
title: "Slapi Task API Design"
---

# Slapi Task API Design
-----------------------

{% include toc.md %}

Overview
========

The Fedora Directory Server has a concept of tasks that is exposed via the SLAPI plug-in interface. A task allows a handler function in your plug-in to be called when a particular type of entry is added to the Directory Server under the "cn=tasks" suffix. Tasks are typically used to perform some sort of server maintenance operation such as re-indexing or exporting your database to LDIF. When you create a task entry, the server calls the handler function registered to handle that type of task. The handler function performs the actual work of the task, then updates the task entry with the status or result of running the task. The server will then clean up the task entry after a specified amount of time.

The task interface can be very useful, but the actual API that is exposed is incomplete. Private header files from the server often have to be included, and a number of structures need to be modified manually. These structures should be opaque and modified via functions that are exposed via slapi-plugin.h. This should result in it being much easier for developers to implement plug-ins that implement custom tasks.

Current Task API
================

Structures
----------

### Slapi\_Task

An opaque structure that represents a task that has been initiated. Unfortunately, to write a plug-in that implements a task requires knowledge of the underlying structure due to insufficient task API.

### \_slapi\_task

A private structure that represents a task that has been initiated. The structure currently looks like this:

    struct _slapi_task {    
       struct _slapi_task *next;    
       char *task_dn;    
       int task_exitcode;          /* for the end user */    
       int task_state;             /* (see above) */    
       int task_progress;          /* number between 0 and task_work */    
       int task_work;              /* "units" of work to be done */    
       int task_flags;             /* (see above) */    
       /* it is the task's responsibility to allocate this memory & free it: */    
       char *task_status;          /* transient status info */    
       char *task_log;             /* appended warnings, etc */    
       void *task_private;         /* for use by backends */    
       TaskCallbackFn cancel;      /* task has been canceled by user */    
       TaskCallbackFn destructor;  /* task entry is being destroyed */    
       int task_refcount;    
    };    

Callback Typedefs
-----------------

### dseCallbackFn

    typedef int (*dseCallbackFn)(Slapi_PBlock *, Slapi_Entry *, Slapi_Entry *,    
                                int *, char*, void *);    

According to the source code, a DSE callback function must return one of the following values, although only the first two are appropriate for a task callback:

    SLAPI_DSE_CALLBACK_OK    
    SLAPI_DSE_CALLBACK_ERROR    
    SLAPI_DSE_CALLBACK_DO_NOT_APPLY    

The problem with the current API is that these return value macros are not publicly defined even though the callback typedef is.

### TaskCallbackFn

    typedef int (*TaskCallbackFn)(Slapi_Task *task);    

This typedef is used by custom task destructor and cancel functions. The source code suggests that a return value of 0 should be used to signal success, although the only current task destructor and cancel functions always return 0 and the return value is never checked.

Functions
---------

### slapi\_task\_register\_handler

    int slapi_task_register_handler(const char *name, dseCallbackFn func)    

Registers your task handler function.

### slapi\_new\_task

    Slapi_Task *slapi_new_task(const char *dn)    

Allocates a new Slapi\_Task.

### slapi\_destroy\_task

    void slapi_destroy_task(void *arg)    

Frees a Slapi\_Task when you're finished with it.

### slapi\_task\_log\_status

    void slapi_task_log_status(Slapi_Task *task, char *format, ...)    

This changes the 'nsTaskStatus' value, which is transient (anything logged here wipes out any previous status).

### slapi\_task\_log\_notice

    void slapi_task_log_notice(Slapi_Task *task, char *format, ...)    

This adds a line to the 'nsTaskLog' value, which is cumulative (anything logged here is added to the end).

### slapi\_task\_status\_changed

    void slapi_task_status_changed(Slapi_Task *task)    

Update task entry with status information. This is used by slapi\_task\_log\_status() and slapi\_task\_log\_notice(). It also has to be used after manually updating the progress and status in the task structure.

Usage
-----

The basic usage of the current task API in a plug-in is as follows:

-   In plug-in initialization
    -   register a handler function to respond to newly created tasks (slapi\_task\_register\_handler())

-   In handler function:
    -   Create task entry (slapi\_new\_task())
    -   Create your own data structure which has a pointer to the actual Slapi\_Task plus any other data specific to your task
    -   Initialize Slapi\_Task members, such as progress, total work, and state (manual right now, need API)
    -   Create a thread to do the task work, passing it your data structure
    -   destroy the task when complete (slapi\_destroy\_task())

-   In worker thread:
    -   change task state to running (manual right now, need API)
    -   update end user viewable status (slapi\_task\_status\_changed())
    -   log messages to update status (slapi\_task\_log\_notice())
    -   update progress in Slapi\_Task (manual right now, need API)
    -   change Slapi\_Task state to finished (manual right now, need API)
    -   update end user viewable status (slapi\_task\_status\_changed())

One thing that seems odd in the current usage of the Slapi\_Task API is the way the task is destroyed. The existing tasks implemented in the server are all explicitly destroyed at the end of their handler function by calling slapi\_destroy\_task(). This explicit destruction of the task seems unnecessary though. When the state of a task is set to finished (SLAPI\_TASK\_FINISHED) followed by a call to slapi\_task\_changed\_status(), the destruction of the task will be put in the event queue. Since the destruction event is queued, there should be no need to call the same destructor function explicitly.

Proposed Task API
=================

Aside from the exceptions listed below, the existing API will be left as is. Most of the necessary changes are adding new functions to the API to augment the existing functions.

There are some members of the private structure that are only to be used internally by the server, such as task\_flags. These will not be exposed via the new API.

Structures
----------

### Slapi\_Task

An opaque structure that represents a task that has been initiated. No knowledge of the underlying private structure is necessary to implement a task plug-in.

Callback Typedefs
-----------------

The existing callback typedefs can be used, but the return value macros for dseCallbackFn functions needs to be made public. We may also want to either make the return type of TaskCallbackFn functions void since we don't do anything with the return values, unless we want to do something in the event of an error such as logging a message to the errors log.

Removed Functions
-----------------

### slapi\_task\_state\_changed

This function will be made private. The new API functions that actually modify the task state will end up calling this function internally, but there is no need to expose it to the user.

### slapi\_task\_destroy

The destruction of a task is taken care of by the server when you put the task in the finished state. There is no need to explicitly call the destructor, hence this function can be removed.

New Functions
-------------

### slapi\_task\_begin

    void slapi_task_begin(Slapi_Task *task, int total_work)    

Called when you begin processing a task. This will update the task entry state to say that the task is running. This is currently done like this:

    task->task_work = 1;    
    task->task_progress = 0;    
    task->task_state = SLAPI_TASK_RUNNING;    
    slapi_task_status_changed(task);    

The total\_work parameter is used to calculate task progress that can be reported to the user.

### slapi\_task\_finish

    void slapi_task_finish(Slapi_Task *task, int rc)    

Called when you are finished processing a task. This will update the task entry state to say that the task is finished as well as providing the result code to the user. This is currently done like this:

    task->task_exitcode = rc;    
    task->task_state = SLAPI_TASK_FINISHED;    
    slapi_task_status_changed(task);    

### slapi\_task\_cancel

    void slapi_task_cancel(Slapi_Task *task, int rc)    

Called to cancel a task. This will update the task entry state to say that the task is canceled as well as providing the result code to the user. This is currently done like this:

    task->task_exitcode = rc;    
    task->task_state = SLAPI_TASK_CANCELLED;    
    slapi_task_status_changed(task);    

### slapi\_task\_inc\_progress

    void slapi_task_inc_progress(Slapi_Task *task)    

Increment the task progress. This will update the task entry. This allows partial progress to be reported to the user. This previously had to be done manually like this:

    task->task_progress++    
    slapi_task_status_changed(task);    

### slapi\_task\_inc\_refcount

    void slapi_task_inc_refcount(Slapi_Task *task)    

Increment the task reference count. This is used by tasks that spawn multiple threads.

### slapi\_task\_dec\_refcount

    void slapi_task_dec_refcount(Slapi_Task *task)    

Decrement the task reference count. This is used by tasks that spawn multiple threads.

### slapi\_task\_get\_refcount

    int slapi_task_get_refcount(Slapi_Task *task)    

Check the current reference count of the task. This is used by tasks that spawn multiple threads to see if all threads are finished.

### slapi\_task\_get\_state

    int slapi_task_get_state(Slapi_Task *task)    

Check the current state of a task. This is currently accessed directly from the structure like this:

    if (task->task_state == SLAPI_TASK_FINISHED)    

Valid states are:

    SLAPI_TASK_SETUP    
    SLAPI_TASK_RUNNING    
    SLAPI_TASK_FINISHED    
    SLAPI_TASK_CANCELLED    

### slapi\_task\_set\_data

    void slapi_task_set_data(Slapi_Task *task, void *data)    

Allows you to stuff an opaque data object pointer into your task. This is handy for stashing some data specific to your task in your handler function that can then be used by a thread that performs the actual task work. The caller is responsible for allocating and freeing whatever you stash in the task.

### slapi\_task\_get\_data

    void * slapi_task_get_data(Slapi_Task *task)    

Retrieves opaque data pointer from your task. You are responsible for freeing this memory when you are finished with it. A good way of dealing with this is to specify your own destructor callback function after creating your task.

### slapi\_task\_set\_destructor\_fn

    void slapi_task_set_destructor_fn(Slapi_Task *task, TaskCallbackFn func)    

Sets a callback to be used when a task is destroyed. The destruction of the task itself is taken care of automatically, but a callback may be used for cleaning up anything that you may have passed into the task by calling slapi\_task\_set\_data().

### slapi\_task\_set\_cancel\_fn

    void slapi_task_set_cancel_fn(Slapi_Task *task, TaskCallbackFn func)    

Sets a callback to be used when a task is canceled. The destruction of the task itself is taken care of automatically, but a callback may be used for doing anything that is specific to canceling a task. If you set a custom destructor function, it will be called after your cancel function.

Usage
-----

The basic usage of the proposed task API in a plug-in is as follows:

-   In plug-in initialization
    -   register a handler function to respond to newly created tasks (slapi\_task\_register\_handler())

-   In handler function:
    -   Create task entry (slapi\_new\_task())
    -   Register a custom destructor function if necessary (slapi\_task\_set\_destructor())
    -   Create your own data structure which has any other data specific to your task and stash a pointer to it in your task entry if necessary (slapi\_task\_set\_data())
    -   Create a thread to do the task work, passing it your task (using a thread is optional, but ideal)

-   In worker thread:
    -   Fetch data specific to your task if necessary (slapi\_task\_get\_data())
    -   Initialize task progress and work and update task state to indicate that the task is running (slapi\_task\_begin())
    -   Log user visible messages if necessary (slapi\_task\_log\_notice())
    -   Update user visible status if necessary (slapi\_task\_log\_status())
    -   Increment task progress if necessary (slapi\_task\_inc\_progress())
    -   Set task state to finished, which will queue the destruction of the task (slapi\_task\_finish())

To Do
=====

-   Move private task structure to slap.h.
-   Create new public API functions.
-   Make slapi\_task\_status\_changed() private.
-   Expose dseCallbackFn return value macros.
-   Port existing tasks to use new task API.

