docker build -t rickalm/riak-cs .
[ "${1}" == "push" ] && docker push rickalm/riak-cs
