###================================================================================================================================###
#
# This script sets up the environment to visualize and select the PolSAR image and the desired zoomed area.
#
###================================================================================================================================###


###================================================================================================================================###
# LOADING PACKAGES:
# ImageView is for the visualization (see lines) and StasBase is for the ecdf() function, used in the Pauli Decomposition
using ImageView, StatsBase

# SETTING CONSTANTS:
# The connections are each a reference to one of the image bands.
conection1 = open("SanAnd_05508_10007_005_100114_L090HHHH_CX_01.mlc")
conection2 = open("SanAnd_05508_10007_005_100114_L090HVHV_CX_01.mlc")
conection3 = open("SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc")

# PauliDecomposition is a false coloring function
# ZoomImage is the visuazilation and zooming function
# SaltPepperNoise ands the said noise to the image
# MeanFilter is the proper filter to deal with salt and pepper noise
include("PauliDecompositon.jl")
include("ZoomImagem.jl")
include("SaltPepperNoise.jl")
include("MeanFilter.jl")

# Variables as described in ZoomImage.jl comments
start		= 0
sourceHeight= 11858
sourceWidth	= 1650
windowHeight= 11858
windowWidth	= 1650
zoomHeight 	= 11858
zoomWidth	= 1650

# A, B and C are auxiliars for each image band
A = ZoomImagem(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, conection1)
B = ZoomImagem(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, conection2)
C = ZoomImagem(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, conection3)

# False coloring and visualization of the result
pauliRGBeq = DecomposicaoPauli(A, B, C, zoomHeight, zoomWidth)
ImageView.view(pauliRGBeq)

# Add of noise and visualization
noisy = SaltPepperNoise(pauliRGBeq, zoomWidth, zoomHeight)
ImageView.view(noisy)

# Filtering and visualization
pauliRGBeqMean = MeanFilterPolSAR(noisy, zoomWidth, zoomHeight)
ImageView.view(pauliRGBeqMean)
