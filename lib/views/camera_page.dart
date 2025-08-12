import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pry_traffic_signs/components/roundedbutton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with SingleTickerProviderStateMixin {
  List? _recognitions;
  late AnimationController controller;
  late Animation animation;

  File? imageURI;
  String? result;
  String? path;
  final ImagePicker _picker = ImagePicker();

  Interpreter? _interpreter;
  List<String>? _labels;

  Future getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        imageURI = File(image.path);
        path = image.path;
      });
    }
  }

  Future getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageURI = File(image.path);
        path = image.path;
      });
    }
  }

  Future<void> _loadModel() async {
    try {
      print('Loading model from assets/tf_lite_model.tflite...');
      _interpreter = await Interpreter.fromAsset('assets/tf_lite_model.tflite');
      print('Model loaded successfully');
      print('Input shape: ${_interpreter!.getInputTensors()}');
      print('Output shape: ${_interpreter!.getOutputTensors()}');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> _loadLabels() async {
    try {
      print('Loading labels from assets/labels.txt...');
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData
          .split('\n')
          .map((label) => label.trim())
          .where((label) => label.isNotEmpty)
          .toList();
      print('Labels loaded successfully: ${_labels?.length} labels');
      print('First few labels: ${_labels?.take(5)}');
    } catch (e) {
      print('Error loading labels: $e');
    }
  }

  Future classifyImage() async {
    print('Starting classification...');
    print('Path: $path');
    print('Interpreter loaded: ${_interpreter != null}');
    print('Labels loaded: ${_labels != null}');
    print('Labels count: ${_labels?.length}');

    if (path == null) {
      setState(() {
        _recognitions = [
          {'label': 'No image selected', 'confidence': 0.0},
        ];
      });
      return;
    }

    if (_interpreter == null) {
      setState(() {
        _recognitions = [
          {
            'label': 'Model not loaded - check assets/tf_lite_model.tflite',
            'confidence': 0.0,
          },
        ];
      });
      return;
    }

    if (_labels == null || _labels!.isEmpty) {
      setState(() {
        _recognitions = [
          {
            'label': 'Labels not loaded - check assets/labels.txt',
            'confidence': 0.0,
          },
        ];
      });
      return;
    }

    try {
      print('Loading and preprocessing image...');
      // Load and preprocess the image
      final imageFile = File(path!);
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        setState(() {
          _recognitions = [
            {'label': 'Could not decode image', 'confidence': 0.0},
          ];
        });
        return;
      }

      print('Image decoded successfully: ${image.width}x${image.height}');

      // Resize image to model input size - the model expects 224x224x3
      final resized = img.copyResize(image, width: 224, height: 224);
      print('Image resized to: 224x224');

      // Convert to input tensor format
      final input = _imageToByteListFloat32(resized, 224, 0.0, 255.0);
      print('Input tensor prepared');

      // Create output tensor to match model output: [32, 43]
      final output = List.generate(
        32, // batch size matching model expectation
        (index) => List.filled(_labels!.length, 0.0),
      );
      print(
        'Output tensor created for 32 batches x ${_labels!.length} classes',
      );

      // Run inference
      print('Running inference...');
      _interpreter!.run(input, output);
      print('Inference completed');

      // Process results - take only the first batch result
      final results = <Map<String, dynamic>>[];
      for (int i = 0; i < _labels!.length; i++) {
        results.add({'label': _labels![i], 'confidence': output[0][i]});
      }

      // Sort by confidence
      results.sort((a, b) => b['confidence'].compareTo(a['confidence']));

      print(
        'Top result: ${results[0]['label']} with confidence ${results[0]['confidence']}',
      );

      setState(() {
        _recognitions = results;
      });
    } catch (e) {
      print('Error during classification: $e');
      setState(() {
        _recognitions = [
          {'label': 'Classification error: $e', 'confidence': 0.0},
        ];
      });
    }
  }

  List<List<List<List<double>>>> _imageToByteListFloat32(
    img.Image image,
    int inputSize,
    double mean,
    double std,
  ) {
    print('Converting image to tensor format...');
    print('Input size: $inputSize, Mean: $mean, Std: $std');

    // Create a 4D tensor matching model input: [32, 224, 224, 3]
    // We'll fill only the first batch item and leave the rest as zeros
    var input = List.generate(
      32, // batch size as expected by the model
      (i) => List.generate(
        inputSize,
        (j) => List.generate(inputSize, (k) => List.filled(3, 0.0)),
      ),
    );

    // Fill only the first batch item with our image data
    for (int i = 0; i < inputSize; i++) {
      for (int j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);

        // Normalize pixel values to [0, 1] range
        input[0][i][j][0] = pixel.r.toDouble() / std;
        input[0][i][j][1] = pixel.g.toDouble() / std;
        input[0][i][j][2] = pixel.b.toDouble() / std;
      }
    }

    print(
      'Image conversion completed. Tensor shape: [32, $inputSize, $inputSize, 3]',
    );
    return input;
  }

  @override
  void initState() {
    super.initState();

    // Initialize animation first
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      upperBound: 0.6,
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();
    controller.addListener(() {
      setState(() {});
    });

    // Load model and labels asynchronously
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    print('Starting model initialization...');
    await _loadModel();
    await _loadLabels();

    if (_interpreter != null && _labels != null) {
      print('Model and labels loaded successfully!');
    } else {
      print('Failed to load model or labels');
      print('Interpreter: ${_interpreter != null}');
      print('Labels: ${_labels != null}');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //        title: Text(
        ////          widget.title,
        ////          style: GoogleFonts.lato(
        ////              fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: 0.75),
        //            ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 300,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Traffic Sign Classifier',
                        textStyle: GoogleFonts.lato(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.75,
                        ),
                        colors: [Colors.green, Colors.yellow, Colors.red],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              imageURI == null
                  ? Hero(
                      tag: 'logo',
                      child: SizedBox(
                        height: animation.value * 400,
                        child: Image.asset('images/trafficsign.png'),
                      ),
                    )
                  : Image.file(
                      imageURI!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
              SizedBox(height: 15),
              RoundedButton(
                text: 'Tomar una foto',
                color: Colors.lightBlueAccent,
                onPress: () {
                  getImageFromCamera();
                },
              ),
              RoundedButton(
                text: 'Seleccionar de la galeria',
                color: Colors.lightBlueAccent,
                onPress: () {
                  getImageFromGallery();
                  //                initGalleryPickUp();
                },
              ),
              RoundedButton(
                text: 'Clasificar',
                color: Colors.blue,
                onPress: () {
                  classifyImage();
                },
              ),
              SizedBox(height: 7),
              _recognitions == null
                  ? Text(
                      'Recuerda usar las imágenes con cuidado para obtener resultados correctos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  : Text(
                      _recognitions![0]['label'].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
