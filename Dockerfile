# Dockerfile for Tuya IPC Terminal Add-on
ARG BUILD_FROM
FROM golang:1.24-bookworm AS builder

# Set up environment
ENV LANG=C.UTF-8

# Clone the tuya-ipc-terminal repository and install dependencies
RUN git clone https://github.com/seydx/tuya-ipc-terminal.git /usr/src/app
WORKDIR /usr/src/app
RUN chmod +x build.sh && ./build.sh

FROM ${BUILD_FROM}

COPY --from=builder /usr/src/app/tuya-ipc-terminal /usr/bin/

# Copy run script
COPY run.sh /
COPY tuya_auth_qr.exp /
RUN chmod a+x /run.sh && chmod +x /tuya_auth_qr.exp && chmod a+x /usr/bin/tuya-ipc-terminal

RUN apt-get update && apt-get install -y expect && apt-get clean
RUN mkdir -p /config
WORKDIR /config

# Start the application
CMD [ "/run.sh" ]
