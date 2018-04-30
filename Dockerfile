FROM debian:9

Maintainer Adam Hickerson <adam.hickerson@cedarware.com>

# some const dependent on version
ENV TRUESTUDIO_VER x86_64_v9.0.0_20180117-1023
ENV TRUESTUDIO_URL http://download.atollic.com/TrueSTUDIO/installers/Atollic_TrueSTUDIO_for_STM32_linux_${TRUESTUDIO_VER}.tar.gz

RUN apt-get update && apt-get install -y curl --no-install-recommends

# Download first- speeds up builds if dependencies change
RUN set -xue && \
  curl -O ${TRUESTUDIO_URL}     && \
  curl -O ${TRUESTUDIO_URL}.MD5 && \
  md5sum -c $(basename ${TRUESTUDIO_URL}.MD5) && \
  rm $(basename ${TRUESTUDIO_URL}.MD5)

ENV TRUESTUDIO_INSTALL_PATH /opt/Atollic_TrueSTUDIO_for_STM32_9.0.0

# Install dependencies
RUN apt-get update && apt-get install -y libc6-i386 libusb-0.1-4 libwebkitgtk-3.0-0 libncurses5 --no-install-recommends

# Install and use alternate tar to fix issues with docker filesystem
RUN apt-get install -y bsdtar && ln -sf $(which bsdtar) $(which tar)

# Create links in ONE RUN
RUN set -xue && \
  installPath=${TRUESTUDIO_INSTALL_PATH} && \
  echo 'PATH="$PATH:'"${installPath}"'/ARMTools/bin:'"${installPath}"'/PCTools/bin"' >> /etc/bash.bashrc && \
  ln -s "${installPath}/ide/TrueSTUDIO" /usr/bin/ && \
  echo -ne '#!/bin/sh\ncd '"${installPath}"'/ide\nexec ./headless.sh "$@"\n' > /usr/bin/headless.sh && \
  chmod +x /usr/bin/headless.sh

# install in the second RUN
RUN set -xue && \
  f=$(basename ${TRUESTUDIO_URL}) && \
  tar xzfvp $f && \
  installPath=${TRUESTUDIO_INSTALL_PATH} && \
  scriptPath=$(basename ${TRUESTUDIO_INSTALL_PATH})_installer && \
  cp ${scriptPath}/license.txt /ATOLLIC-END-USER-SOFTWARE-LICENSE-AGREEMENT && \
  mkdir -p ${installPath} && \
  tar xzvfp ${scriptPath}/install.data -C ${installPath} && \
  rm $f && rm -r ${scriptPath}