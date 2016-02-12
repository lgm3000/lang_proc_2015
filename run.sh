#!/bin/bash
INPUT=test.input;
OUTPUT=test.output;

# Run your program, write the output to file name in GOT
cat ${INPUT}  |  bin/c_lexer  >  ${OUTPUT}
