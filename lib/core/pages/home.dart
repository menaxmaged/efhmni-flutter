import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  bool _isRecording = false;
  XFile? _recordedVideo;

  @override
  void initState() {
    super.initState();
    _setupCameraController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (cameraController == null) {
        _setupCameraController();
      }
    }
  }

  Future<void> _setupCameraController() async {
    try {
      final _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        cameraController = CameraController(
          _cameras.first,
          ResolutionPreset.high,
        );
        await cameraController!.initialize();
        setState(() {
          cameras = _cameras;
        });
      }
    } catch (e) {
      print("Error setting up the camera: $e");
    }
  }

  Future<void> _startRecording() async {
    if (cameraController == null || !cameraController!.value.isInitialized)
      return;
    await cameraController!.startVideoRecording();
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo)
      return;
    final XFile videoFile = await cameraController!.stopVideoRecording();
    setState(() {
      _isRecording = false;
      _recordedVideo = videoFile;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video saved: ${_recordedVideo?.path}')),
      );
      print('Video saved at: ${_recordedVideo?.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Home"),
        transitionBetweenRoutes: true,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _CameraUI(),
                const SizedBox(height: 20),
                Text(_isRecording ? 'Recording...' : 'Press to Record'),
                IconButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  icon: Icon(
                    _isRecording
                        ? CupertinoIcons.stop_circle
                        : CupertinoIcons.video_camera,
                    size: 40,
                  ),
                ),
                if (_recordedVideo != null) ...[
                  const SizedBox(height: 20),
                  Text('Last Video: ${_recordedVideo!.path.split('/').last}'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _CameraUI() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(child: CupertinoActivityIndicator());
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      child: CameraPreview(cameraController!),
    );
  }
}
