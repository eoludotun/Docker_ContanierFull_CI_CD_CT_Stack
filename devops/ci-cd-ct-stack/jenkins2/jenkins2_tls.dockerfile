
#docker build -t "mytlsjenkins" --build-arg DOCKER_HOST=$(docker-machine ls --filter name=$(cat ../../DOCKE$

# First copy the certs created by docker-machine to root of this folder
# bin/bash copy_certs.sh

# Run as below
# docker run -d -p 8080:8080 -p 50000:50000 -v /home/docker:/var/jenkins_home mytlsjenkins
# After this the client certs should be scp as below
#docker-machine scp ~/.docker/machine/machines/default/ca.pem default:/home/docker/.docker/
#docker-machine scp ~/.docker/machine/machines/default/cert.pem default:/home/docker/.docker/
#docker-machine scp ~/.docker/machine/machines/default/key.pem default:/home/docker/.docker/

FROM jenkins:2.46.1-alpine
MAINTAINER Ben
USER root

RUN apk update && apk add wget tar


RUN echo 'if [ -z "$TIME_ZONE" ]; then echo "No TIME_ZONE env set!" && exit 1; fi' > /set_timezone.sh; \
        echo "sed -i 's|;date.timezone.*=.*|date.timezone='\$TIME_ZONE'|' /etc/php5/cli/php.ini;" >> /set_t$
        echo "echo \$TIME_ZONE > /etc/timezone;" >> /set_timezone.sh; \
        echo "export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive;" >> /set_timezone.sh;$
        echo "dpkg-reconfigure tzdata" >> /set_timezone.sh; \
        echo "echo time zone set to: \$TIME_ZONE"  >> /set_timezone.sh

RUN echo 'if [ -n "$TIME_ZONE" ]; then sh /set_timezone.sh; fi;' > /run_all.sh; \
        echo "curl -o /var/lib/jenkins/jobs/php-template/config.xml https://raw.githubusercontent.com/sebas$
        echo "service jenkins start" >> /run_all.sh; \
        echo "tail -f /var/log/jenkins/jenkins.log;" >> /run_all.sh


#USER root
# export DOCKER_HOST environment variable
ARG DOCKER_HOST
ENV DOCKER_HOST=$DOCKER_HOST
# so that jenkins can access docker daemon on docker-machine
# docker reads client certs from this location
#COPY ca.pem cert.pem key.pem /home/docker/.docker/

ENV DOCKER_TLS_VERIFY="1"
ENV DOCKER_CERT_PATH=/var/jenkins_home/.docker
USER root
# Get docker client
RUN wget https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz
RUN tar xvzf docker-latest.tgz && mv ./docker/* /usr/bin/
