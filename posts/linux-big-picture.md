To study complex systems we use *abstraction* - a fancy way to say that we
don't care about details of the components (subsystems, modules, packages,
...).

Levels of abstraction in a Linux system
=======================================

We need to organize the components somehow, however. In this case we create
groupings going from hardware to user:

User processes
* GUI
* servers
* shell

Kernel
* syscalls
* process mngt.
* memory mngt.
* device drivers

Hardware
* CPU
* RAM
* disks
* network ports

Difference between running kernel and user processes:
* code running in *user mode* has access only to a subset of memory and safe
    CPU operations
* code running in *kernel mode* has unrestricted access


Main memory (RAM)
-----------------

Just a big storage area for a bunch of 0s and 1s (bits).

All I/O from peripheral devices flows through RAM.

A CPU is just an operator on memory:

    CPU <-- reads instructions and data --- RAM
    CPU ---         writes data         --> RAM

State
* a particular arrangements of bits (in RAM)
* as it can consists of millions of bits we use abstract terms to describe it
    (ex. process is waiting for input)
* *image* - a particular physical arrangements of bits

Kernel
------

Nearly all kernel's tasks revolve around main memory:
* split memory into subdivisions
* keep state info about subdivisions
* make sure processes use only their subdivisions

Process mngt.
* which processes are allowed to use CPU
* many processes can run "simultaneously" (they don't run at exactly the same
    time) - the act of one process giving up control of CPU to another process
    is called *context switch*
* kernel runs between processes' time slices during a context switch
* the appearance of multiple processes running at the same time - *multitasking*
* in *multi-CPU* systems kernel doesn't need to relinquish control of its current
    CPU in order to allow a different process to run on a different CPU

Memory mngt.
* it is a complex task for the kernel - modern CPUs come with a help => memory
    management unit (MMU) using the virtual memory
* MMU interfaces processes' access to physical memory via memory address map
* kernel must still maintain the memory address map (page table -
    implementation of memory address map)

System calls and pseudodevices
* *syscalls* - feature of kernel for user processes to perform specific tasks
    (ex. opening, reading and writing files)
* syscall is an interaction between a process and the kernel
* all user processes (except for init) start as a result of `fork()` usually
    followed by `exec()`, ex.:

        shell ---> fork() ---> shell
                           |
                           +-> copy of shell ---> exec(ls) ---> ls 

* `exec` is actually an entire family of syscalls for similar tasks
* *psesudodevice* looks like a devices but it's another kernel feature
    (implemented purely in software) - ex. `/dev/random`

Userspace and users
-------------------

* userspace - the main memory allocated by the kernel to user processes
* user - object for supporting permissions and boundaries
* group - a set of users used mainly for sharing files access

Resources
=========

* Brian Ward: How Linux Works, 2nd  Edition; No Starch Press 2014