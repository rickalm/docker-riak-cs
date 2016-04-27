#FROM phusion/baseimage:0.9.15

FROM rickalm/hashicorp-serf:latest
MAINTAINER rickalm@aol.com

# Install Stanchion
#
RUN cd /tmp \
	&& STANCHION_VER=2.1.1 \
	&& STANCHION_SVER=2.1 \
	&& S3_BUCKET=http://s3.amazonaws.com/downloads.basho.com \
	&& curl -so package ${S3_BUCKET}/stanchion/${STANCHION_SVER}/${STANCHION_VER}/ubuntu/trusty/stanchion_${STANCHION_VER}-1_amd64.deb \
	&& dpkg -i "package" && rm "package"

# Install Riak
#
RUN cd /tmp \
	&& RIAK_VER=2.1.4 \
	&& RIAK_SVER=2.1 \
	&& S3_BUCKET=http://s3.amazonaws.com/downloads.basho.com \
	&& curl -so package ${S3_BUCKET}/riak/${RIAK_SVER}/${RIAK_VER}/ubuntu/trusty/riak_${RIAK_VER}-1_amd64.deb \
	&& dpkg -i "package" && rm "package"

# Install Riak CS
#
RUN cd /tmp \
	&& RIAK_CS_VER=2.1.1 \
	&& RIAK_CS_SVER=2.1 \
	&& S3_BUCKET=http://s3.amazonaws.com/downloads.basho.com \
	&& curl -so package ${S3_BUCKET}/riak-cs/${RIAK_CS_SVER}/${RIAK_CS_VER}/ubuntu/trusty/riak-cs_${RIAK_CS_VER}-1_amd64.deb \
	&& dpkg -i "package" && rm "package"

# Items for Stanchion
#
EXPOSE 8085
VOLUME /var/log/stanchion

# Make the Riak, Riak CS, and Stanchion log directories into volumes
#
VOLUME /var/lib/riak
VOLUME /var/log/riak
VOLUME /var/log/riak-cs

# Open the HTTP port for Riak and Riak CS (S3)
#
EXPOSE 8098 8080

# Setup start scripts for services
#
ADD etc /etc
RUN curl -L https://github.com/rickalm/docker-tools/raw/master/.docker_functions -so /etc/.docker_functions

