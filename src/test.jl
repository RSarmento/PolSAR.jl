include("ZoomScript.jl")

function run_test()

    fixed = zeros(10,3)
    random = zeros(10,3)

    for i in 1:10
        t1 = ZoomScript.view()
        t2 = ZoomScript.view(random=true)
        for j in 1:3
            fixed[i,j]  = t1[j]
            random[i,j] = t2[j]
        end
    end

    step1_mean = mean(fixed[:,1])
    step2_mean = mean(fixed[:,2])
    step3_mean = mean(fixed[:,3])

    step1_median = median(fixed[:,1])
    step2_median = median(fixed[:,2])
    step3_median = median(fixed[:,3])

    step1_sd = median(fixed[:,1])
    step2_sd = median(fixed[:,2])
    step3_sd = median(fixed[:,3])

    f = open("table.txt","w+")

    ########## table 1

    write(f,"| Metrics (fixed) | Median | Mean   | SD     |\n")
    write(f,"|:--------|:-------------|:------:|:------|\n")
    write(f,"| Step 1  | $step1_median | $step1_mean | $step1_sd |\n")
    write(f,"| Step 2  | $step2_median | $step2_mean | $step2_sd |\n")
    write(f,"| Step 3  | $step3_median | $step3_mean | $step3_sd |\n")

    step1_mean = mean(random[:,1])
    step2_mean = mean(random[:,2])
    step3_mean = mean(random[:,3])

    step1_median = median(random[:,1])
    step2_median = median(random[:,2])
    step3_median = median(random[:,3])

    step1_sd = median(random[:,1])
    step2_sd = median(random[:,2])
    step3_sd = median(random[:,3])
    
    ########## table 2

    write(f,"\n")
    write(f,"| Metrics (random)  | Median | Mean   | SD     |\n")
    write(f,"|:--------|:-------------|:------:|:------|\n")
    write(f,"| Step 1  | $step1_median | $step1_mean | $step1_sd |\n")
    write(f,"| Step 2  | $step2_median | $step2_mean | $step2_sd |\n")
    write(f,"| Step 3  | $step3_median | $step3_mean | $step3_sd |\n")

    flush(f)
    close(f)

end

run_test()
