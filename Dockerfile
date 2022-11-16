#ARG FUNCTION_DIR="/home/app"
ARG RUNTIME_VERSION="3.9"
# ARG DISTRO_VERSION="3.12"

# FROM python:${RUNTIME_VERSION}-alpine${DISTRO_VERSION} as python-alpine
FROM public.ecr.aws/lambda/python:${RUNTIME_VERSION} AS build-image

# RUN apk add --no-cache libstdc++

#FROM lambda-py AS build-image

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
    libcurl-devel 
    # musl-devel \
    # g++ \

# RUN apk add zbar-dev --update-cache --repository \
#     http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted


#ARG FUNCTION_DIR
# ARG RUNTIME_VERSION

#RUN mkdir -p ${FUNCTION_DIR}


COPY app.py barcode.py requirements.txt ${LAMBDA_TASK_ROOT}/

RUN python${RUNTIME_VERSION} -m pip install --target ${LAMBDA_TASK_ROOT} awslambdaric
RUN python${RUNTIME_VERSION} -m pip install -r ${LAMBDA_TASK_ROOT}/requirements.txt --target ${LAMBDA_TASK_ROOT}

FROM public.ecr.aws/lambda/python:${RUNTIME_VERSION}

ARG FUNCTION_DIR

#WORKDIR ${LAMBDA_TASK_ROOT}

COPY --from=build-image ${LAMBDA_TASK_ROOT} ${LAMBDA_TASK_ROOT}
# ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/bin/aws-lambda-rie
# COPY entry.sh /
# RUN chmod 755 /usr/bin/aws-lambda-rie /entry.sh
#
# ENTRYPOINT [ "/entry.sh" ]

ENTRYPOINT [ "/var/lang/bin/python", "-m", "awslambdaric" ]
CMD [ "app.handler" ]
