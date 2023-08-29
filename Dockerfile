# Copyright 2020, Gallagher Group Ltd

# Use GGL Ubuntu 18.04 LTS as the basis for the Docker image.
#FROM rnd-docker-images.local.gallagher.io/ggl_ubuntu:18.04.2
FROM ubuntu:18.04

RUN apt-get update && \
	apt-get install -y libx11-6 libfreetype6 libxrender1 libfontconfig1 libxext6 xvfb curl unzip python-pip git zip && \
	pip install nrfutil

ENV INSTALL="/tmp/install"

RUN mkdir -p ${INSTALL} && \
	cd ${INSTALL} && \
	#curl https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-10-x-x/10-9-0/nRFCommandLineTools1090Linuxamd64tar.gz -o nrftools.tar.gz && \
	curl https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x/10-9-0/nrfcommandlinetools1090linuxamd64.tar.gz -o nrftools.tar.gz && \
	tar xf nrftools.tar.gz && \
	dpkg -i --force-overwrite JLink_Linux_V680a_x86_64.deb && \
	dpkg -i --force-overwrite nRF-Command-Line-Tools_10_9_0_Linux-amd64.deb && \
	cd .. && \
	rm -rf ${INSTALL}

RUN mkdir -p ${INSTALL} && \
	cd ${INSTALL} && \
	curl https://www.segger.com/downloads/embedded-studio/Setup_EmbeddedStudio_ARM_v510a_linux_x64.tar.gz -o ses.tar.gz && \
	tar xf ses.tar.gz && \
	echo "yes" | DISPLAY=:1 $(find arm_segger_* -name "install_segger*") --copy-files-to /opt/ses && \
	cd .. && \
	rm -rf ${INSTALL}

# Update pip3 to include nrfutil
RUN pip3 install --upgrade pip && pip3 install nrfutil

ENV PATH="/opt/mergehex:/opt/nrfjprog:/opt/ses/bin:$PATH"
