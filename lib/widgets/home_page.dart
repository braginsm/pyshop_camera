import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pyshop_camera/models/photo.dart';
import 'package:pyshop_camera/resources/strings.dart';
import 'package:pyshop_camera/services/photo_send_service.dart';
import 'package:pyshop_camera/services/position_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController? cameraController;
  bool isLoading = true;
  late TextEditingController textController;
  late PhotoSendService photoSendService;
  late PositionService positionService;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    photoSendService = GetIt.I<PhotoSendService>();
    positionService = GetIt.I<PositionService>();
    initCameraController();
  }

  void takePicture() async {
    setState(() {
      isLoading = true;
    });
    final picture = await cameraController?.takePicture();
    if (picture != null) {
      final location = await positionService.getCurrentPosition();
      final photo = Photo(
        comment: textController.text,
        point: (latitude: location.latitude, longitude: location.latitude),
        filePath: picture.path,
      );
      await photoSendService.send(photo);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> initCameraController() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }
    cameraController = CameraController(cameras.first, ResolutionPreset.max);
    await cameraController?.initialize();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: cameraController == null || isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: CameraPreview(cameraController!),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(controller: textController),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: takePicture,
        tooltip: Strings.takePicture,
        child: const Icon(Icons.photo_camera),
      ),
    );
  }
}
