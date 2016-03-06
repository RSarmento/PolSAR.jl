using Redis
using DataFrames

include("ZoomScript.jl")

# A0 100%       = 153546 x 9580
# A1 50%        = 76773 x 4790
# A2 25%        = 38386.5 x 2395
# A3 12.5%      = 19193.25 x 1197.5
# A4 6.25%      = 9596.625 x 598.75
# A5 3.125%     = 4798.3125 x 299.375
# A6 1.5625%    = 2399.15625 x 149.6875

function run_test(id,scenario,zPercent,wPercent)

    reps = 10

	if !(ispath("tests/imgs") && ispath("tests"))
	   mkdir("tests")
	   mkdir("tests/scenario1")
	   mkdir("tests/scenario2")
	   mkdir("tests/imgs")
	   mkdir("tests/imgs/scenario1")
	   mkdir("tests/imgs/scenario2")
	end

    data = zeros(reps,3)

    # Steps 1,2,3
    for i in 1:reps
        #=t = ZoomScript.view("ChiVol_29304_14054_007_140429_L090HH_CX_01.slc","ChiVol_29304_14054_007_140429_L090VH_CX_01.slc","ChiVol_29304_14054_007_140429_L090VV_CX_01.slc",zPercent,wPercent,"tests/imgs/$scenario/img-$id-$i.png")=#
        t = ZoomScript.view("SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc","SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc","SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc",zPercent,wPercent,"tests/imgs/$scenario/img-$id-$i.png")
        for j in 1:3
            data[i,j]  = t[j]
        end
    end
    
	########## csv
	
	data = DataFrame(data)
	rename!(data, [:x1, :x2, :x3], [:Step1, :Step2, :Step3])

	writetable("tests/$scenario/$id-output.csv", data)

end

percents = [1.5625, 3.125, 6.25, 12.5, 25, 50, 100]

# scenario 1

#=j=6=#

#=for i in percents=#
    #=run_test("A$j","scenario1",i,i)=#
    #=j-=1=#
#=end=#

# scenario 2

j=6

for i in percents
    run_test("A$j","scenario2",i,1.5625)
    j-=1
end
