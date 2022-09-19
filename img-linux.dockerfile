#
# Container Image Autopilot Consul
#

ARG CONSUL_IMG

FROM ${CONSUL_IMG}

ARG PROJ_NAME
ARG PROJ_VERSION
ARG PROJ_BUILD_NUM
ARG PROJ_BUILD_DATE
ARG PROJ_REPO
ARG CONTAINERPILOT_VERSION

LABEL org.opencontainers.image.authors="V10 Solutions"
LABEL org.opencontainers.image.title="${PROJ_NAME}"
LABEL org.opencontainers.image.version="${PROJ_VERSION}"
LABEL org.opencontainers.image.revision="${PROJ_BUILD_NUM}"
LABEL org.opencontainers.image.created="${PROJ_BUILD_DATE}"
LABEL org.opencontainers.image.description="Container image for Consul designed to be self-operating according to the autopilot pattern"
LABEL org.opencontainers.image.source="${PROJ_REPO}"

RUN apk add --no-cache "doas"

WORKDIR "/tmp"

RUN curl -L -f -o "containerpilot.tar.gz" "https://github.com/tritondatacenter/containerpilot/releases/download/${CONTAINERPILOT_VERSION}/containerpilot-${CONTAINERPILOT_VERSION}.tar.gz" \
	&& tar -x -f "containerpilot.tar.gz" \
	&& chmod "755" "containerpilot" \
	&& mv "containerpilot" "/usr/local/bin/" \
	&& rm "containerpilot.tar.gz"

WORKDIR "/usr/local"

RUN mkdir -p "etc/containerpilot" \
	&& folders=("var/run/containerpilot") \
	&& for folder in "${folders[@]}"; do \
		mkdir -p "${folder}" \
		&& chmod "700" "${folder}" \
		&& chown -R "0":"0" "${folder}"; \
	done

WORKDIR "/"
