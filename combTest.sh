#! /bin/bash
apt-get update
apt-get install bc

N=$1 #number of iterations
c=0 #counter
totalRuntimeLaunch=0
totalRuntimeStartStop=0
averageRuntimeLaunch=0
averageRuntimeStartStop=0

docker run -t -d --name t1 $2
docker stop -t 0 t1
docker rm t1


for ((n=0;n<$N;n++))
do
	startL=$(date +%s.%6N)
	docker run -t -d --name t1 -p 8080:80 $2 
	until $(curl --output /dev/null --silent --head --fail localhost:8080); do
		:
	done
	endL=$(date +%s.%6N)

    	startSS=$(date +%s.%6N)
	docker stop -t 0 t1
	docker start -p 8090:80 t1
	until $(curl --output /dev/null --silent --head --fail localhost:8090); do
		:
	done
	endSS=$(date +%s.%6N)

	runtimeLaunch=$(echo "$endL - $startL" | bc -l)
	runtimeStartStop=$(echo "$endSS - $startSS" | bc -l)
	echo ""
	echo ""
	echo "iteration: $n"	
	echo "runtime LAUNCH: $runtimeLaunch"
	echo "runtime START-STOP: $runtimeStartStop"

	totalRuntimeLaunch=$(echo "$runtimeLaunch + $totalRuntimeLaunch" | bc -l)
	totalRuntimeStartStop=$(echo "$runtimeStartStop + $totalRuntimeStartStop" | bc -l)
	#echo "toalRuntime LAUNCH: $totalRuntimeLaunch"
	#echo "toalRuntime START-STOP: $totalRuntimeStartStop"

	##cleanup
	docker stop -t 0 t1
	docker rm t1
done
averageRuntimeLaunch=$(echo "$totalRuntimeLaunch / $N" | bc -l)
averageRuntimeStartStop=$(echo "$totalRuntimeStartStop / $N" | bc -l)
echo "average runtime LAUNCH: $averageRuntimeLaunch"
echo "average runtime START-STOP: $averageRuntimeStartStop"




