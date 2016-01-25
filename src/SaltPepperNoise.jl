function SaltPepperNoise(img, width, height)
	newImg = img
	times = (width*height)/100
	for (j in 1:times)
		x = rand(1:width)
		y = rand(1:height)
		newImg[x,y,1] =  1
		newImg[x,y,2] =  1
		newImg[x,y,3] =  1
	end
	return (newImg)
end
