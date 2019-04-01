#!/bin/bash

inputfile=${1}
outputfolder=${2}
white_pixel=${3}
word_space=${4}


if [ -z "$white_pixel"  ] && [ -z "$word_space" ]; then
    python /input/horizontal_projection.py --input_image ${inputfile} --output_folder ${outputfolder}
elif [ -z "$white_pixel" ]; then
    python /input/horizontal_projection.py --imput_image ${inputfile} --output_folder ${outputfolder} --word_space ${word_space}
else
    python /input/horizontal_projection.py --imput_image ${inputfile} --output_folder ${outputfolder} --word_space ${word_space} --white_pixel ${white_pixel}
fi