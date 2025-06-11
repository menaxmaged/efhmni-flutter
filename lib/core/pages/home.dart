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
  CameraController? cameraController;
  bool _isRecording = false;
  bool _isSaving = false;
  bool _isUploading = false;
  XFile? _recordedVideo;
  XFile? _capturedImage;
  String? _errorMessage;
  String? _translatedWord;
  String? _translatedImageWord;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupCameraController(_selectedCameraIndex);
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
      _setupCameraController(_selectedCameraIndex);
    }
  }

  Future<void> _setupCameraController(int cameraIndex) async {
    try {
      final _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        setState(() => _errorMessage = "No camera available.");
        return;
      }
      cameraController = CameraController(
        _cameras[cameraIndex],
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await cameraController!.initialize();
      if (!mounted) return;
      setState(() {
        _errorMessage = null;
      });
    } catch (e) {
      _showError("Error initializing camera: $e");
    }
  }

  Future<void> _startRecording() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      _showError("Camera not ready.");
      return;
    }

    try {
      await cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _errorMessage = null;
      });
    } catch (e) {
      _showError("Error starting recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      _showError("No recording in progress.");
      return;
    }

    setState(() {
      _isSaving = true;
    });
    try {
      final XFile videoFile = await cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _recordedVideo = videoFile;
        _errorMessage = null;
      });
      print('Video saved at: ${_recordedVideo?.path}');
    } catch (e) {
      _showError("Error stopping recording: $e");
      setState(() => _isRecording = false);
    } finally {
      setState(() => _isSaving = false);
    }
    setState(() => _isUploading = true);

    try {
      String translation = await ApiHandler.uploadVideo(
        filePath: _recordedVideo!.path,
      );
      setState(() {
        _isUploading = false;
        _translatedWord = translation;
      });
    } catch (e) {
      _showError("Error uploading video: $e");
    }
  }

  Future<void> _takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      _showError("Camera not ready.");
      return;
    }

    setState(() => _isSaving = true);

    try {
      final XFile imageFile = await cameraController!.takePicture();
      setState(() {
        _capturedImage = imageFile;
        _errorMessage = null;
      });
      print('Image saved at: ${_capturedImage?.path}');

      setState(() => _isUploading = true);

      String translation = await ApiHandler.uploadImage(
        filePath: _capturedImage!.path,
      );
      //String translation = 'test';
      setState(() {
        _isUploading = false;
        _translatedImageWord = translation;
      });
    } catch (e) {
      _showError("Error taking picture: $e");
      setState(() => _isUploading = false);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() => _errorMessage = message);

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar.large(
        largeTitle: Text("Camera & Video"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CameraPreviewWidget(),
              const SizedBox(height: 24),
              Row(
                mainAxisSize:
                    MainAxisSize.min, // <- important to shrink row to content
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Switch Button
                  CupertinoButton(
                    padding: EdgeInsets.all(10),
                    color: CupertinoColors.systemGrey5,
                    borderRadius: BorderRadius.circular(30),
                    child: Icon(CupertinoIcons.camera_rotate, size: 28),
                    onPressed: () async {
                      _selectedCameraIndex = _selectedCameraIndex == 1 ? 0 : 1;
                      await _setupCameraController(_selectedCameraIndex);
                    },
                  ),

                  const SizedBox(width: 20),

                  // Image Capture Button
                  _imageButton(),

                  const SizedBox(width: 20),

                  // Record Button
                  _recordButton(),
                ],
              ),

              const SizedBox(height: 16),
              _RecordingStatus(),
              const SizedBox(height: 24),
              if (_isSaving || _isUploading)
                const CupertinoActivityIndicator(radius: 15),
              if ((_recordedVideo != null || _capturedImage != null) &&
                  !_isSaving &&
                  !_isUploading)
                _Translation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _CameraPreviewWidget() {
    if (_errorMessage != null &&
        (cameraController == null || !cameraController!.value.isInitialized)) {
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
        child: AspectRatio(
          aspectRatio: cameraController!.value.aspectRatio,
          child: CameraPreview(cameraController!),
        ),
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

  Widget _imageButton() {
    return GestureDetector(
      onTap: _isSaving ? null : _takePicture,
      child: Icon(
        CupertinoIcons.camera_circle,
        size: 80,
        color:
            _isSaving ? CupertinoColors.systemGrey : CupertinoColors.activeBlue,
      ),
    );
  }

  Widget _RecordingStatus() {
    return Column(
      children: [
        if (_isRecording)
          Text(
            'Recording Video...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          )
        else if (_isSaving)
          Text(
            'Processing...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemOrange,
            ),
          )
        else
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ],
          ),
      ],
    );
  }

  Widget _Translation() {
    return Column(
      children: [
        SizedBox(height: 8),
        if (_translatedWord != null)
          Column(
            children: [
              Text(
                "Video Translation:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.systemBlue,
                ),
              ),
              Text(
                _translatedWord!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
            ],
          ),
        if (_translatedImageWord != null)
          Column(
            children: [
              Text(
                "Image Translation:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.systemGreen,
                ),
              ),
              Text(
                _translatedImageWord!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
            ],
          ),
      ],
    );
  }
}
