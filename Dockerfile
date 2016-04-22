#FROM phusion/baseimage:0.9.15

FROM rickalm/hashicorp-serf:latest
MAINTAINER rickalm@aol.com

# Environmental variables

# Make the Riak, Riak CS, and Stanchion log directories into volumes
#
VOLUME /var/lib/riak
VOLUME /var/log/riak
VOLUME /var/log/riak-cs
VOLUME /var/log/stanchion

# Open the HTTP port for Riak and Riak CS (S3)
#
EXPOSE 8098 8080

# Install Stanchion
#
RUN cd /tmp \
	&& STANCHION_VER=1.5.0 \
	&& STANCHION_SVER=1.5 \
	&& S3_BUCKET=http://s3.amazonaws.com/downloads.basho.com \
	&& curl -so package ${S3_BUCKET}/stanchion/${STANCHION_SVER}/${STANCHION_VER}/ubuntu/trusty/stanchion_${STANCHION_VER}-1_amd64.deb \
	&& dpkg -i "package" && rm "package"

# Install Riak
#
RUN cd /tmp \
	&& RIAK_VER=1.4.10 \
	&& RIAK_SVER=1.4 \
	&& S3_BUCKET=http://s3.amazonaws.com/downloads.basho.com \
	&& curl -so package ${S3_BUCKET}/riak/${RIAK_SVER}/${RIAK_VER}/ubuntu/precise/riak_${RIAK_VER}-1_amd64.deb \
	&& dpkg -i "package" && rm "package"

# Install Riak CS
#
RUN cd /tmp \
	&& RIAK_CS_VER=1.5.2 \
	&& RIAK_CS_SVER=1.5 \
	&& S3_BUCKET=http://s3.amazonaws.com/downloads.basho.com \
	&& curl -so package ${S3_BUCKET}/riak-cs/${RIAK_CS_SVER}/${RIAK_CS_VER}/ubuntu/trusty/riak-cs_${RIAK_CS_VER}-1_amd64.deb \
	&& dpkg -i "package" && rm "package"

# Setup start scripts for services
#
ADD etc /etc




# Setup automatic clustering for Riak
#ADD bin/automatic_clustering.sh /etc/my_init.d/99_automatic_clustering.sh

# Tune Riak and Riak CS configuration settings for the container
#ADD etc/riak-app.config /etc/riak/app.config

#RUN sed -i.bak "s/riak_cs-VER/riak_cs-${RIAK_CS_VER}/" /etc/riak/app.config && \
#    sed -i.bak 's/\"127.0.0.1\", 8098/\"0.0.0.0\", 8098/' /etc/riak/app.config && \
#    sed -i.bak "s/-env ERL_MAX_PORTS 16384/-env ERL_MAX_PORTS 64000/" /etc/riak/vm.args && \
#    sed -i.bak "s/##+zdbbl 32768/+zdbbl 96000/" /etc/riak/vm.args && \
#    sed -i.bak "s/{cs_ip, \"127.0.0.1\"},/{cs_ip, \"0.0.0.0\"},/" /etc/riak-cs/app.config && \
#    sed -i.bak "s/{fold_objects_for_list_keys, false},/{fold_objects_for_list_keys, true},/" /etc/riak-cs/app.config && \
#    sed -i.bak "s/{anonymous_user_creation, false},/{anonymous_user_creation, true},/" /etc/riak-cs/app.config && \
#    sed -i.bak "s/{stanchion_ip, \"127.0.0.1\"},/{stanchion_ip, \"0.0.0.0\"},/" /etc/stanchion/app.config
