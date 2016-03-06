using Redis

include("ZoomScript.jl")

function run_test()

    data = zeros(10,3)
    data_size = length(data[:,1])

    # Redis connection
    c = RedisConnection(host="localhost",port=6379)

	# Steps 1,2,3
	for i in 1:data_size              # 1 to number of lines
		t = ZoomScript.view()        # view() returns 3 values: step 1, 2, 3 elapsed time
		for j in 3:5
			data[i,j-2]  = t[j]
		end
		flushall(c)
	end

	fdata = open("data_steps3.txt","w+")

	write(fdata,"data \n")
	write(fdata,"| Step 3.1 (get list) | Step 3.2 (convert)  | Step 3.3 (create png) | \n")
	write(fdata,"$data")

	close(fdata)

end

run_test()
