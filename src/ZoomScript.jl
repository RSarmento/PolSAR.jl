###================================================================================================================================###
#
# This script sets up the environment to visualize and select the PolSAR image and the desired zoomed area.
#
###================================================================================================================================###

using Redis, Images

# PauliDecomposition is a false coloring function
# ZoomImage is the visuazilation and zooming function
# SaltPepperNoise ands the said noise to the image
# MeanFilter is the proper filter to deal with salt and pepper noise

include("PauliDecomposition.jl")
include("ZoomImage.jl")
include("SaltPepperNoise.jl")
include("MeanFilter.jl")

###================================================================================================================================###

# Redis connection

redisConnection = RedisConnection(host="localhost",port=6379)
conn = open_pipeline(redisConnection)

# SETTING CONSTANTS:
# The connections are each a reference to one of the image bands.
# Variables as described in ZoomImage.jl comments

start		= 0

#ChiVol dims
sourceHeight    = 153546
sourceWidth	= 9580

#SanAnd dims
#sourceHeight    = 11858
#sourceWidth	= 1650


windowHeight    = 1000
windowWidth	= 1000

zoomHeight 	= 1000
zoomWidth	= 1000

connection1 = open("ChiVol_29304_14054_007_140429_L090HH_CX_01.slc")
connection2 = open("ChiVol_29304_14054_007_140429_L090VH_CX_01.slc")
connection3 = open("ChiVol_29304_14054_007_140429_L090VV_CX_01.slc")

#connection1 = open("SanAnd_05508_10007_005_100114_L090HHHH_CX_01.mlc")
#connection2 = open("SanAnd_05508_10007_005_100114_L090HVHV_CX_01.mlc")
#connection3 = open("SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc")

# image bands
#ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection1) # HHHH=#
#ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection2) # HVHV=#
#ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection3) # VVVV=#

pauliRGBeq = PauliDecomposition(connection1.name, connection2.name, connection3.name, zoomHeight, zoomWidth)
Images.save("img.png",convert(Image,pauliRGBeq))

#ImageView.view(pauliRGBeq)
# Add of noise and visualization
#println("\n===== SALT PEPPER NOISE =====\n")
#@time noisy = SaltPepperNoise(pauliRGBeq, zoomWidth, zoomHeight)
#ImageView.view(noisy)

# Filtering and visualization
#println("\n===== MEAN FILTER =====\n")
#@time pauliRGBeqMean = MeanFilter(noisy, zoomWidth, zoomHeight)
#ImageView.view(pauliRGBeqMean)

disconnect(conn)
