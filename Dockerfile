# Riak CS
#
# VER       0.7.2

FROM phusion/baseimage:0.9.15
MAINTAINER rickalm@aol.com

# Environmental variables
ENV DEBIAN_FRONTEND noninteractive
ENV RIAK_VER 1.4.10
ENV RIAK_SVER 1.4
ENV RIAK_CS_VER 1.5.2
ENV RIAK_CS_SVER 1.5
ENV STANCHION_VER 1.5.0
ENV STANCHION_SVER 1.5
ENV SERF_VER 0.6.3
ENV S3_BUCKET http://s3.amazonaws.com/downloads.basho.com

# Make the Riak, Riak CS, and Stanchion log directories into volumes
VOLUME /var/lib/riak
VOLUME /var/log/riak
VOLUME /var/log/riak-cs
VOLUME /var/log/stanchion

# Open the HTTP port for Riak and Riak CS (S3)
EXPOSE 8098 8080

# Install dependencies
RUN apt-get update -qq && apt-get install unzip -y && rm -rf /etc/service/sshd /etc/service/syslog-ng /etc/service/cron

## Install Serf
RUN cd /tmp \
	&& curl -so package https://releases.hashicorp.com/serf/${SERF_VER}/serf_${SERF_VER}_linux_amd64.zip \
	&& unzip package -d /usr/bin/ \
	&& rm package \
	&& adduser --system --disabled-password --no-create-home --quiet --force-badname --shell /bin/bash --group serf \
    	&& echo "serf ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_serf \
	&& chmod 0440 /etc/sudoers.d/99_serf

# Install Riak
RUN cd /tmp \
	&& curl -so package ${S3_BUCKET}/riak/${RIAK_SVER}/${RIAK_VER}/ubuntu/precise/riak_${RIAK_VER}-1_amd64.deb \
	&& dpkg -i "package" && rm "package"

# Install Riak CS
RUN cd /tmp \
	&& curl -so package ${S3_BUCKET}/riak-cs/${RIAK_CS_SVER}/${RIAK_CS_VER}/ubuntu/trusty/riak-cs_${RIAK_CS_VER}-1_amd64.deb \
	&& dpkg -i "package" && rm "package"

# Install Stanchion
RUN cd /tmp \
	&& curl -so package ${S3_BUCKET}/stanchion/${STANCHION_SVER}/${STANCHION_VER}/ubuntu/trusty/stanchion_${STANCHION_VER}-1_amd64.deb \
	&& dpkg -i "package" && rm "package"

# Setup start scripts for services
#

ADD bin/serf /etc/service/serf

ADD bin/riak /etc/service/riak
#ADD bin/riak-cs.sh /etc/service/riak-cs/run
#ADD bin/stanchion.sh /etc/service/stanchion/run

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




RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Leverage the baseimage-docker init system
CMD ["/sbin/my_init", "--quiet"]
