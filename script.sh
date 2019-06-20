#!/bin/bash

while getopts :i:o:f:w:s: option; do
    case $option in
        i) inputFolder=${OPTARG};;
        o) outputFolder=${OPTARG};;
        f) filter=${OPTARG};;
        w) white_pixel=${OPTARG};;
        s) word_space=${OPTARG};;
    esac
done

METHOD_NAME="text_segmentation_w_pp"


single_run () {
    # parameters are passed by position
    inputFile=${1}
    outputFolder=${2}
    white_pixel=${3}
    word_space=${4}

    # add /input/
    if [ -z "$white_pixel"  ] && [ -z "$word_space" ]; then
        python horizontal_projection.py --input_image ${inputFile} --output_folder ${outputFolder}
    elif [ -z "$white_pixel" ]; then
        python horizontal_projection.py --imput_image ${inputFile} --output_folder ${outputFolder} --word_space ${word_space}
    else
        python horizontal_projection.py --imput_image ${inputFile} --output_folder ${outputFolder} --word_space ${word_space} --white_pixel ${white_pixel}
    fi
}

# this will always be called and iterates over the input folders
multi_run () {
    # just files in a folder
    # $1 is the path to the input folder
    inputFolder=$1
    # $5 is the output folder
    outputFolderOri=$2
    # $2 is the filter for the input folder
    filter=$3
    # $3 white pixels
    white_pixels=$4
    # $4 word_space
    word_space=$5

    par_hash=$(create_parameter_hash $white_pixels $word_space)

    # combining the input path with the filter input
    path="/$inputFolder/$filter"

    counter=0
    for file in $(find $inputFolder -follow); do
        # if it is a file and not a folder execute the method
        # create the new output folder

        if [ ! -d "${file}" ] ; then
            fileName=$(basename -- "$file")

            # get file name without extension
            fileName="${fileName%.*}"

            # path for the output folder in the original output folder
            outputFolder="$outputFolderOri$METHOD_NAME-$fileName-$par_hash"

            # create the output folder
            mkdir $outputFolder

            # run the method with the current file
            single_run $file $outputFolder $white_pixels $word_space
        fi
        # count how many times the loop gets executed
        counter=$((counter+1))
    done

# multiple folder as input for the method
#    for folder in $(ls -d $path); do
#        if [ -d "${file}" ] ; then
#            if [ ! -d "${file}" ] ; then
#            fileName=$(basename -- "$file")
#            fileName="${fileName%.*}"
#            outputFolder="$outputFolderOri/$fileName"
#            # create the output folder
#            mkdir $outputFolder
#            single_run $file $outputFolder
#        fi
#        counter=$((counter+1))
#    done
}


create_parameter_hash () {
    param_string=""
    for par in "$@"; do
        param_string="$param_string-$par"
    done

    echo $param_string | md5sum | cut -d' ' -f1
}


# execution
multi_run $inputFolder $outputFolder $filter $white_pixel $word_space
