import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_tts/flutter_tts.dart';

class BoundingBox extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  FlutterTts flutterTts = FlutterTts();
  Map<String, String> translated = {
    'person': 'personne',
    'bicycle': 'velo',
    'car': 'voiture',
    'motorcycle': 'moto',
    'airplane': 'avion',
    'bus': 'bus',
    'train': 'train',
    'truck': 'truck',
    'boat': 'bateau',
    'traffic': 'traffic',
    'light': 'lumiere',
    'fire': 'feu',
    'hydrant': 'hydrant',
    'stop': 'stop',
    'sign': 'signe',
    'parking': 'parking',
    'meter': 'metre',
    'bench': 'banc'
    // bird
    // cat
    // dog
    // horse
    // sheep
    // cow
    // elephant
    // bear
    // zebra
    // giraffe
    // ???
    // backpack
    // umbrella
    // ???
    // ???
    // handbag
    // tie
    // suitcase
    // frisbee
    // skis
    // snowboard
    // sports ball
    // kite
    // baseball bat
    // baseball glove
    // skateboard
    // surfboard
    // tennis racket
    // bottle
    // ???
    // wine glass
    // cup
    // fork
    // knife
    // spoon
    // bowl
    // banana
    // apple
    // sandwich
    // orange
    // broccoli
    // carrot
    // hot dog
    // pizza
    // donut
    // cake
    // chair
    // couch
    // potted plant
    // bed
    // ???
    // dining table
    // ???
    // ???
    // toilet
    // ???
    // tv
    // laptop
    // mouse
    // remote
    // keyboard
    // cell phone
    // microwave
    // oven
    // toaster
    // sink
    // refrigerator
    // ???
    // book
    // clock
    // vase
    // scissors
    // teddy bear
    // hair drier
    // toothbrush'}
  };

  BoundingBox(
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW,
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderBox() {
      return results.map((re) {
        var _x = re["rect"]["x"];
        var _w = re["rect"]["w"];
        var _y = re["rect"]["y"];
        var _h = re["rect"]["h"];
        if (re['confidenceInClass'] > 0.65) {
          playColorName(
              'une ' + re['detectedClass'] + ' approche ,faites attention!');
        }
        var scaleW, scaleH, x, y, w, h;

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;

          var difW = (scaleW - screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
        }

        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Container(
            padding: EdgeInsets.only(top: 5.0, left: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(37, 213, 253, 1.0),
                width: 3.0,
              ),
            ),
            child: Text(
              "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                color: Color.fromRGBO(37, 213, 253, 1.0),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList();
    }

    return Stack(
      children: _renderBox(),
    );
  }

  void playColorName(String colorName) async {
    await flutterTts.speak(colorName);
    sleep(Duration(seconds: 2));
  }

  void stopR() async {
    await flutterTts.stop();
  }
}
