import io
import numpy as np

from PIL import Image
from pyzbar.pyzbar import decode

class BarcodeDetector:
    @staticmethod
    def decode(file):
        stream = None
        x = None
        x = np.fromstring(file, np.uint8)

        if not x.any():
            return {"error": "file is corrupted"}

        stream = io.BytesIO(x)
        converted_file = Image.open(stream)
        res = decode(converted_file)

        if res[0]:
            return {"data": res[0].data.decode('utf-8')}

        return {"error": "file is corrupted"}
