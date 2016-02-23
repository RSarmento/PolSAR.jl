using Redis

function run_test()

    fixed = zeros(10)
    random = zeros(10)

    redisConnection = RedisConnection(host="localhost",port=6379)
    conn = open_pipeline(redisConnection)

    for i in 1:10
        fixed[i] = @elapsed include("../ZoomScript.jl")
        del(conn, "pauliReq", "pauliGeq","pauliBeq")
        random[i] = @elapsed include("../ZoomScript-random.jl")
        del(conn, "pauliReq", "pauliGeq","pauliBeq")
    end

    fixed_mean  = mean(fixed)
    fixed_median = median(fixed)
    fixed_deviation = std(fixed)
    
    rand_mean  = mean(random)
    rand_median = median(random)
    rand_deviation = std(random)

    f = open("table.txt","w+")

    write(f,"| Metrics | Median | Mean | SD |\n")
    write(f,"|:----------|:-------------|:------:|:------|\n")
    write(f,"| fixed | $fixed_median | $fixed_mean | $fixed_deviation |\n")
    write(f,"| random | $rand_median | $rand_mean | $rand_deviation |\n")
    flush(f)
    close(f)

end

run_test()
