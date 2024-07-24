import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;

class RealTimeInsectsDetection extends StatefulWidget {
  const RealTimeInsectsDetection({super.key});

  @override
  State<RealTimeInsectsDetection> createState() => _RealTimeInsectsDetection();
}

class _RealTimeInsectsDetection extends State<RealTimeInsectsDetection> {
  List<String> classesName = [
    'Adristyrannus', 'Aleurocanthus spiniferus', 'Ampelophaga', 'Aphis citricola Vander Goot',
    'Apolygus lucorum', 'Bactrocera tsuneonis', 'Ceroplastes rubens', 'Chlumetia transversa', 'Chrysomphalus aonidum',
    'Cicadella viridis', 'Cicadellidae', 'Dacus dorsalis-Hendel-', 'Dasineura sp', 'Deporaus marginatus Pascoe',
    'Erythroneura apicalis', 'Lawana imitata Melichar', 'Limacodidae', 'Lycorma delicatula', 'Mango flat beak leafhopper',
    'Miridae', 'Panonchus citri McGregor', 'Papilio xuthus', 'Parlatoria zizyphus Lucus', 'Phyllocnistis citrella Stainton',
    'Phyllocoptes oleiverus ashmead', 'Pieris canidia', 'Polyphagotars onemus latus', 'Prodenia litura', 'Rhytidodera bowrinii white',
    'Salurnis marginella Guerr', 'Scirtothrips dorsalis Hood', 'Sternochetus frigidus', 'Tetradacus c Bactrocera minax', 'Thrips',
    'Toxoptera aurantii', 'Toxoptera citricidus', 'Trialeurodes vaporariorum', 'Unaspis yanonensis', 'Viteus vitifoliae', 'Xylotrechus',
    'alfalfa seed chalcid', 'blister beetle', 'legume blister beetle', 'odontothrips loti', 'oides decempunctata',
    'parathrene regalis', 'therioaphis maculata Buckton', 'undefined'
  ];

  late CameraController _cameraController;
  List<dynamic> _detectionResults = [];
  bool _isProcessing = false;
  String? _error;
  bool _isCameraInitialized = false;
  int? imgWidth;
  int? imgHeight;

  // Define list of colors for bounding box borders
  List<Color> boundingBoxColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.high);
    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
    _cameraController.startImageStream(_processCameraImage);
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    final WriteBuffer allBytes = WriteBuffer();
    for (var plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final width = image.width;
    final height = image.height;
    imgWidth = width;
    imgHeight = height;

    // Convert to image package format and then to JPEG
    final imageFormat = img.Image.fromBytes(width, height, bytes, format: img.Format.rgb);

    // Encode as JPEG
    final jpegData = Uint8List.fromList(img.encodeJpg(imageFormat));

    final uri = Uri.parse('http://192.168.1.11:4000/detect');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes('image', jpegData, filename: 'image.jpg', contentType: MediaType('image', 'jpeg')));

    try {
      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final result = jsonDecode(utf8.decode(responseData));

      print("******************");
      print(result);
      print("******************");

      if (response.statusCode == 200) {
        setState(() {
          _detectionResults = result['detections'];
          _error = null;
        });
      } else {
        setState(() {
          _error = result['error'] ?? 'Unknown error occurred';
        });
      }
    } catch (error) {
      setState(() {
        _error = 'Error: $error';
      });
      print("Error: $error");
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  String getClassLabel(int classIndex) {
    if (classIndex >= 0 && classIndex < classesName.length) {
      return classesName[classIndex];
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraInitialized
          ? Stack(
        children: [
          CameraPreview(_cameraController),
          LayoutBuilder(
            builder: (context, constraints) {
              final previewSize = constraints.biggest;
              final scale = previewSize.aspectRatio * _cameraController.value.aspectRatio;
              final scaledPreviewSize = Size(previewSize.width, previewSize.height / scale);

              return Stack(
                children: _detectionResults.map((result) {
                  final bbox = result['bbox'];
                  final left = bbox[0] / imgWidth! * previewSize.width;
                  final top = bbox[1] / imgHeight! * previewSize.height;
                  final width = (bbox[2] - bbox[0]) / imgWidth! * previewSize.width;
                  final height = (bbox[3] - bbox[1]) / imgHeight! * previewSize.height;

                  print("BBOX: ${bbox}");
                  print("SCALED BBOX: [left: $left, top: $top, width: $width, height: $height]");

                  final boxColor = boundingBoxColors[result['class'] % boundingBoxColors.length];

                  return Positioned(
                    left: left,
                    top: top,
                    width: width,
                    height: height,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: boxColor, width: 2),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            color: boxColor.withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            child: Text(
                              '${getClassLabel(result['class'])} (${(result['confidence'] * 100).toStringAsFixed(2)}%)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          if (_error != null) ...[
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                'Error: $_error',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}