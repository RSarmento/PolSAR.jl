# PolSAR Images Applications using Julia

The propose of this project is to enable PolSAR images to be visualized and manipulated in Julia. 

PolSAR images are generally huge (small ones are 11858 X 3300), and normally can't be fully loaded. The approach here
is to summarize the full image into a smaller one. ZoomImage takes a starting pixel and creates a summarized or complete image from the given coordinates.

## Usage

The images can be downloaded in the following links:
[ASF - Alaska Satellite Facility](https://vertex.daac.asf.alaska.edu/#)
[UAVSAR - Uninhabited Aerial Vehicle Synthetic Aperture Radar](http://uavsar.jpl.nasa.gov/cgi-bin/download.pl)

The file `ZoomScript.jl` contains a example of the environment's set up to visualize the PolSAR image and the desired zoomed area.
Following is the script explanation:

* Installing and loading packages

```Julia
Pkg.add(ImageView)
Pkg.add(StatsBase)
using ImageView, StatsBase
```

* Connections

In the same folder as the code and images are stored, we create the connections (reference) to each one of the image bands.

```Julia
conection1 = open("SanAnd_05508_10007_005_100114_L090HHHH_CX_01.mlc")
conection2 = open("SanAnd_05508_10007_005_100114_L090HVHV_CX_01.mlc")
conection3 = open("SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc")
```

* Functions importing
ZoomImage is the visuazilation and zooming function, PauliDecomposition is a false coloring function, SaltPepperNoise adds the said noise to the image and MeanFilter is the proper filter to deal with salt and pepper noise.

```Julia
include("ZoomImagem.jl")
include("PauliDecompositon.jl")
include("SaltPepperNoise.jl")
include("MeanFilter.jl")
```

* Variables

Start is the initial pixel of the forming image, sourceHeight and sourceWidth are the dimentions of the original image (as described in the .ann, annotation file). The windowHeight and windowWidth variables are the window dimentions. Lastly, zoomHeight and zoomWidth are the zoomed area's dimentions.

```Julia
start		= 0
sourceHeight= 11858
sourceWidth	= 1650
windowHeight= 11858
windowWidth	= 1650
zoomHeight 	= 11858
zoomWidth	= 1650
```

* Image Bands

A, B and C are auxiliars for each image band

```Julia
A = ZoomImagem(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, conection1)
B = ZoomImagem(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, conection2)
C = ZoomImagem(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, conection3)
```

* False coloring

False coloring and visualization of the result

```Julia
pauliRGBeq = PauliDecompositon(A, B, C, zoomHeight, zoomWidth)
ImageView.view(pauliRGBeq)
```

* Noise and filtering

```Julia
noisy = SaltPepperNoise(pauliRGBeq, zoomWidth, zoomHeight)
ImageView.view(noisy)
pauliRGBeqMean = MeanFilter(noisy, zoomWidth, zoomHeight)
ImageView.view(pauliRGBeqMean)
```


## ZoomImage

This programm takes a starting pixel (start) from the source data (a conection to a file with sourceHeight and sourceWidth) and builds an image (which has zoomHeight and zoomWidth) into a window (with dimentions windowHeight and windowWidth).

* Setting constants

The array in which it is going to be stored needs an index value different from the i or j values form the loops. The source file is a binary complex vector with 16 bytes per pixel (8 for the real part, 8 for the imaginary part) with no header bits, and so start is multiplied by 8 in order to skip pixels accordingly. The windowHeight and windowWidth values are trunced in order to avoid non integer values (unnaccepted by the functions that use those variables), and a vector is created with the desired dimentions. As there is not a matrix data type in Julia later it is going to be reshaped into a matrix.

* Setting pointers

The position of the last pickable pixel in the line is accessed, then the conection is reset to 0 (the beginning) and later to the desired beginning of the upcomming image, then it is skiped to it's width (remember that each pixel is 8 bits), then saved for further use and finally reset to 0.

* Setting pace

Calculates the proportion in which the rows and columns pixels are skiped. Back is needed because each access in the source file pixels automatically moves the pointer.

* First line

The order in which the pixels are accessed is important. The last access can't be followed by a skip(conection, 8*widthPace), the reason being is that the automatical skip when the position is accessed in the source file is not accounted in the pace calculation.

* Remaining lines

After the first line is read, probably there are n != widthPace, making the continuous pace place the new line before or after it should begin to be alligned. To correct that, the moduloPosition is calculated using the modulo operation to find where the pointer is at in relation with the windowWidth, then the skipAux is calculated, taking in consideration also the heightPace, the pointer is moved, and the new line can begin alligned with the first.

Now that the first line is done and the number of pixels to skip in the end of every line is known the rest of the image can be done.
