function PauliDecomposition(mHH, mHV, mVV, height, width)
    
    # azure
    #=evalsha(redisConnection ,"30d92ef4780a9d1f952fc40afecb3c18f68907fc",3,[mHH,mHV,mVV],0)=#

    # localhost
    evalsha(conn,"30d92ef4780a9d1f952fc40afecb3c18f68907fc",3,[mHH,mHV,mVV],0)

    pauliReq = hgetall(redisConnection,"pauliReq")
    pauliGeq = hgetall(redisConnection,"pauliGeq")
    pauliBeq = hgetall(redisConnection,"pauliBeq")
    
    reshape([[pauliReq],[pauliGeq],[pauliBeq]],(1000;1000;3))

end
