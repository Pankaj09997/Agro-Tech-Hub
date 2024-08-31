import 'dart:io';

import 'package:agrotech_app/api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:file_picker/file_picker.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  File? _selectedImage;
  File? _selectedFile;
  final TextEditingController postController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _showSpinner = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        print('$_selectedImage');
        _selectedFile = null;
      });
    } else {
      print("No Image Selected");
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _selectedImage = null;
      });
    }
  }

  Future<void> _uploadPost() async {
    setState(() {
      _showSpinner = true;
    });

    try {
      String postText = postController.text;
      var response;

      if (_selectedImage != null && _selectedFile != null) {
        response = await ApiService().postFunction(
          postText,
          _selectedImage,
          _selectedFile,
        );
      } else if (_selectedImage != null) {
        response = await ApiService().postFunction(
          postText,
          _selectedImage,
          null,
        );
      } else if (_selectedFile != null) {
        response = await ApiService().postFunction(
          postText,
          null,
          _selectedFile,
        );
      } else if (postText.isNotEmpty) {
        response = await ApiService().postFunction(
          postText,
          null,
          null,
        );
      } else {
        print('No content to post');
        return;
      }

      if (response['status'] == 'success') {
        print('Post uploaded successfully');
      } else {
        print('Failed to upload post: ${response['message']}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Post'),
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          actions: [
            TextButton(
              onPressed: _uploadPost,
              child: Text(
                "Post",
                style: TextStyle(fontSize: 15, color: Colors.blue),
              ),
            )
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: postController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "What's on your mind...?",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ),
            Divider(),
            _buildPreviewSection(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ActionButton(
                    icon: Icons.photo,
                    color: Colors.black,
                    label: "Add Photo/Video",
                    onTap: _pickImage,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ActionButton(
                    icon: Icons.file_present,
                    color: Colors.black,
                    label: "Add File",
                    onTap: _pickFile,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (_selectedImage != null)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200], // Light grey background color
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  height: 200, // Adjust the height as needed
                ),
              ),
            ),
          if (_selectedFile != null)
            Column(
              children: [
                Icon(Icons.insert_drive_file, size: 50),
                SizedBox(height: 10),
                Text('Selected File: ${_selectedFile!.path.split('/').last}'),
              ],
            ),
          if (_selectedImage == null &&
              _selectedFile == null &&
              postController.text.isEmpty)
            Text('No content selected'),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue.withOpacity(0.1), // Light blue background color
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 35,
            ),
            SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
