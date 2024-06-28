import 'dart:io';

import 'package:agrotech_app/api.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
 // Import your ApiService

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  File? selectedImage;
  File? selectedFile;
  TextEditingController postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Create Post",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: postController,
              maxLines: 20,
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
                icon: Icons.file_present,
                color: Colors.black,
                label: "File",
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    selectedFile = File(result.files.single.path!);
                    setState(() {});
                  }
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Divider(),
              ActionButton(
                icon: Icons.photo,
                color: Colors.black,
                label: "Photos",
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result != null) {
                    selectedImage = File(result.files.single.path!);
                    setState(() {});
                  }
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Divider(),
            ],
          ),
        ],
      ),
    );
  }

  void _uploadPost() {
    String postText = postController.text;

    if (selectedImage != null) {
      ApiService().postFunction(postText, selectedImage!, null).then((response) {
        // Handle response
        print('Image post uploaded');
        // Optionally, navigate to another page or show a success message
      }).catchError((error) {
        // Handle error
        print('Failed to upload image post: $error');
      });
    }

    if (selectedFile != null) {
      // Determine the type of file based on its extension
      String fileExtension = selectedFile!.path.split('.').last.toLowerCase();

      if (fileExtension == 'pdf') {
        // Handle PDF file upload
        ApiService().postFunction(postText, null, selectedFile!).then((response) {
          // Handle response
          print('PDF file post uploaded');
          // Optionally, navigate to another page or show a success message
        }).catchError((error) {
          // Handle error
          print('Failed to upload PDF file post: $error');
        });
      } else {
        // Handle other types of files (if needed)
        print('Unsupported file type');
      }
    }

    if (selectedImage == null && selectedFile == null) {
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
