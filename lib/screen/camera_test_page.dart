import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraTestPage extends StatefulWidget {
  static final String path = "/cameraTest";

  @override
  _CameraTestPageState createState() => _CameraTestPageState();
}

class _CameraTestPageState extends State<CameraTestPage> {

  CameraController _cameraController;
  Future<void> _initializeControllerFuture;

//  bool showCamera = false;
//  Widget _cameraPreviewWidget;

  void _initialCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(firstCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController.initialize();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _initialCamera();

  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    if (showCamera) {
//      _cameraPreviewWidget =
//    }
    return Scaffold(
      appBar: AppBar(
        title: Text("相机测试"),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png'
            );
            await _cameraController.takePicture(path);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => _DisplayPictureScreen(path)));
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}

class _DisplayPictureScreen extends StatelessWidget {
  final String picturePath;

  _DisplayPictureScreen(this.picturePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("图片展示"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(picturePath),
          ),
          Expanded(
            child: Image.file(File(picturePath)),
          )
        ],
      ),
    );
  }

}