module ZoomScript

using Redis, Images
    
include("ReadImage.jl")
include("PauliLocal.jl")    		# A false coloring function
include("ZoomImage.jl")             # Visualization and zooming function
#include("PauliDecomposition.jl")   # A false coloring function (with Redis)
#include("SaltPepperNoise.jl")      # SaltPepperNoise ands the said noise to the image
#include("MeanFilter.jl")           # MeanFilter is the proper filter to deal with salt and pepper noise

function view(hh::AbstractString, hv::AbstractString, vv::AbstractString,percent=100, imgname="img.png")

	tic()

    global time = zeros(5)

    # time[1] = step 1
    # time[2] = step 2
    # time[3] = step 3

    # CONSTANTS

    # SandAnd dims
    #=const sourceHeight          	= 11858=#
    #=const sourceWidth	        	= 1650=#

    #ChiVol dims
    #=const sourceHeight          	= 153546=#
    #=const sourceWidth	        	= 9580=#

    start		            = 0
    sourceHeight          	= 153546
    sourceWidth	        	= 9580
    windowHeight          	= int(sourceHeight * (percent/100))
    windowWidth	        	= int(sourceWidth * (percent/100))
    zoomHeight 	        	= windowHeight
    zoomWidth	            = windowWidth

    connection1 = open(hh) # HHHH
    connection2 = open(hv) # HVHV
    connection3 = open(vv) # VVVV

    # The connections are each a reference to one of the image bands.
    #=connection1 = open("ChiVol_29304_14054_007_140429_L090HH_CX_01.slc") # HHHH=#
    #=connection2 = open("ChiVol_29304_14054_007_140429_L090VH_CX_01.slc") # HVHV=#
    #=connection3 = open("ChiVol_29304_14054_007_140429_L090VV_CX_01.slc") # VVVV=#

    #=connection1 = open("SanAnd_05508_10007_005_100114_L090HHHH_CX_01.mlc")=#
    #=connection2 = open("SanAnd_05508_10007_005_100114_L090HVHV_CX_01.mlc")=#
    #=connection3 = open("SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc")=#

	## Step 1

    # Image bands

	A = ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection1)
	B = ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection2)
	C = ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection3)
	time[1] = toc()

	## Step 2
	tic()
	pauliRGBeq = PauliDecomposition(A, B, C, zoomHeight, zoomWidth)
	time[2] = toc()

	## Step 3
	tic()
    saveimg_time = Images.save(imgname,convert(Image,pauliRGBeq))
	time[3] = toc()

    # Add of noise and visualization
    #@time noisy = SaltPepperNoise(pauliRGBeq, zoomWidth, zoomHeight)

    # Filtering and visualization
    #@time pauliRGBeqMean = MeanFilter(noisy, zoomWidth, zoomHeight)

    close(connection1)
    close(connection2)
    close(connection3)

	time

end

end
