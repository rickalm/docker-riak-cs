export DCOS_PRIVATE_IP=$(hostname -i | awk '{print $1}')

docker rm -f riak-cs
#docker build -t riak-cs .
#docker run -d --name riak-cs -e "DCOS_PRIVATE_IP=${DCOS_PRIVATE_IP}" riak-cs
#docker exec -it riak-cs /bin/bash

docker rm -f serf
docker build -t rickalm/serf -f Dockerfile.serf .
docker push rickalm/serf
docker run -d --name serf -e "DCOS_PRIVATE_IP=${DCOS_PRIVATE_IP}" serf
docker exec -it serf /bin/bash

