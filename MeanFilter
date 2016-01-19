function MeanFilter(img, width, height)
	newImg = img
	for (i in 2:(width-1))
		for (j in 2:(height-1))
			newImg[i,j,1] =  (img[i-1,j-1,1] + img[i,j-1,1] 	+ img[i+1,j-1,1] + 
							  img[i-1,j,1] 	 + img[i,j,1] 		+ img[i+1,j,1] +
							  img[i-1,j+1,1] + img[i,j+1,1] 	+ img[i+1,j+1,1])/9
			newImg[i,j,2] =  (img[i-1,j-1,2] + img[i,j-1,2] 	+ img[i+1,j-1,2] + 
							  img[i-1,j,2] 	 + img[i,j,2] 		+ img[i+1,j,2] +
							  img[i-1,j+1,2] + img[i,j+1,2] 	+ img[i+1,j+1,2])/9
			newImg[i,j,3] =  (img[i-1,j-1,3] + img[i,j-1,3] 	+ img[i+1,j-1,3] + 
							  img[i-1,j,3] 	 + img[i,j,3] 		+ img[i+1,j,3] +
							  img[i-1,j+1,3] + img[i,j+1,3] 	+ img[i+1,j+1,3])/9
		end
	end
	return (newImg)
end
