#!/bin/bash

inputfile=${1}
outputfolder=${2}
white_pixel=${3}
word_space=${4}

python horizontal_projection.py --input_image ${inputfile} --output_folder ${outputfolder} --line_space ${word_space} --white_pixel ${white_pixel}
