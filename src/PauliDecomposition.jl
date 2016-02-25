function PauliDecomposition(mHH, mHV, mVV, height, width)
    
    
#    println("Calculating Pauli Decomposition (1)...")
#    evalsha(redisConnection ,"95040e06e0ce43628c1e4bb162317db926dd6e51",3,[mHH,mHV,mVV],0)

    println("Calculating Pauli Decomposition (2)...")
    lrange(conn,"pauliReq",0,-1)
    lrange(conn,"pauliGeq",0,-1)
    lrange(conn,"pauliBeq",0,-1)
    pauliReq, pauliGeq, pauliBeq = read_pipeline(conn)

    pauliReq = map(x->parse(Float64,x),pauliReq)
    pauliGeq = map(x->parse(Float64,x),pauliGeq)
    pauliBeq = map(x->parse(Float64,x),pauliBeq)

    convert(Array{Float64}, reshape([[pauliReq],[pauliGeq],[pauliBeq]],(1000,1000,3)))

end
