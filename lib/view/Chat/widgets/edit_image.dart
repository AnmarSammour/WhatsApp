import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp/view/widgets/icon_button.dart';
import 'gallery_screen.dart';

class EditImage extends StatefulWidget {
  final List<File> imageFiles;
  final Function(List<Map<String, dynamic>>) onImagesSent;

  const EditImage(
      {Key? key, required this.imageFiles, required this.onImagesSent})
      : super(key: key);

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  final PageController _pageController = PageController();
  List<TextEditingController> _textControllers = [];
  List<File> _selectedFiles = [];
  List<VideoPlayerController?> _videoControllers = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _selectedFiles = List.from(widget.imageFiles);
    _textControllers = List.generate(
        _selectedFiles.length, (index) => TextEditingController());
    _initializeVideoControllers();
  }

  void _initializeVideoControllers() {
    _videoControllers = _selectedFiles.map((file) {
      if (_isVideo(file)) {
        return VideoPlayerController.file(file)..initialize();
      }
      return null;
    }).toList();
  }

  bool _isVideo(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    return extension == 'mp4' ||
        extension == 'mov' ||
        extension == 'avi'; // يمكنك إضافة المزيد من التنسيقات إذا لزم الأمر
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _textControllers) {
      controller.dispose();
    }
    for (var videoController in _videoControllers) {
      videoController?.dispose();
    }
    super.dispose();
  }

  void _sendFiles() {
    if (_selectedFiles.isNotEmpty) {
      List<Map<String, dynamic>> filesWithCaptions = [];
      for (int i = 0; i < _selectedFiles.length; i++) {
        filesWithCaptions.add({
          'file': _selectedFiles[i],
          'caption': _textControllers[i].text,
        });
      }
      widget.onImagesSent(filesWithCaptions);
      Navigator.pop(context);
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
      _textControllers.removeAt(index);
      _videoControllers[index]?.dispose();
      _videoControllers.removeAt(index);

      if (_currentPage >= _selectedFiles.length) {
        _currentPage = _selectedFiles.length - 1;
      }
      _pageController.jumpToPage(_currentPage);
    });
  }

  Future<void> _pickMoreFiles() async {
    final List<File>? selectedFiles = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GalleryScreen(),
      ),
    );
    if (selectedFiles != null && selectedFiles.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(selectedFiles);
        _textControllers.addAll(List.generate(
            selectedFiles.length, (index) => TextEditingController()));
        _videoControllers.addAll(selectedFiles.map((file) {
          if (_isVideo(file)) {
            return VideoPlayerController.file(file)..initialize();
          }
          return null;
        }).toList());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedFiles.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final file = _selectedFiles[index];
                    if (_isVideo(file)) {
                      // إذا كان الملف فيديو
                      final videoController = _videoControllers[index];
                      if (videoController != null &&
                          videoController.value.isInitialized) {
                        return VideoPlayer(videoController);
                      }
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      // إذا كان الملف صورة
                      return PhotoView(
                        imageProvider: FileImage(file),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2,
                      );
                    }
                  },
                ),
                Positioned(
                  top: 50,
                  left: 10,
                  child: IconButtonWithCircle(
                    icon: Icons.close,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Positioned(
                  top: 50,
                  right: 10,
                  child: Row(
                    children: [
                      IconButtonWithCircle(icon: Icons.crop_rotate),
                      SizedBox(width: 8),
                      IconButtonWithCircle(icon: Icons.emoji_emotions_outlined),
                      SizedBox(width: 8),
                      IconButtonWithCircle(icon: Icons.title),
                      SizedBox(width: 8),
                      IconButtonWithCircle(icon: Icons.edit),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_selectedFiles.length > 1)
            Container(
              height: 70,
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedFiles.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(4),
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _isVideo(_selectedFiles[index])
                              ? const Icon(Icons.videocam,
                                  color: Colors.white) // عرض أيقونة الفيديو
                              : Image.file(
                                  _selectedFiles[index],
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                      if (index == _currentPage)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              margin: const EdgeInsets.all(4),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => _removeFile(index),
                                  child: const Icon(
                                    Icons.delete_forever_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          Container(
            margin: const EdgeInsets.only(bottom: 10, left: 4, right: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(80)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.2),
                  offset: const Offset(0.0, 0.50),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  onPressed: _pickMoreFiles,
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 60,
                    ),
                    child: Scrollbar(
                      child: TextField(
                        maxLines: null,
                        style: const TextStyle(fontSize: 14),
                        controller: _textControllers[_currentPage],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add a caption...",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Center(
                  child: InkWell(
                    onTap: _sendFiles,
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: const BoxDecoration(
                        color: Color(0xFF02B099),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
