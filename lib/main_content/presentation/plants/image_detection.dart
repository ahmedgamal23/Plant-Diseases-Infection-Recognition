import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

class ImageDetection extends StatefulWidget {
  const ImageDetection({super.key});

  @override
  State<ImageDetection> createState() => _ImageDetectionState();
}

class _ImageDetectionState extends State<ImageDetection> {
  List<String> classesName = [
    'Apple Scab Leaf', 'Apple leaf', 'Apple rust leaf', 'Bell_pepper leaf', 'Bell_pepper leaf spot',
    'Blueberry leaf', 'Cherry leaf', 'Corn Gray leaf spot', 'Corn leaf blight', 'Corn rust leaf', 'Peach leaf', 'Potato leaf',
    'Potato leaf early blight', 'Potato leaf late blight', 'Raspberry leaf', 'Soyabean leaf', 'Soybean leaf', 'Squash Powdery mildew leaf',
    'Strawberry leaf', 'Tomato Early blight leaf', 'Tomato Septoria leaf spot', 'Tomato leaf', 'Tomato leaf bacterial spot',
    'Tomato leaf late blight', 'Tomato leaf mosaic virus', 'Tomato leaf yellow virus', 'Tomato mold leaf', 'Tomato two spotted spider mites leaf',
    'cercospora', 'eyespot', 'grape leaf', 'grape leaf black rot', 'healthy', 'redrot', 'wheat rust', 'yellow leaf'
  ];
  Uint8List? _imageBytes;
  List<dynamic> _detectionResults = [];
  bool _isLoading = false;
  String? _error;
  ui.Image? _image;

  String getClassLabel(int classIndex) {
    if (classIndex >= 0 && classIndex < classesName.length) {
      return classesName[classIndex];
    } else {
      return 'Unknown';
    }
  }

  Future<void> _loadImage(Uint8List bytes) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (result) {
      completer.complete(result);
    });
    _image = await completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showImageSourceDialog(context),
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : _imageBytes != null
                ? Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (_image == null) {
                    return const SizedBox.shrink();
                  }
                  final screenScaleX = constraints.maxWidth / _image!.width;
                  final screenScaleY = constraints.maxHeight / _image!.height;

                  return Stack(
                    children: [
                      Image.memory(
                        _imageBytes!,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        fit: BoxFit.contain,
                      ),
                      ..._detectionResults.map((result) {
                        final bbox = result['bbox'];

                        final left = bbox[0] * screenScaleX;
                        final top = bbox[1] * screenScaleY;
                        final width = (bbox[2] - bbox[0]) * screenScaleX;
                        final height = (bbox[3] - bbox[1]) * screenScaleY;

                        return Positioned(
                          left: left,
                          top: top,
                          width: width,
                          height: height,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 2),
                            ),
                            child: Text(
                              '${getClassLabel(result['class'])} (${(result['confidence'] * 100).toStringAsFixed(2)}%)',
                              style: const TextStyle(
                                backgroundColor: Colors.red,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            )
                : const Text('Image and results will be displayed here'),
            if (_error != null) ...[
              const SizedBox(height: 20),
              Text(
                'Error: $_error',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image == null) {
      setState(() {
        _isLoading = false;
        _error = 'No image selected';
      });
      return;
    }

    final bytes = await image.readAsBytes();
    await _loadImage(bytes);

    final uri = Uri.parse('http://192.168.1.11:5000/detect');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes('image', bytes, filename: 'image.jpg'));

    try {
      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final result = jsonDecode(utf8.decode(responseData));

      if (response.statusCode == 200) {
        setState(() {
          _imageBytes = bytes;
          _detectionResults = result['detections'];
          _error = null;
        });
      } else {
        setState(() {
          _error = result['error'] ?? 'Unknown error occurred';
        });
      }

      // Process the result
      print("************************");
      print(result);
      print("************************");
    } catch (error) {
      // Handle error
      setState(() {
        _error = 'Error: $error';
      });
      print("Error: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

}
