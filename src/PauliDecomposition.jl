function PauliDecomposition(mHH, mHV, mVV, height, width)

    # pauliR = mHH + mVV
    # pauliG = abs(mVV - mHH)
    # pauliB = 2*mHV
    evalsha(conn,"a4fd96e3cf78afa28e318be4a3aaf75d21968a6f",3,[mHH,mHV,mVV])

    pauliReq = ecdf(pauliR)(pauliR)
    pauliGeq = ecdf(pauliG)(pauliG)
    pauliBeq = ecdf(pauliB)(pauliB)
    pauliRGBeq = reshape([[pauliReq],[pauliGeq],[pauliBeq]],(width,height,3))

    return pauliRGBeq
end
