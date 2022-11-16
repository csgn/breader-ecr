import json

from cgi import parse_header, parse_multipart
from io import BytesIO

from barcode import BarcodeDetector


def handler(event, context):
    print("REQUEST IS RECEIVED")
    content_type = event['headers'].get('Content-Type', '') or event['headers'].get('content-type', '')
    c_type, c_data = parse_header(content_type)
    c_data["boundary"] = bytes(c_data["boundary"], "utf-8")
    body_file = BytesIO(bytes(event["body"], "utf-8"))
    form_data = parse_multipart(body_file, c_data)

    file = form_data['file'][0]

    res = None
    if not file:
        res = { "error": "file is not specified." }
    else:
        res = BarcodeDetector.decode(file)

    return {
        'statusCode': 200,
        'body': res
    }
