# PolSAR Images Applications using Julia

The propose of this project is to enable PolSAR images to be visualized and manipulated in Julia. ZoomImage 
takes a starting pixel, variable start, from the source file. The file ia a binary complex vector, represented as 
reference or connection to a file with dimentions specified in the .ann file, variables sourceHeight and sourceWidth. 
Then it builds an image with zoomHeight and zoomWidth into a window with dimentions windowHeight and windowWidth.

## ZoomImage
This programm takes a starting pixel (start) from the source data (a conection to a file with sourceHeight and sourceWidth) and 
builds an image (which has zoomHeight and zoomWidth) into a window (with dimentions windowHeight and windowWidth).

## Scrip
The file `ZoomScript.jl` contains the set up of the environment to visualize the PolSAR image and the desired zoomed area.
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
# 
conection1 = open("SanAnd_05508_10007_005_100114_L090HHHH_CX_01.mlc")
conection2 = open("SanAnd_05508_10007_005_100114_L090HVHV_CX_01.mlc")
conection3 = open("SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc")
```

* Functions importing
	ZoomImage is the visuazilation and zooming function, PauliDecomposition is a false coloring function, SaltPepperNoise adds the 
	said noise to the image and MeanFilter is the proper filter to deal with salt and pepper noise.

```Julia
	include("ZoomImagem.jl")
	include("PauliDecompositon.jl")
	include("SaltPepperNoise.jl")
	include("MeanFilter.jl")
```

* Variables
	Start is the initial pixel of the forming image, sourceHeight and sourceWidth are the dimentions of the original image (as described
	in the .ann, annotation file). The windowHeight and windowWidth variables are the window dimentions. Lastly, zoomHeight and zoomWidth
	are the zoomed area's dimentions.

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
