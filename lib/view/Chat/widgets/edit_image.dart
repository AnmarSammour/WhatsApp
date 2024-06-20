import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:whatsapp/view/Chat/widgets/gallery_screen.dart';
import 'dart:io';

import 'package:whatsapp/view/widgets/icon_button.dart';

class EditImage extends StatefulWidget {
  final List<File> imageFiles;
  final Function(List<Map<String, dynamic>>) onImagesSent;

  const EditImage({Key? key, required this.imageFiles, required this.onImagesSent}) : super(key: key);

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  final PageController _pageController = PageController();
  List<TextEditingController> _textControllers = [];
  List<File> _selectedImages = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _selectedImages = List.from(widget.imageFiles);
    _textControllers = List.generate(_selectedImages.length, (index) => TextEditingController());
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _sendImages() {
    if (_selectedImages.isNotEmpty) {
      List<Map<String, dynamic>> imagesWithCaptions = [];
      for (int i = 0; i < _selectedImages.length; i++) {
        imagesWithCaptions.add({
          'image': _selectedImages[i],
          'caption': _textControllers[i].text,
        });
      }
      widget.onImagesSent(imagesWithCaptions);
      Navigator.pop(context);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      _textControllers.removeAt(index);
      if (_currentPage >= _selectedImages.length) {
        _currentPage = _selectedImages.length - 1;
      }
      _pageController.jumpToPage(_currentPage);
    });
  }

  Future<void> _pickMoreImages() async {
    final List<File>? selectedImages = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GalleryScreen(),
      ),
    );
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(selectedImages);
        _textControllers.addAll(List.generate(selectedImages.length, (index) => TextEditingController()));
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
                  itemCount: _selectedImages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return PhotoView(
                      imageProvider: FileImage(_selectedImages[index]),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    );
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
          if (_selectedImages.length > 1)
            Container(
              height: 70,
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.all(4),
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImages[index],
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
                              margin: EdgeInsets.all(4),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Icon(
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
            margin: EdgeInsets.only(bottom: 10, left: 4, right: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(80)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.2),
                  offset: Offset(0.0, 0.50),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_photo_alternate_outlined),
                  onPressed: _pickMoreImages,
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 60,
                    ),
                    child: Scrollbar(
                      child: TextField(
                        maxLines: null,
                        style: TextStyle(fontSize: 14),
                        controller: _textControllers[_currentPage],
                        decoration: InputDecoration(
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
                    onTap: _sendImages,
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Color(0xFF02B099),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Icon(
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
