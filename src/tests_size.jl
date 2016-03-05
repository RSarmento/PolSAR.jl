using Redis
using DataFrames

include("ZoomScript.jl")

function run_test(id::AbstractString,file1::AbstractString, file2::AbstractString, file3::AbstractString)

	if !(ispath("tests/imgs") && ispath("tests"))
	   mkdir("tests")
	   mkdir("tests/imgs")
	   mkdir("tests/imgs/random")
	   mkdir("tests/imgs/fixed")
	end

    data = zeros(30,4)
    data_size = length(data[:,1])

    # Redis connection
    c = RedisConnection(host="localhost",port=6379)

    # Steps 1,2,3
    for i in 1:data_size                                            # 1 to number of lines
        println("########## $id: fixed n $i")
        t = ZoomScript.view(file1,file2,file3,"tests/imgs/fixed/$id-$i.png")          # view() returns 3 values: step 1, 2, 3 elapsed time
        for j in 1:3
            data[i,j]  = t[j]
        end
        flushall(c)
    end

    # Step 3 (random)
    for i in 1:data_size
        println("########## $id: random n $i")
        t = ZoomScript.view(file1,file2,file3,"tests/imgs/random/$id-$i.png",random=true)
        data[i,4] = t[3]
        flushall(c)
    end
    
    step1_median = median(data[:,1])
    step2_median = median(data[:,2])
    step3_median = median(data[:,3])
    
    step1_mean = mean(data[:,1])
    step2_mean = mean(data[:,2])
    step3_mean = mean(data[:,3])

    step1_sd = std(data[:,1])
    step2_sd = std(data[:,2])
    step3_sd = std(data[:,3])
    
    step3_rand_median   = median(data[:,4])
    step3_rand_mean     = mean(data[:,4])
    step3_rand_sd       = std(data[:,4])

    ########## table

	f = open("tests/$id-table.txt","w+")

    write(f,"$id \n")
    write(f,"| Metrics          | Median                | Mean                  | SD                |\n")
    write(f,"|:-----------------|:----------------------|:----------------------|:------------------|\n")
    write(f,"| Step 1           | $step1_median         | $step1_mean           | $step1_sd         |\n")
    write(f,"| Step 2           | $step2_median         | $step2_mean           | $step2_sd         |\n")
    write(f,"| Step 3 (fixed)   | $step3_median         | $step3_mean           | $step3_sd         |\n")
    write(f,"| Step 3 (random)  | $step3_rand_median    | $step3_rand_mean      | $step3_rand_sd    |\n")
    
	########## csv

	data = DataFrame(data)
	rename!(data, [:x1, :x2, :x3, :x4], [:Step1, :Step2, :Step3_fixed, :Step3_random])

	writetable("tests/$id-output.csv", data)

    flush(f)
    close(f)
    disconnect(c)

end

run_test("A0","ChiVol_29304_14054_007_140429_L090HH_CX_01.slc","ChiVol_29304_14054_007_140429_L090VH_CX_01.slc","ChiVol_29304_14054_007_140429_L090VV_CX_01.slc")

for i in 1:6
    run_test("A$i","A$i-HHHH.slc","A$i-HVHV.slc","A$i-VVVV.slc")
end
