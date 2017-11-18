#!/bin/sh

for i in 1 2 3; do
  docker-machine create -d virtualbox node-$i
done

eval $(docker-machine env node-1)

docker swarm init --advertise-addr $(docker-machine ip node-1)

TOKEN=$(docker swarm join-token -q worker)

for i in 2 3; do
  eval $(docker-machine env node-$i)
  docker swarm join --token $TOKEN $(docker-machine ip node-1):2377
done

echo "Swarm cluster has been successfuly created !"

eval $(docker-machine env node-1)

docker node ls
