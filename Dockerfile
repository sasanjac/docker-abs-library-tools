FROM ghcr.io/linuxserver/baseimage-alpine:3.20

LABEL repository="https://github.com/sasanjac/docker-abs-library-tools"

# install build packages
RUN \
	# add repository for fdk-aac-dev
	echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
	echo "**** install build packages ****" && \
	apk add --no-cache --virtual=build-dependencies \
	binutils \
	build-base \
	ca-certificates \
	cmake \
	fdk-aac-dev \
	ffmpeg-dev \
	freetype-dev \
	g++ \
	gcc \
	jpeg-dev \
	libass-dev \
	libc-dev \
	libgcc \
	libogg-dev \
	libpng-dev \
	libtheora-dev \
	libvorbis-dev \
	libvpx-dev \
	make \
	musl-dev \
	openjpeg-dev \
	openssl \
	openssl-dev \
	opus-dev \
	pcre \
	pcre-dev \
	pkgconf \
	pkgconfig \
	x264-dev \
	x265-dev \
	yasm-dev \
	zlib-dev && \
	# install runtime packages
	echo "**** install runtime packages ****" && \
	apk add --no-cache \
	fdk-aac \
	git \
	jpeg \
	lame \
	lame-dev \
	libass \
	libcrypto3 \
	libffi \
	libpng \
	libtheora \
	libvorbis \
	libvpx \
	libwebp \
	libwebp-dev \
	libxcb \
	nasm \
	openjpeg \
	opus \
	py3-pip \
	python3 \
	x264 \
	x264-libs \
	x265 && \
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