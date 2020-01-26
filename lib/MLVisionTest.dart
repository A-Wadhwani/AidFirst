import 'package:firebase_livestream_ml_vision/firebase_livestream_ml_vision.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: _MyHomePage()));

class _MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  FirebaseVision _vision;
  dynamic _scanResults;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    List<FirebaseCameraDescription> cameras = await camerasAvailable();
    _vision = FirebaseVision(cameras[0], ResolutionSetting.high);
    _vision.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }
  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        FirebaseCameraPreview(_vision),
        //_buildResults(),                //   <---------------------------- NO CLUE WHAT THIS IS?????
      ],
    ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildImage(),
    );
  }

  void dispose() {
    _vision.dispose().then((_) {
      // close all detectors
    });

    super.dispose();
  }
}