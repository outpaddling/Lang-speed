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
<table xml:id="exe-speed-$(basename $infile)" frame='all'>
    <title>Selection Sort of ${infile##*-} Integers</title>
    <tgroup cols='5' align='left' colsep='1' rowsep='1'>
    
    <thead>
    <row>
      <entry>Compiler/Interpreter</entry>
      <entry>Execution method</entry>
      <entry>Indexing</entry>
      <entry align='right'>Time (seconds)</entry>
      <entry align='right'>Peak memory</entry>
    </row>
    </thead>
	
    <tbody>
EOM

awk '$1 ~ "clang[0-9]+" && $2 == "int" { printf("    <row><entry>C %s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "gcc[0-9]+" && $2 == "int" { printf("    <row><entry>C %s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "clang\\+\\+" && $2 == "int" { printf("    <row><entry>C++ %s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "^g\\+\\+" && $2 == "int" { printf("    <row><entry>C++ %s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "gfortran" && $2 == "integer" { printf("    <row><entry>Fortran %s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "rust" && $2 == "i32" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "ldc2-" && $2 == "i32" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "go-" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "fpc-" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Compiled", $3, $4, $7); }' $infile
awk '$1 ~ "java-" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "JIT", $3, $4, $7); }' $infile
awk '$1 ~ "numba" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "JIT", $3, $4, $7); }' $infile | sed -e 's|py-|python-|'
awk '$1 ~ "py-.*-vectors" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Interpreted", $3, $4, $7); }' $infile | sed -e 's|py-|python-|'
awk '$1 ~ "py-.*-loops" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Interpreted", $3, $4, $7); }' $infile | sed -e 's|py-|python-|'
awk '$1 ~ "perl-.*-vectors" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Interpreted", $3, $4, $7); }' $infile
awk '$1 ~ "perl-.*-loops" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Interpreted", $3, $4, $7); }' $infile
awk '$1 ~ "^R-.*-vectors" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Interpreted", $3, $4, $7); }' $infile
awk '$1 ~ "^R-.*-loops" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Interpreted", $3, $4, $7); }' $infile
awk '$1 ~ "Octave-.*-vectors" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Interpreted", $3, $4, $7); }' $infile
awk '$1 ~ "Octave-.*-loops" && $2 == "integer" { printf("    <row><entry>%s</entry><entry>%s</entry><entry>%s</entry><entry align=\"right\">%s</entry><entry align=\"right\">%s</entry></row>\n", $1, "Interpreted", $3, $4, $7); }' $infile

cat << EOM
    </tbody>
    </tgroup>
</table>
EOM
