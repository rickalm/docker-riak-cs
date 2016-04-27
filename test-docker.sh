docker ps -a | grep riak | cut -b1-20 | xargs docker rm -f

/bin/true && docker run -d \
  --net=host \
  --name=riak-01 \
  -e "DDEBUG=yes" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  rickalm/riak-cs \
  && docker exec -it riak-01 /bin/bash

/bin/false && docker run -d \
  --net=bridge \
  --name=riak-02 \
  -p 41001:7946/tcp \
  -p 41001:7946/udp \
  -p 8087 \
  -p 8098 \
  -p 8099 \
  -p 4369 \
  -e "DEBUG=yes" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  rickalm/riak-cs \
  && docker exec -it riak-02 /bin/bash

