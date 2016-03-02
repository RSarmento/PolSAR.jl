function PauliDecomposition(mHH, mHV, mVV)

    tic()
    sleep(2)
    println("Calculating Pauli Decomposition (1)...")
    evalsha(redisConnection,"95040e06e0ce43628c1e4bb162317db926dd6e51",3,[mHH,mHV,mVV],0)
    time[2] = toc()

    tic()
    println("Calculating Pauli Decomposition (2)...")
    lrange(pipeline2,"pauliReq",0,-1)
    lrange(pipeline2,"pauliGeq",0,-1)
    lrange(pipeline2,"pauliBeq",0,-1)
    pauliReq, pauliGeq, pauliBeq = read_pipeline(pipeline2)

    pauliReq = map(x->parse(Float64,x),pauliReq)
    pauliGeq = map(x->parse(Float64,x),pauliGeq)
    pauliBeq = map(x->parse(Float64,x),pauliBeq)
    pauliRGBeq = convert(Array{Float64}, reshape([[pauliReq],[pauliGeq],[pauliBeq]],(1000,1000,3)))

    time[3] = toc()

    pauliRGBeq 
end
