import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'package:flutter_tts/flutter_tts.dart';

typedef void Callback(List<dynamic> list, int h, int w);

Future<void> getCamera() async {
  final cameras = await availableCameras();
}

class CameraFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;

  CameraFeed(this.cameras, this.setRecognitions);

  @override
  _CameraFeedState createState() => new _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  CameraController? controller;
  bool isDetecting = false;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    //  print(widget.cameras);
    /*if (false) {
      print('No Cameras Found.');
    } else {*/
    controller = new CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
    );
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});

      controller!.startImageStream((CameraImage img) {
        if (!isDetecting) {
          isDetecting = true;
          Tflite.detectObjectOnFrame(
            bytesList: img.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            model: "SSDMobileNet",
            imageHeight: img.height,
            imageWidth: img.width,
            imageMean: 127.5,
            imageStd: 127.5,
            numResultsPerClass: 1,
            threshold: 0.6,
          ).then((recognitions) {
            widget.setRecognitions(recognitions!, img.height, img.width);
            isDetecting = false;
          });
        }
      });
    });
    //   }
  }

  void playColorName(String colorName) async {
    await flutterTts.speak(colorName);
  }

  void stopR() async {
    await flutterTts.stop();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    Size? tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller!.value.previewSize;
    var previewH = math.max(tmp!.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller!),
    );
  }
}
