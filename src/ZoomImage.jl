# This function takes a starting pixel (start) from the source data (a connection to a file with sourceHeight and sourceWidth) and returns a image vector.
# The source data is stored in binary with 16 bits per pixel (8 for the real part, 8 for the imaginary part), so there are no header bits.

function ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection)

    index = 1   # The array in which is going to be stored the needed values from the source data needs and index variable different from the tipical i or j form the loops
    start *= 8  # start is multiplied by 8 in order to skip pixels accordingly

    windowHeight = trunc(windowHeight) # trunced in order to avoid non integer values (unnaccepted by the functions that use those variables)
    windowWidth = trunc(windowWidth)
    
    imageVector = zeros(Float64, zoomHeight*zoomWidth)

    # SETTING POINTER: Here we get the position of the last pickable pixel in the line, setting the connection to 0 (the beginning) and then to the desired beginning of the upcomming image, then it is skiped to it's width (remember that each pixel is 8 bits), then saved for further use and finally reset to 0.

    seekstart(connection)
    skip(connection, start)
    skip(connection, 8*windowWidth)
    windowWidthPosition = convert(Int32, position(connection)/8)
    seekstart(connection)
    skip(connection, start)

    # SETTING PACES: Calculates the proportion in which the rows and columns pixels are skiped. 

    if (zoomWidth == windowWidth)
        widthPace = 0
        back = 0    # Back is needed because each access in the source file pixels automatically moves the pointer.
    else
        widthPace = trunc(windowWidth/zoomWidth)
        back = -8
    end

    if (zoomHeight == windowHeight)
        heightPace = 0
    else
        heightPace = trunc(windowHeight/zoomHeight)-1
    end

    heightPace  = convert(Int64, heightPace)
    widthPace = convert(Int64, widthPace)

    # FIRST LINE READING

    imageVector[index] = abs(read(connection, Float64, 1)[1])
    index +=  1

    for (j in 1:(zoomWidth-1)) # The order in which the pixels are accessed is important
        skip(connection, 8*widthPace)
        imageVector[index] = abs(read(connection, Float64, 1)[1])
        index +=  1
        skip(connection, back) # the automatical skip when the position is accessed in the source file is not accounted in the pace calculus
    end

    # ALL THE REMAINING LINES: After the first line is read, probably there are n != widthPace, making the continuous pace place the new line before or after it should begin to be alligned. To correct that, the moduloPosition is calculated using the modulo operation to find where the pointer is at in relation with the windowWidth, then the skipAux is calculated, taking in consideration also the heightPace, the pointer is moved, and the new line can begin alligned with the first.

    moduloPosition = convert(Int32, position(connection)/8)
    moduloValue = windowWidthPosition % moduloPosition
    skipAux = 8*(moduloValue + (sourceWidth - windowWidth) + (heightPace*sourceWidth))
    skip(connection, skipAux)  

    # Now that the first line is done and the number of pixels to skip in the end of every line is known the rest of the image can be done.
  
    for (i in 1:zoomHeight-1)
        imageVector[index] = abs(read(connection, Float64, 1)[1])
        index += 1
        for (j in 1:(zoomWidth-1))
            skip(connection, 8*widthPace)
            imageVector[index] = abs(read(connection, Float64, 1)[1])
            index += 1
            skip(connection, back)
        end
        skip(connection, skipAux)
    end

	imageVector

end
