###================================================================================================================================###
#
# This programm takes a starting pixel (start) from the source data (a conection to a file with sourceHeight and sourceWidth) and 
# builds an image (which has zoomHeight and zoomWidth) into a window (with dimentions windowHeight and windowWidth).
#
#
###================================================================================================================================###




function ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, conection)

  ###================================================================================================================================###

  # SETTING CONSTANTS:
  # The array in which is going to be stored the needed values from the source data needs and index variable different
  # from the tipical i or j form the loops.
  index = 1

  # The source data is stored in binary with 16 bits per pixel (8 for the real part, 8 for the imaginary part), so there are no 
  # header bits, and start is multiplied by 8 in order to skip pixels accordingly.
  start *= 8

  # windowHeight and windowWidth are trunced in order to avoid non integer values (unnaccepted by the functions that use those 
  # variables)
  windowHeight = trunc(windowHeight)
  windowWidth = trunc(windowWidth)

  # A vector is created with the desired dimentions because there are no matrix data types in Julia. Later it is going to be reshaped 
  # into a matrix alas.
  imageVector = zeros(Float64, zoomHeight*zoomWidth)
  

  ###================================================================================================================================###

  # SETTING POINTER:
  # Here we get the position of the last pickable pixel in the line, setting the conection to 0 (the beginning) and then to the desired
  # beginning of the upcomming image, then it is skiped to it's width (remember that each pixel is 8 bits), then saved for further use
  # and finally reset to 0
  seekstart(conection)
  skip(conection, start)
  skip(conection, 8*windowWidth)
  windowWidthPosition = convert(Int32, position(conection)/8)
  seekstart(conection)
  skip(conection, start)
  
  ###================================================================================================================================###

  # SETTING PACES:
  # Calculates the proportion in which the rows and columns pixels are skiped. Back is needed because each access in the source file 
  # pixels automatically moves the pointer.

  if (zoomWidth == windowWidth)
    widthPace = 0
    back = 0
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

  ###================================================================================================================================###
  # FIRST LINE READING:
  
  # The order in which the pixels are accessed is important
  # The last access can't be followed buy a skip(conection, 8*widthPace),
  # the reason being is that the automatical skip when the position is
  # accessed in the source file is not accounted in the pace calculus

  imageVector[index] = abs(read(conection, Float64, 1)[1])          
  index +=  1

  for (j in 1:(zoomWidth-1))
    skip(conection, 8*widthPace)
    imageVector[index] = abs(read(conection, Float64, 1)[1])          
    index +=  1
    skip(conection, back)
  end

  ###================================================================================================================================###
  # ALL THE REMAINING LINES:

  # After the first line is read, probably there are n != widthPace, making
  # the continuous pace place the new line before or after it should begin to be 
  # alligned. To correct that, the moduloPosition is calculated
  # using the modulo operation to find where the pointer is at in relation with
  # the windowWidth, then the skipAux is calculated, taking in consideration also the
  # heightPace, the pointer is moved, and the new line can begin alligned with the first.

  moduloPosition = convert(Int32, position(conection)/8)
  moduloValue = windowWidthPosition % moduloPosition
  skipAux = 8*(moduloValue + (sourceWidth - windowWidth) + (heightPace*sourceWidth))
  skip(conection, skipAux)  

  # Now that the first line is done and the number of pixels to skip in the end of every line is known
  # the rest of the image can be done.
  
  for (i in 1:zoomHeight-1)
    imageVector[index] = abs(read(conection, Float64, 1)[1])
    index = index + 1
    for (j in 1:(zoomWidth-1))
      skip(conection, 8*widthPace)
      imageVector[index] = abs(read(conection, Float64, 1)[1])
      index = index + 1
      skip(conection, back)
    end
    skip(conection, skipAux)
  end
  return (imageVector)
end

