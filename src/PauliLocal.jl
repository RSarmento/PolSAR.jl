using StatsBase

function PauliDecomposition(mHH, mHV, mVV, height, widht)

	pauliR = mHH + mVV

	pauliG = abs(mVV - mHH)

  pauliB = 2*mHV

	pauliReq = ecdf(pauliR)(pauliR)
	pauliGeq = ecdf(pauliG)(pauliG)
	pauliBeq = ecdf(pauliB)(pauliB)
	pauliRGBeq = reshape([[pauliReq],[pauliGeq],[pauliBeq]],(widht,height,3))

	return pauliRGBeq
end
