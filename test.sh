#! /bin/bash

N=5 #number of iterations
c=0 #counter
totalRuntime=0
averageRuntime=0
for ((n=0;n<$N;n++))
do
	start=$(date +%s.%6N)
	docker run -t -d --name t1 -p 8080:80  nginx
	until $(curl --output /dev/null --silent --head --fail localhost:8080); do
		:
	done
	end=$(date +%s.%6N)

	runtime=$(echo "$end - $start" | bc -l)
	echo "runtime: $runtime"

	totalRuntime=$(echo "$runtime + $totalRuntime" | bc -l)
	echo "toalRuntime: $totalRuntime"

	##cleanup
	docker stop t1
	docker rm t1
done
averageRuntime=$(echo "$totalRuntime / $N" | bc -l)
echo "average runtime: $averageRuntime"





