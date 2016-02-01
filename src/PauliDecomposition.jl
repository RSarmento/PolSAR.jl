function PauliDecomposition(mHH, mHV, mVV, height, width)
    
    # azure
    #=evalsha(redisConnection ,"30d92ef4780a9d1f952fc40afecb3c18f68907fc",3,[mHH,mHV,mVV],0)=#

    # localhost
    #=evalsha(conn,"a3785935e107c2ef60fd2591c75955df34da0968",3,[mHH,mHV,mVV],0)=#
    #=println("Calculating Pauli Decomposition...")=#
    #=sleep(30)=#

    println("Calculating Pauli Decomposition...")
    pauliReq = lrange(redisConnection,"pauliReq",0,-1)
    pauliReq = map(x->parse(Float64,x),pauliReq)
    println("done 1")

    pauliGeq = lrange(redisConnection,"pauliGeq",0,-1)
    pauliGeq = map(x->parse(Float64,x),pauliGeq)
    println("done 2")

    pauliBeq = lrange(redisConnection,"pauliBeq",0,-1)
    pauliBeq = map(x->parse(Float64,x),pauliBeq)
    println("done 3")

    convert(Array{Float64}, reshape([[pauliReq],[pauliGeq],[pauliBeq]],(1000,1000,3)))

end
