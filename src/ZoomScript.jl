module ZoomScript

using Redis, Images
    
include("ReadImage.jl")
include("PauliDecomposition.jl")    # A false coloring function
include("ZoomImage.jl")             # Visualization and zooming function
#include("SaltPepperNoise.jl")       # SaltPepperNoise ands the said noise to the image
#include("MeanFilter.jl")            # MeanFilter is the proper filter to deal with salt and pepper noise

function view(hh::AbstractString, hv::AbstractString, vv::AbstractString, imgname="img.png";random=false)

    tic()

    global time = zeros(5)

    # time[1] = step 1
    # time[2] = step 2
    # time[3] = step 3

    # CONSTANTS

    # SandAnd dims
    #=const sourceHeight          = 11858=#
    #=const sourceWidth	        = 1650=#

    #ChiVol dims
    #=const sourceHeight          = 153546=#
    #=const sourceWidth	        = 9580=#

    const start		            = 0
    const sourceHeight          = 153546
    const sourceWidth	        = 9580
    const windowHeight          = 1000
    const windowWidth	        = 1000
    const zoomHeight 	        = 1000
    const zoomWidth	            = 1000

    # REDIS CONNECTION
    global redisConnection = RedisConnection(host="localhost",port=6379)
    global pipeline        = open_pipeline(redisConnection)
    global pipeline2       = open_pipeline(redisConnection)

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

    # Image bands
    if(random==false) 
        ReadImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection1, connection2, connection3)
        time[1] = toc()
    else

        A = rand(1000000)
        B = rand(1000000)
        C = rand(1000000)
    
        for i in 1:1000000
            rpush(pipeline,connection1.name,A[i])
            rpush(pipeline,connection2.name,B[i])
            rpush(pipeline,connection3.name,C[i])
        end

        time[1] = toc()
    end

    pauliRGBeq = PauliDecomposition(connection1.name, connection2.name, connection3.name)
    saveimg_time = @elapsed Images.save(imgname,convert(Image,pauliRGBeq))
	time[3] = time[3] + saveimg_time

    # Add of noise and visualization
    #@time noisy = SaltPepperNoise(pauliRGBeq, zoomWidth, zoomHeight)

    # Filtering and visualization
    #@time pauliRGBeqMean = MeanFilter(noisy, zoomWidth, zoomHeight)

    flushall(redisConnection)

    close(connection1)
    close(connection2)
    close(connection3)

    disconnect(pipeline)
    disconnect(pipeline2)
    disconnect(redisConnection)

    time

end

end
