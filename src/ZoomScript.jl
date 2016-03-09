module ZoomScript

using Redis, Images
    
include("ReadImage.jl")
include("PauliLocal.jl")    		# A false coloring function
include("ZoomImage.jl")             # Visualization and zooming function
#include("PauliDecomposition.jl")   # A false coloring function (with Redis)
#include("SaltPepperNoise.jl")      # SaltPepperNoise ands the said noise to the image
#include("MeanFilter.jl")           # MeanFilter is the proper filter to deal with salt and pepper noise

function view(hh::AbstractString, hv::AbstractString, vv::AbstractString,zoomPercent=100,windowPercent=100,imgname="img.png")

	tic()

    global time = zeros(5)

    # time[1] = step 1
    # time[2] = step 2
    # time[3] = step 3

    # CONSTANTS

    # SandAnd dims
    # sourceHeight          	= 11858
    # sourceWidth	        	= 1650

    # ChiVol dims
    # sourceHeight          	= 153546
    # sourceWidth	        	= 9580

	# windowHeight=76773
	# windowWidth=4790
	# zoomHeight=4798
	# zoomWidth=300

    start		            = 0
    sourceHeight      		= 153546
    sourceWidth	    		= 9580
    windowHeight          	= round(Int,sourceHeight*(windowPercent/100))
    windowWidth	        	= round(Int,sourceWidth*(windowPercent/100))
    zoomHeight 	        	= round(Int,sourceHeight*(zoomPercent/100))
    zoomWidth	            = round(Int,sourceWidth*(zoomPercent/100))


	# connection files

    connection1 = open(hh) # HHHH
    connection2 = open(hv) # HVHV
    connection3 = open(vv) # VVVV

	########## Step 1

    # Image bands

	A = ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection1)
	B = ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection2)
	C = ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection3)

	time[1] = toc()

	########## Step 2

	tic()
	pauliRGBeq = PauliDecomposition(A, B, C, zoomHeight, zoomWidth)
	time[2] = toc()

	########## Step 3
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
