Going from Perl to Python ...

Data types:

	list  -> tuple (immutable)  ( 10, 20, 30 ) 
    array -> list               [ 1, 3.4, 'hello' ]
    hash  -> dictionary         { 'a': 3, 'b': 42 }

File I/O
--------

Process every line in a file
	
    for line in file('filename.txt'):  # or open("filename.txt")
        print line

Process every line in a file on command line or stdio if no file

    while (<>) { 
		print $_;
	}

	import fileinput
	for line in fileinput.input():
		print line

Access stdin directly

    import sys
    for line in sys.stdin:
        print line

Slurp the whole file/stdin

    # in a string
    contents = file('filename.txt').read()
    all_input = sys.stdin.read()

    # one string per line, newlines removed
    list_of_strings = file('filename.txt').readlines()
    all_input_as_list = sys.stdin.readlines()

Write to a file

    f = open("out", "w")
    while year <= numyears:
        principal = principal * (1 + rate)
        # or f.write("%3d %0.2f" % (year, principal))
        print >>f, "%3d %0.2f" % (year, principal)
        year += 1
    f.close()

Resources:

* http://everythingsysadmin.com/perl2python.html
* Python: Essential Reference