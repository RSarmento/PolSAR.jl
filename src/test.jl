include("ZoomScript.jl")

function run_test()


fixed_aux = [158.622861534 32.731745446 47.362205693
 162.242277993 32.069641145 44.971033462
 138.110122776 32.218151236 45.428324317
 133.625021253 32.331096781 47.052639995999996
 119.407441603 31.859108477 46.370881077
 122.204801183 31.845599561 46.840495124
 167.54373112 32.230990231 48.091289756
 163.749064987 32.188596687 47.775939506
 125.455671145 32.498577251 47.230937803
 124.182799389 32.384773131 46.780673801]


random_aux = [127.60182008 32.042187858 45.223123502
 122.059033686 31.910766738 47.035740218
 119.720702596 32.144205502 47.772451852
 134.663184269 32.467177013 46.98721364
 145.858430201 33.04415912 47.755313437
 132.820912257 32.426868568 48.615171726
 173.619377648 32.071506099 49.073882462
 147.391123767 32.028462345 47.141386522
 133.592882643 32.175844086 47.790289996
 136.871811404 32.405081568 47.567284595]


    fixed = zeros(30,3)
    random = zeros(30,3)

    for i in 1:30
			if i <= 10
				fixed[i,:]  = fixed_aux[i,:]
				random[i,:] = random_aux[i,:]
			else
				t1 = ZoomScript.view()
				t2 = ZoomScript.view(random=true)
				for j in 1:3
					fixed[i,j]  = t1[j]
					random[i,j] = t2[j]
				end
			end
    end
    
    step1_mean = mean(fixed[:,1])
    step2_mean = mean(fixed[:,2])
    step3_mean = mean(fixed[:,3])

    step1_median = median(fixed[:,1])
    step2_median = median(fixed[:,2])
    step3_median = median(fixed[:,3])

    step1_sd = std(fixed[:,1])
    step2_sd = std(fixed[:,2])
    step3_sd = std(fixed[:,3])

    ########## data

    fdata = open("data.txt","w+")
    
    write(fdata,"FIXED \n")
    write(fdata,"| Step 1 | Step 2  | Step 3  |\n")
    write(fdata,"$fixed")
    
    write(fdata,"\n\nRANDOM \n")
    write(fdata,"| Step 1 | Step 2  | Step 3  |\n")
    write(fdata,"$random")

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

    step1_sd = std(random[:,1])
    step2_sd = std(random[:,2])
    step3_sd = std(random[:,3])
    
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
