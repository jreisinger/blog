Signal - a message from the kernel to a process. Used for:
* errors (kernel saying: "You can't touch that area of memory!")
* events (death of a child, interrupt with Ctrl-C)

To ask the kernel to a send a signal:

    kill [-SIGNAL] PID  # default signal is TERM

Signal types:
* TERM - terminate the process (polite request to die)
* KILL - terminate the process and remove it forcibly from memory
* STOP - freeze the process (stays in memory ready to continue where it left
    off)
* CONT - continue running the process
* INT - interrupt (Ctrl-C). Simple programs usually just die, more important ones (ex. shells, editors) just stop long-running operations.
* QUIT - generate core dump (Ctrl-\)
* CHLD - one of the child processes stopped running - or, more likely, exited

Each process has a default disposition (what to do) for each possible signal. You may install your own handler or otherwise change the disposition of most signals. Only SIGKILL and SIGSTOP cannot be changed. The rest you can:
* ignore
* trap
* block

Source:
* How Linux Works, 2nd
* Perl Cookbook, 2nd