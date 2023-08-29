# Copyright 2020, Gallagher Group Ltd

# Use GGL Ubuntu 18.04 LTS as the basis for the Docker image.
#FROM rnd-docker-images.local.gallagher.io/ggl_ubuntu:18.04.2
FROM ubuntu:18.04

RUN apt-get update && \
	apt-get install -y libx11-6 libfreetype6 libxrender1 libfontconfig1 libxext6 xvfb curl unzip python-pip wget

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
#RUN wget https://www.segger.com/downloads/embedded-studio/Setup_EmbeddedStudio_ARM_v550_linux_x64.tar.gz -O ses_install.tar.gz \
#	&& tar -xzf ses_install.tar.gz \
#	&& /bin/sh -c '/bin/echo -e "yes\n" | ./arm_segger_embedded_studio_550_linux_x64/install_segger_embedded_studio --copy-files-to /opt/ses'

# Install Segger Embedded Studio 4.52
RUN mkdir -p ${INSTALL} && \
	cd ${INSTALL} && \
	wget https://www.segger.com/downloads/embedded-studio/Setup_EmbeddedStudio_ARM_v542b_linux_x64.tar.gz -O ses.tar.gz && \
	tar xvzf ses.tar.gz && \
	echo "yes" | ./arm_segger_embedded_studio_542b_linux_x64/install_segger_embedded_studio --copy-files-to /opt/ses && \
 	cd .. && \
	rm -rf ${INSTALL}
 # Install Segger Embedded Studio 4.52

# Update pip3 to include nrfutil
RUN pip3 install --upgrade pip && pip3 install nrfutil

ENV PATH="/opt/mergehex:/opt/nrfjprog:/opt/ses/bin:$PATH"
