import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mini/screen/realtime/bounding_box.dart';
import 'package:mini/screen/realtime/camera.dart';

import 'dart:math' as math;
import 'package:tflite/tflite.dart';

class LiveFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  LiveFeed(this.cameras);
  @override
  _LiveFeedState createState() => _LiveFeedState();
}

class _LiveFeedState extends State<LiveFeed> {
  List<dynamic> _recognitions=[];
  int _imageHeight = 0;
  int _imageWidth = 0;
  initCameras() async {
    final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    widget.cameras.add(firstCamera);
    _recognitions.add(firstCamera);
  }
  loadTfModel() async {
    await Tflite.loadModel(
      model: "assets/models/ssd_mobilenet.tflite",
      labels: "assets/models/labels.txt",
    );
  }
  /* 
  The set recognitions function assigns the values of recognitions, imageHeight and width to the variables defined here as callback
  */
  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  void initState() { 
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
initCameras();
    loadTfModel();
  }


  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: new Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Real-Time Object Detection',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromRGBO(67, 236, 227, 1),

            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(6, 30, 69, 1),
        shadowColor: Color.fromRGBO(128, 45, 83, 1),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: Color.fromRGBO(67, 236, 227, 1),
          iconSize: 37,
        ),

        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              size: 35,
              color: Color.fromRGBO(6, 30, 69, 1),
            ),
            onPressed: () {

            },
          ),
        ],      ),
      body: Stack(
        children: <Widget>[
          CameraFeed(widget.cameras, setRecognitions),
          BoundingBox(
            _recognitions,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
          ),
        ],
      ),
    );
  }
}