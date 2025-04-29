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
  bool _isSaving = false; // <-- New
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
      _setupCameraController();
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

    try {
      await cameraController!.startVideoRecording();
      setState(() => _isRecording = true);
    } catch (e) {
      print("Error starting video recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo)
      return;

    setState(() => _isSaving = true); // <-- Show saving indicator
    try {
      final XFile videoFile = await cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _recordedVideo = videoFile;
      });

      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Video saved: ${_recordedVideo?.path}')),
      //   );
      print('Video saved at: ${_recordedVideo?.path}');
      //   }
    } catch (e) {
      print('Error stopping video recording: $e');
      setState(() => _isRecording = false);
    } finally {
      setState(() => _isSaving = false); // <-- Hide saving indicator
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Video Recorder"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CameraPreviewWidget(),
              const SizedBox(height: 24),
              _recordButton(),
              const SizedBox(height: 16),
              _RecordingStatus(),
              const SizedBox(height: 24),
              if (_isSaving)
                const CupertinoActivityIndicator(radius: 15), // Saving spinner
              if (_recordedVideo != null && !_isSaving) _LastVideoInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _CameraPreviewWidget() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(child: CupertinoActivityIndicator());
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        child: CameraPreview(cameraController!),
      ),
    );
  }

  Widget _recordButton() {
    return GestureDetector(
      onTap: _isRecording ? _stopRecording : _startRecording,
      child: Icon(
        _isRecording
            ? CupertinoIcons.stop_circle
            : CupertinoIcons.videocam_circle,
        size: 80,
        color: _isRecording ? Colors.redAccent : null,
      ),
    );
  }

  Widget _RecordingStatus() {
    return Text(
      _isRecording ? 'Recording...' : 'Tap to Start Recording',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _isRecording ? Colors.red : CupertinoColors.activeBlue,
      ),
    );
  }

  Widget _LastVideoInfo() {
    return Column(
      children: [
        const Text(
          "Last Recorded Video:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _recordedVideo!.path.split('/').last,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
