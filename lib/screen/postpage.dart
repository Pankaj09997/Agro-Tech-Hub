import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:agrotech_app/api.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  File? selectedImage;
  File? selectedFile;
  TextEditingController postController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _uploadPost,
            child: Text(
              "Post",
              style: TextStyle(fontSize: 15, color: Colors.blue),
            ),
          )
        ],
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
              ),
            ),
          ),
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionButton(
                icon: Icons.photo,
                color: Colors.black,
                label: "Select Image",
                onTap: () async {
                  _pickImage();
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ActionButton(
                icon: Icons.file_present,
                color: Colors.black,
                label: "Select File",
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    selectedFile = File(result.files.single.path!);
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _uploadPost() {
    String postText = postController.text;

    if (_image != null) {
      ApiService().postFunction(postText, _image!, null).then((response) {
        // Handle response
        print('Image post uploaded');
        // Optionally, navigate to another page or show a success message
      }).catchError((error) {
        // Handle error
        print('Failed to upload image post: $error');
      });
    }

    if (selectedFile != null) {
      ApiService().postFunction(postText, null, selectedFile!).then((response) {
        // Handle response
        print('File post uploaded');
        // Optionally, navigate to another page or show a success message
      }).catchError((error) {
        // Handle error
        print('Failed to upload file post: $error');
      });
    }

    if (_image == null && selectedFile == null) {
      ApiService().postFunction(postText, null, null).then((response) {
        // Handle response
        print('Text post uploaded');
        // Optionally, navigate to another page or show a success message
      }).catchError((error) {
        // Handle error
        print('Failed to upload text post: $error');
      });
    }
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 35,
          ),
          SizedBox(width: 5),
          Text(label),
        ],
      ),
    );
  }
}
