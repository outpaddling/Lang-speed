#!/bin/sh -e

##########################################################################
#   Title:
#       Optional, defaults to the name of the script sans extention
#
#   Section:
#       Optional, defaults to 1
#
#   Synopsis:
#       
#   Description:
#       
#   Arguments:
#       
#   Returns:
#
#   Examples:
#
#   Files:
#
#   Environment:
#
#   See also:
#       
#   History:
#   Date        Name        Modification
#   2024-09-22  Jason Bacon Begin
##########################################################################

usage()
{
    printf "Usage: $0 results-file\n"
    exit 1
}


##########################################################################
#   Main
##########################################################################

if [ $# != 1 ]; then
    usage
fi
infile=$1

cat << EOM
<table xml:id="exe_speed" frame='all'>
    <title>Selection Sort of 100,000 Integers</title>
    <tgroup cols='5' align='left' colsep='1' rowsep='1'>
    
    <thead>
    <row>
      <entry>Compiler/Interpreter</entry>
      <entry>Execution method</entry>
      <entry>Indexing</entry>
      <entry>Time (seconds)</entry>
      <entry>Peak memory</entry>
    </row>
    </thead>
	
    <tbody>
EOM

awk '$1 ~ "clang[0-9]+" && $2 == "int" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "gcc[0-9]+" && $2 == "int" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "gfortran" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "rust" && $2 == "i32" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "go-" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "java-" && $1 !~ "-no-" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry></row>\n", $1, "JIT", $3, $4, $7); }' $infile
awk '$1 ~ "numba" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry></row>\n", $1, "JIT", $3, $4, $7); }' $infile
awk '$1 ~ "py-.*-vectors" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry></row>\n", $1, "Interpreted", $3, $4, $7); }' $infile
awk '$1 ~ "py-.*-loops" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry>%s</entry></row>\n", $1, "Interpreted", $3, $4, $7); }' $infile

cat << EOM
    </tbody>
    </tgroup>
</table>
EOM
