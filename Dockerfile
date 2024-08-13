FROM ghcr.io/linuxserver/baseimage-alpine:3.20

LABEL repository="https://github.com/sasanjac/docker-abs-library-tools"

RUN \
	echo "**** install packages ****" && \
	apk add --no-cache \
	git \
	python3 \
	ffmpeg \
	py3-pip && \
	echo "**** clean up ****" && \
	rm -rf \
	/root/.cache \
	/tmp/*

# add local files
COPY root/ /
RUN chmod -r 744 /etc/cont-init-d
RUN chmod -r 744 /etc/services.d

# ports and volumes
VOLUME /data/import /data/export