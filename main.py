from flask import Flask, request, jsonify
from PIL import Image
import io
from ultralytics import YOLO

app = Flask(__name__)

# Load YOLOv8 model once during initialization
model = YOLO('../best.pt')

@app.route('/detect', methods=['POST'])
def detect():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400

    file = request.files['image']
    try:
        img_bytes = file.read()
        img = Image.open(io.BytesIO(img_bytes))

        # Perform inference
        results = model(img)

        # Process results (convert to JSON serializable format)
        detections = []
        for result in results:
            for box in result.boxes:
                xyxy = box.xyxy.tolist()[0]
                conf = box.conf.tolist()[0]
                cls = box.cls.tolist()[0]
                detections.append({
                    'bbox': [float(coord) for coord in xyxy],
                    'confidence': float(conf),
                    'class': int(cls)
                })

        return jsonify({'detections': detections})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000, threaded=True)
