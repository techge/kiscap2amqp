# TODO can it be done with Alpine Linux?
FROM debian:buster-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libcap-dev \
    libnl-3-dev \
    libnl-genl-3-dev \
    libnm-dev \
    libpcap-dev \
    librabbitmq-dev \
    pkg-config

COPY . .

RUN ./configure

RUN make

ENTRYPOINT [ "./capture_linux_wifi/kiscap2amqp_linux_wifi" ]
