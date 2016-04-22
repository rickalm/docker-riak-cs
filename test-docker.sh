docker rm -f riak-cs 2>/dev/null

/bin/true && docker run -d \
  --net=bridge \
  --name=riak-cs \
  -e "DEBUG=yes" \
  -p 41001:7946 \
  -p 41001:7946/udp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  rickalm/riak-cs \
  && docker exec -it riak-cs /bin/bash
