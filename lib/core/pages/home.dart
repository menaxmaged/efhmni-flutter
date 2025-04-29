import 'dart:developer';

import 'package:efhmni/core/utils/api-handler.dart';
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
  bool _isSaving = false;
  XFile? _recordedVideo;
  String? _errorMessage;

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
    if (cameraController == null || !cameraController!.value.isInitialized)
      return;

    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCameraController();
    }
  }

  Future<void> _setupCameraController() async {
    try {
      final _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _errorMessage = "No camera available.");
        return;
      }
      cameraController = CameraController(
        _cameras.first,
        ResolutionPreset.high,
        imageFormatGroup:
            ImageFormatGroup.yuv420, // <--- Force compatible format
      );
      await cameraController!.initialize();
      if (!mounted) return;
      setState(() {
        cameras = _cameras;
        _errorMessage = null;
      });
    } catch (e) {
      print("Error setting up the camera: $e");
      setState(() => _errorMessage = "Error initializing camera: $e");
    }
  }

  Future<void> _startRecording() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      _showError("Camera not ready.");
      return;
    }

    try {
      await cameraController!.startVideoRecording();
      setState(() => _isRecording = true);
    } catch (e) {
      _showError("Error starting recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      _showError("No recording in progress.");
      return;
    }

    setState(() => _isSaving = true);
    try {
      final XFile videoFile = await cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _recordedVideo = videoFile;
      });
      print('Video saved at: ${_recordedVideo?.path}');
    } catch (e) {
      _showError("Error stopping recording: $e");
      setState(() => _isRecording = false);
    } finally {
      setState(() => _isSaving = false);
    }
    try {
      await ApiHandler.uploadVideo(filePath: _recordedVideo!.path);
    } catch (e) {
      final err = e.toString();
      _showError("Error uploading video: $err");
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() => _errorMessage = message);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar.large(
        largeTitle: Text("Video Recorder"),
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
              if (_isSaving) const CupertinoActivityIndicator(radius: 15),
              if (_recordedVideo != null && !_isSaving) _LastVideoInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _CameraPreviewWidget() {
    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

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
