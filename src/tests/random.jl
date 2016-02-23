using Redis

redisConnection = RedisConnection(host="localhost",port=6379)
conn = open_pipeline(redisConnection)

r1 = rand(1000000)
r2 = rand(1000000)
r3 = rand(1000000)

for i in 1:3
	for j in 1:1000000
		rpush(conn,"random-$i",r1[j])
	end
end
