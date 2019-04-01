from PIL import Image
import numpy as np
import argparse
import os


def main():
    parser = argparse.ArgumentParser(description='Word segementation based on the projection profile')
    parser.add_argument('--input_image', required=True,
                        help='The input image (line) on which we perform the word segmentation')
    parser.add_argument('--output_folder', required=True,
                        help='The path to the output folder')
    parser.add_argument('--white_pixel',
                        required=False,
                        default=10,
                        help='the threshold amount of whit pixel per column line')
    parser.add_argument('--line_space',
                        required=False,
                        default=10,
                        help='The amount of white spaces between words')

    args = parser.parse_args()

    img = Image.open(args.input_image, 'r')
    img = np.swapaxes(img, 0, 1)
    img = crop_img(img)

    _whiteLine = img.shape[0] * 255
    _threshold = _whiteLine - args.white_pixel * 255
    _line_threshold = args.line_space

    img_name, extension = os.path.splitext(os.path.basename(args.input_image))


    cutWordImages(getVerticalProjectionProfile(img), img, _threshold, _line_threshold, args.output_folder, img_name, extension)


def getVerticalProjectionProfile(img):
    return np.sum(img, axis=0)


def crop_img(img):
    locs = np.array(np.where(img != 255))[0:2, ]
    return img[np.min(locs[0, :]):np.max(locs[0, :]), np.min(locs[1, :]):np.max(locs[1, :])]


def cutWordImages(profiles, img, threshold, line_threshold, output_folder, img_name, extension):
    startList = [0]
    endList = [0]
    i = 0

    while i < len(profiles):
        if profiles[i] >= threshold:
            start = i

            while i + 1 < len(profiles) and profiles[i + 1] >= threshold:
                i += 1

            end = i
            totalDistance = end-start
            if totalDistance > line_threshold:
                startList.append(start)
                endList.append(end)

        i += 1

    startList.append(img.shape[1])

    for j in range(len(startList) - 1):
        # crop_img = Image.fromarray(np.swapaxes(img[endList[j]:startList[j + 1]], 0, 1))
        crop_img = Image.fromarray(img.transpose()[endList[j]:startList[j + 1]])
        crop_img.save(os.path.join(output_folder, img_name + '_line_' + str(j) + extension))


if __name__ == '__main__':
    main()
