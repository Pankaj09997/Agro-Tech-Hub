import 'dart:io';
import 'package:agrotech_app/api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddVideos extends StatefulWidget {
  const AddVideos({super.key});

  @override
  State<AddVideos> createState() => _AddVideosState();
}

class _AddVideosState extends State<AddVideos> {
  final ApiService _apiService = ApiService();
  File? _video;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _pickVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      setState(() {
        _video = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_captionController.text.isEmpty && _video == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Caption and video are required')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response =
          await _apiService.videoUpload(_captionController.text, _video);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['status'] == 'success' ? 'Video uploaded successfully' : 'Failed to upload video')));

          
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Videos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _captionController,
              decoration: InputDecoration(labelText: 'Caption'),
            ),
            SizedBox(height: 10),
            _video == null
                ? ElevatedButton(
                    onPressed: _pickVideo,
                    child: Text('Pick Video'),
                  )
                : Column(
                    children: [
                      Text('Video selected: ${_video!.path.split('/').last}'),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _pickVideo,
                        child: Text('Change Video'),
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadVideo,
                    child: Text('Upload Video'),
                  ),
          ],
        ),
      ),
    );
  }
}
