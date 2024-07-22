import 'package:agrotech_app/api.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StreamingSite extends StatefulWidget {
  const StreamingSite({Key? key}) : super(key: key);

  @override
  State<StreamingSite> createState() => _StreamingSiteState();
}

class _StreamingSiteState extends State<StreamingSite> {
  final String baseUrl = 'http://127.0.0.1:8000';
  bool _isLoading = true;
  List<Map<String, dynamic>> _videos = [];
  List<VideoPlayerController> _controllers = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
  }

  Future<void> fetchVideos() async {
    try {
      final videos = await _apiService.allVideos();
      setState(() {
        _videos = videos;
        _isLoading = false;
        _controllers = List.generate(
          _videos.length,
          (index) {
            final videoUrl = baseUrl + _videos[index]['video'];
            print('Video URL: $videoUrl'); // Debugging print statement
            return VideoPlayerController.networkUrl(Uri.parse('videoUrl'));
          },
        );
      });

      // Initialize all controllers
      for (var controller in _controllers) {
        await controller.initialize();
      }

      setState(() {});
    } catch (e) {
      print("$e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Streaming")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _videos.isEmpty
              ? Center(child: Text("No Videos Available"))
              : ListView.builder(
                  itemCount: _videos.length,
                  itemBuilder: (context, index) {
                    final video = _videos[index];
                    final controller = _controllers[index];
                    return ListTile(
                      title: Text(video['caption'] ?? 'No Title'),
                      subtitle: controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller),
                            )
                          : Center(child: CircularProgressIndicator()),
                      onTap: () {
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                      },
                    );
                  },
                ),
    );
  }
}
