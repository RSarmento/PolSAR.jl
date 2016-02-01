-- @desc:   Applies pauli decomposition
-- @usage:  redis-cli --eval paulidecomposition.lua <hash_mHH> <hash_mHV> <hash_mVV>
-- @return: nil
-- ARGV[1] => mHH  
-- ARGV[2] => mHV
-- ARGV[3] => mVV  



-- tables for debugging
--------------------------

--local logtable = {}

--local function logit(msg)
  --logtable[#logtable+1] = msg
--end

--------------------------

local function getKeysSortedByValue(tbl, sortFunction)
  local keys = {}
  for key in pairs(tbl) do
    keys[#keys+1] = key
  end

  table.sort(keys, function(a, b)
    return sortFunction(tbl[a], tbl[b])
  end)

  return keys
end

local function ecdf(a,b)
    -- soft copy table
    -------------------
    
    local Xs = {}

    for i,j in pairs(a) do
        Xs[#Xs+1] = j
    end
    
    -------------------

    table.sort(Xs)

    local n = #a

    local ord = getKeysSortedByValue(b, function(a, b) return a < b end)
    local m = #b
    local r = {}
    local r0 = 0

    local i=1

    for x in pairs(Xs) do
        while i <= m and Xs[x] > b[ord[i]] do
            r[ord[i]] = r0/n
            i=i+1
        end
        r0=r0+1
        if i > m then
            break
        end
    end

    while i <= m do
        r[ord[i]] = n/n
        i=i+1
    end

    return r
end

local function array_tonumber(array)
    local result = {}

    for i in pairs(array) do
        result[i] = tonumber(array[i])
    end

    return result
end

 --array datas
local mHH = array_tonumber(redis.call('LRANGE',KEYS[1],0,-1))
local mHV = array_tonumber(redis.call('LRANGE',KEYS[2],0,-1))
local mVV = array_tonumber(redis.call('LRANGE',KEYS[3],0,-1))
local pauliR = {}
local pauliG = {}
local pauliB = {}

for i in pairs(mHH) do
        pauliR[#pauliR+1]=mHH[i]+mVV[i]
        pauliG[#pauliG+1]=math.abs(mVV[i] - mHH[i])
        pauliB[#pauliB+1]=2*mHV[i]
end

-- calculate ecdf
local pauliReq = ecdf(pauliR,pauliR)
local pauliGeq = ecdf(pauliG,pauliG)
local pauliBeq = ecdf(pauliB,pauliB)

-- transfer to Redis
for i in pairs(pauliReq) do
        redis.call('RPUSH', "pauliReq", pauliReq[i])
        redis.call('RPUSH', "pauliGeq", pauliGeq[i])
        redis.call('RPUSH', "pauliBeq", pauliBeq[i])
end
