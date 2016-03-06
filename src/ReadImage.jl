function ReadImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection1, connection2, connection3)
	
	println("Reading image...")    
	tic()
    A = ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection1)
    B = ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection2)
    C = ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection3)
	println("Time: ",toc())

	println("Set list...")
    for i in 1:1000000
        rpush(pipeline,connection1.name,A[i])
        rpush(pipeline,connection2.name,B[i])
        rpush(pipeline,connection3.name,C[i])
    end
    
end

