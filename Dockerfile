FROM ghcr.io/linuxserver/baseimage-alpine:3.20

LABEL repository="https://github.com/sasanjac/docker-abs-library-tools"

# install build packages
RUN \
	echo "**** install build packages ****" && \
	apk add --no-cache --virtual=build-dependencies \
	cmake \
	ffmpeg-dev \
	g++ \
	gcc \
	jpeg-dev \
	libpng-dev \
	make \
	openjpeg-dev \
	python2-dev \
	binutils-libs \
	binutils \
	build-base \
	libgcc \
	make \
	pkgconf \
	pkgconfig \
	openssl \
	openssl-dev \
	ca-certificates \
	pcre \
	musl-dev \
	libc-dev \
	pcre-dev \
	zlib-dev \
	yasm-dev \
	lame-dev \
	libogg-dev \
	libvpx-dev \
	libvorbis-dev \
	freetype-dev \
	libtheora-dev \
	opus-dev && \
	# install runtime packages
	echo "**** install runtime packages ****" && \
	apk add --no-cache \
	git \
	python3 \
	py3-pip && \
	# add repository for fdk-aac-dev
	echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
	# install fdk-aac-dev packages
	apk add --update --no-cache \
	fdk-aac-dev && \
	# compile ffmpeg
	echo "**** compiling ffmpeg ****" && \
	cd /tmp && wget http://ffmpeg.org/releases/ffmpeg-7.0.tar.gz && \
	tar zxf ffmpeg-7.0.tar.gz  && \
	cd /tmp/ffmpeg-7.0 && \
	./configure \
	--enable-gpl \
	--enable-nonfree \
	--enable-small \
	--enable-libmp3lame \
	--enable-libx264 \
	--enable-libx265 \
	--enable-libvpx \
	--enable-libtheora \
	--enable-libvorbis \
	--enable-libopus \
	--enable-libfdk-aac \
	--enable-libass \
	--enable-libwebp \
	--enable-postproc \
	--enable-avresample \
	--enable-libfreetype \
	--enable-openssl \
	--disable-debug && \
	make && \
	make install && \
	# cleanup
	echo "**** cleanup ****" && \
	apk del --purge \
	build-dependencies && \
	rm -rf \
	/root/.cache \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /data/import /data/export