import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'edit_image.dart';
import 'gallery_screen.dart';

class AddImage extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onImagesSelected;

  const AddImage({Key? key, required this.onImagesSelected}) : super(key: key);

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  List<File> _selectedImages = [];
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(cameras![0], ResolutionPreset.high);
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final XFile image = await _cameraController!.takePicture();
      setState(() {
        _selectedImages.add(File(image.path));
      });
      _navigateToEditImage(_selectedImages);
    }
  }

  Future<void> _openGallery() async {
    final List<File>? selectedImages = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryScreen(),
      ),
    );
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _selectedImages = selectedImages;
      });
      _navigateToEditImage(_selectedImages);
    }
  }

  void _navigateToEditImage(List<File> images) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditImage(
          imageFiles: images,
          onImagesSent: (List<Map<String, dynamic>> selectedImages) {
            widget.onImagesSelected(selectedImages);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _toggleFlash() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      bool newFlashMode = !_isFlashOn;
      await _cameraController!.setFlashMode(newFlashMode ? FlashMode.torch : FlashMode.off);
      setState(() {
        _isFlashOn = newFlashMode;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraInitialized
          ? Stack(
              children: [
                Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: _cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on_outlined : Icons.flash_off_outlined,
                      color: Colors.white,
                    ),
                    onPressed: _toggleFlash,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(120, 0, 0, 0),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.image_outlined, color: Colors.white),
                                onPressed: _openGallery,
                              ),
                            ),
                            GestureDetector(
                              onTap: _captureImage,
                              child: Icon(Icons.circle_outlined, color: Colors.white, size: 40),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(120, 0, 0, 0),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.flip_camera_android_rounded, color: Colors.white),
                                onPressed: () async {
                                  if (cameras != null && cameras!.length > 1) {
                                    final cameraIndex = cameras!.indexOf(_cameraController!.description);
                                    final newCameraIndex = (cameraIndex + 1) % cameras!.length;
                                    _cameraController = CameraController(cameras![newCameraIndex], ResolutionPreset.high);
                                    await _cameraController!.initialize();
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
