Lang-speed
==========

The purpose of this project is to compare raw performance of various
programming languages.

We achieve this by implementing the same simple, CPU-bound algorithm in each
language and running each implementation on the same computer.

Data from this project is updated periodically and published in the
[Research Computing User's Guide](http://acadix.biz/publications.php).

Selection sort was chosen for its easy implementation and high
CPU use without high memory demands.  It uses a typical nested loop such as
would be found in many other programs where run time is a concern.

Choosing a different algorithm would likely produce different relative
run times, but tell the same basic story.  We are not concerned here with
precise run times, but a ball-park estimate of language performance.
Feel free to implement another algorithm such as matrix multiplication,
Gauss elimination, etc. if you are curious about how different the results
will be.

There are, of course, faster ways to perform tasks like sorting in interpreted
languages such as Python or Perl, mostly using built-in features or libraries
written in compiled languages like C and C++.  The point of this comparison,
however, is to show the relative speed of code implemented natively in each
language.  Many researchers implement scientific code in interpreted languages,
unaware that compiled languages are much faster.  This tool is meant to
provide data to guide the choice of language for time-consuming algorithms.

To run the test, type:

    ./bench list-size

This will create a new file in the Results subdirectory with the same
output shown on the terminal.
    
When running the test, choose list size that will require at least a few
seconds of run time for the fastest implementation, so that program overhead
does not constitute a significant fraction of total run time.  200,000
elements has proven to work well on an Intel i5, requiring a few seconds
for the fastest languages and a several minutes for the slowest.

The operating system is irrelevant, as the program is purely computational.
Run time should depend only on the compiler/interpreter and the hardware.

The project was developed on FreeBSD, where installing the latest compilers
and interpreters is very easy through the FreeBSD ports system.  Patches
for other platforms are welcome.
