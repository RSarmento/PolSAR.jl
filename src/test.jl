using Redis

include("ZoomScript.jl")

function run_test()

    data = zeros(2,4)
    data_size = length(data[:,1])

    # Redis connection
    c = RedisConnection(host="localhost",port=6379)

    # Steps 1,2,3
    for i in 1:data_size                                    # 1 to number of lines
        t = ZoomScript.view("imgs/fixed/img-$i.png")        # view() returns 3 values: step 1, 2, 3 elapsed time
        for j in 1:3
            data[i,j]  = t[j]
        end
        flushall(c)
    end

    # Step 3 (random)
    for i in 1:data_size
        t = ZoomScript.view("imgs/random/img-$i.png",random=true)
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
    
    step3_rand_median   = std(data[:,4])
    step3_rand_mean     = std(data[:,4])
    step3_rand_sd       = std(data[:,4])

    ########## data

    fdata = open("data.txt","w+")
    
    write(fdata,"data \n")
    write(fdata,"| Step 1 | Step 2  | Step 3 (fixed)  | Step 3 (random) \n")
    write(fdata,"$data")

    f = open("table.txt","w+")

    ########## table

    write(f,"| Metrics          | Median                | Mean                  | SD                |\n")
    write(f,"|:-----------------|:----------------------|:----------------------|:------------------|\n")
    write(f,"| Step 1           | $step1_median         | $step1_mean           | $step1_sd         |\n")
    write(f,"| Step 2           | $step2_median         | $step2_mean           | $step2_sd         |\n")
    write(f,"| Step 3 (fixed)   | $step3_median         | $step3_mean           | $step3_sd         |\n")
    write(f,"| Step 3 (random)  | $step3_rand_median    | $step3_rand_mean      | $step3_rand_sd    |\n")

    flush(f)
    flush(fdata)

    close(f)
    close(fdata)
    
    disconnect(c)

end

run_test()
