import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCameraController();
    }
  }

  @override
  void initState() {
    super.initState();
    _setupCameraController();
    WidgetsBinding.instance.addObserver(
      this,
    ); // Add the observer to listen for app lifecycle changes
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(
      this,
    ); // Remove observer to avoid memory leaks
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        largeTitle: Text("Home"),
        transitionBetweenRoutes: true,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                _CameraUI(),
                Text('data'),
                IconButton(
                  onPressed: () async {},
                  icon: Icon(CupertinoIcons.video_camera),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _CameraUI() {
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(child: CupertinoActivityIndicator());
    }

    return SafeArea(
      child: SizedBox.expand(
        /// Updated to correctly access screen height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.30,
              width: MediaQuery.sizeOf(context).width * 0.80,
              child: CameraPreview(cameraController!),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setupCameraController() async {
    try {
      List<CameraDescription> _cameras = await availableCameras();

      if (_cameras.isNotEmpty) {
        setState(() {
          cameras = _cameras;
          cameraController = CameraController(
            _cameras.first,
            ResolutionPreset.high,
          );
        });

        await cameraController
            ?.initialize(); // Use await here to ensure proper initialization
        setState(() {});
      }
    } catch (e) {
      print("Error setting up the camera: $e");
    }
  }
}
