function imfilter_gaussian(L, s)
	if (isa(L, Array{Complex{Int64},2}) == false)
		return Images.imfilter_gaussian(L,[s,s])
	else 
		return Images.imfilter_gaussian(real(L),[s,s]),Images.imfilter_gaussian(imag(L),[s,s])
	end
end
