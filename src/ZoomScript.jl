###================================================================================================================================###
#
# This script sets up the environment to visualize and select the PolSAR image and the desired zoomed area.
#
###================================================================================================================================###
# PauliDecomposition is a false coloring function
# ZoomImage is the visuazilation and zooming function
# SaltPepperNoise ands the said noise to the image
# MeanFilter is the proper filter to deal with salt and pepper noise
include("PauliDecomposition.jl")
include("ZoomImage.jl")
include("SaltPepperNoise.jl")
include("MeanFilter.jl")

###================================================================================================================================###
# LOADING PACKAGES:
# ImageView is for the visualization (see lines) and StasBase is for the ecdf() function, used in the Pauli Decomposition
using ImageView, StatsBase, Redis

# SETTING CONSTANTS:
# The connections are each a reference to one of the image bands.
# Variables as described in ZoomImage.jl comments
start		= 0

sourceHeight= 11858
sourceWidth	= 1650

windowHeight= 1000
windowWidth	= 1000

zoomHeight 	= 1000
zoomWidth	= 1000


connection = RedisConnection(host="cloudarray.ddns.net",port=7001)
conn = open_pipeline(connection)

connection1 = open("SanAnd_05508_10007_005_100114_L090HHHH_CX_01.mlc")
connection2 = open("SanAnd_05508_10007_005_100114_L090HVHV_CX_01.mlc")
connection3 = open("SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc")

# A, B and C are auxiliars for each image band
ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection1)
ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection2)
ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection3)

# False coloring and visualization of the result
#println("\n===== PAULI DECOMPOSITION =====\n")
#@time pauliRGBeq = PauliDecomposition(A, B, C, zoomHeight, zoomWidth)
#ImageView.view(pauliRGBeq)

# Add of noise and visualization
#println("\n===== SALT PEPPER NOISE =====\n")
#@time noisy = SaltPepperNoise(pauliRGBeq, zoomWidth, zoomHeight)
#ImageView.view(noisy)

# Filtering and visualization
#println("\n===== MEAN FILTER =====\n")
#@time pauliRGBeqMean = MeanFilter(noisy, zoomWidth, zoomHeight)
#ImageView.view(pauliRGBeqMean)

println("\nSleeping 60 seconds before exiting...")
#=sleep(60)=#
