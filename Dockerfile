ARG FUNCTION_DIR="/home/app"
ARG RUNTIME_VERSION="3.9"
# ARG DISTRO_VERSION="3.12"

# FROM python:${RUNTIME_VERSION}-alpine${DISTRO_VERSION} as python-alpine
FROM amazon/aws-lambda-python:${RUNTIME_VERSION} AS lambda-py

# RUN apk add --no-cache libstdc++

FROM lambda-py AS build-image

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

RUN yum makecache

RUN yum install -y \
    zbar \
    zbar-devel \
    autoconf \
    libffi-devel \
    gmp-devel \
    libxslt-devel \
    libjpeg-devel \
    zlib-devel \
    libtool \
    autoconf \
    libexif-devel \
    make \
    cmake \
    unzip \
    libcurl-devel 
    # musl-devel \
    # g++ \

# RUN apk add zbar-dev --update-cache --repository \
#     http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted


ARG FUNCTION_DIR
# ARG RUNTIME_VERSION

WORKDIR ${FUNCTION_DIR}

COPY app.py barcode.py requirements.txt ./

RUN python${RUNTIME_VERSION} -m pip install -r requirements.txt --target ./
RUN python${RUNTIME_VERSION} -m pip install awslambdaric --target ./

FROM lambda-py

COPY --from=build-image ./ ./
ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/bin/aws-lambda-rie
COPY entry.sh /
RUN chmod 755 /usr/bin/aws-lambda-rie /entry.sh

ENTRYPOINT [ "/entry.sh" ]

CMD [ "app.handler" ]
