#!/bin/sh
if [ -z "${AWS_LAMBDA_RUNTIME_API}" ]; then
    exec /usr/bin/aws-lambda-rie /var/lang/bin/python3 -m awslambdaric $1
else
    exec /var/lang/bin/python3 -m awslambdaric $1
fi
