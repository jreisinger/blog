# Unix Times
###### linux, perl

Unix filesystem consists of two parts: 

* data blocks - contents of files and directories (special files with inode-name pairs)
* index to those data blocks

Entries in the index are called `inodes` (index nodes). Inodes contain medatada (data about data) on the files, like a pointer to the data blocks, the type of thing it represents (directory, file, etc.), the size of the thing, permissions bits, info on owner and group, etc. There is also a time information among the metadata. Actually three types of them:

    .----------------------------------------------------------------------------------------------------.
    | Type        | Short name | ls option | Description                                                 |
    +-------------+------------+-----------+-------------------------------------------------------------+
    | Access Time | atime      | -ult      | when file was last accessed (read)                          |
    | Modify Time | mtime      | -lt       | when the actual contents of the file were last modified     |
    | Change Time | ctime      | -cl       | when the inode information (the metadata) was last modified |
    '-------------+------------+-----------+-------------------------------------------------------------'
<!-- Original table data:
Type;Short name;ls option;Description
Access Time;atime;-ult;when file was last accessed (read)
Modify Time;mtime;-lt;when the actual contents of the file were last modified
Change Time;ctime;-cl;when the inode information (the metadata) was last modified
-->

## Using timestamps

To get information about a file (actually about its inode) run the shell command `stat` or `find`:

* `find /home/webservice/backups/ -mtime +5 -exec rm -f {} \;` -- will delete any file with content that had not changed for 5 days from now.
* `find /home/webservice/backups/ -ctime +5 -exec rm -f {} \;` -- will delete any file that has been untouched for 5 days.

## Getting time info with Perl

To access an inode from within Perl, use:

**1.** `stat` function (returns pretty much everything that the underlying <a href="https://en.wikipedia.org/wiki/Stat_(system_call)">stat</a> Unix system call returns):

    my($atime, $mtime, $ctime) = (stat($filename))[8,9,10] or die "Couldn't stat '$filename': $!";

.. `$atime`, `$mtime`, and `$ctime` -- The three timestamps represented in the system's timestamp format: a 32-bit number telling how many seconds have passed since the ''Epoch'', an arbitrary starting point for measuring system time (it's the beginning of 1970 at midnight Universal Time on Unix systems).

**2.** [File::stat](https://metacpan.org/module/File::stat):

    use File::stat;
    
    my $inode = stat("/bin/ls");
    my $ctime = $inode->ctime;
    my $size  = $inode->size;

**3.** [-X operators](http://perldoc.perl.org/functions/-X.html), modeled on the shell's `test` operators:

    my @original_files = qw/ file1 file2 file2 /;  # in practice - read from the FS using a glob or directory handle
    my @big_old_files;                             # files we want to put on backup tapes
    foreach my $filename (@original_files) {
        push @big_old_files, $filename             
          if -s $filename > 100_000 and -A _ > 90; # -X operators cache value returned by stat(2); access it via _
    }

## Changing timestamps with Perl

In those rare cases when you want to lie to other programs about when a file was most recently accessed (atime) or modified (mtime), use the `utime` function:

    my $atime = time;                 # now
    my $mtime = $time - 24 * 60 * 60; # one day (2 073 600 secs) ago
    utime $atime, $mtime, glob "*";   # set access to now, mod to a day ago

.. the third timestamp (ctime) is always set to "now" whenever anything alters a file - there's no way to set it with `utime`

.. the primary purpose of ctime is for incremental backups - if the file's ctime is newer that the date on the backup tape, it's time to back it up again
