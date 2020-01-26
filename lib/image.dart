import 'dart:async';
import 'dart:io';

import 'package:boilermake/main.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' show Context, join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

String instructions;
String filePath;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

Future<CameraDescription> getCamera() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  return firstCamera;
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  Future readFileAsString() async {
    instructions = await getFileData('assets/WaspBite.txt');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Use this Picture?",
              style: GoogleFonts.cabin(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 40,
              ),
            ),
            Image.file(
              File(imagePath),
              height: 400,
            ),
            RaisedButton(
              onPressed: () {
                print("You clicked me");
                readFileAsString();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TestScreen(imagePath: "test")));
              },
              child: Text(
                "Click here for first aid advice",
                style: GoogleFonts.cabin(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
              color: Colors.lightBlue,
            ),
          ],
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class TestScreen extends StatelessWidget {
  final String imagePath;

  const TestScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('Datasets/DisplayImages/WaspBite.jpeg'),
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Text(
                instructions,
                style: GoogleFonts.cabin(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            RaisedButton(
              onPressed: () async {
                final firstcamera = await getCamera();
                //print("Re-routed back to picture screen");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TakePictureScreen(camera: firstcamera)));
              },
              child: Text(
                "Retake picture",
                style: GoogleFonts.cabin(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                ),
              ),
              color: Colors.lightBlue,
            ),
            RaisedButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(title: 'AidFirst')));
              },
              child: Text(
                "Home Screen",
                style: GoogleFonts.cabin(
                  fontWeight: FontWeight.w400,
                  fontSize: 32,
                ),
              ),
              color: Colors.lightBlue,
            ),
          ],
        ),
      ),
    );
  }
}

class FirstAidList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Select the Injury',
      home: Scaffold(
        appBar: AppBar(title: Text('Select the Injury')),
        body: ListBodyLayout(),
      ),
    );
  }
}

class ListBodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _injuryListView(context);
  }
}

Widget _injuryListView(BuildContext context) {
  final injuries = [
    'Ant Bite',
    'Bee Sting',
    'Wasp Bite',
    'First Degree Burn',
    'Second Degree Burn',
    'Third Degree Burn',
    'Mild Cut/Scrape',
    'Deep Cut',
    'Bruise',
    'CPR'
  ];

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  Future readFileAsString() async {
    instructions = await getFileData('assets/WaspBite.txt');
  }

  return ListView.builder(
      itemCount: injuries.length,
      itemBuilder: (context, index) {
        return CupertinoButton(
          padding: EdgeInsets.all(7.0),
          child: Container(
            height: 50,
            width: 375,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage("assets/ant.jpg"),
                  fit: BoxFit.cover,
                )),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(
                  left:20,
                ),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      injuries[index],
                      style: GoogleFonts.bangers(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    )),
              ),
            ),
          ),
          onPressed: () async {
            readFileAsString();
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => TestScreen2(imagePath: "test"),
                ));
          },
        );
      });
}

class TestScreen2 extends StatelessWidget {
  final String imagePath;

  const TestScreen2({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('Datasets/DisplayImages/WaspBite.jpeg'),
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                instructions,
                style: GoogleFonts.cabin(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
