FROM ecrop/word_segmentation_projection_profile

LABEL maintainer="lars.voegtlin@unifr.ch"

COPY horizontal_projection.py /input/horizontal_projection.py
COPY script.sh /input/script.sh