import 'package:agrotech_app/screen/addVideos.dart';
import 'package:flutter/material.dart';

class StreamingSite extends StatefulWidget {
  const StreamingSite({Key? key}) : super(key: key);

  @override
  State<StreamingSite> createState() => _StreamingSiteState();
}

class _StreamingSiteState extends State<StreamingSite> {
  List<Map<String, String>> videos = List.generate(
    10,
    (index) => {
      'title': 'Video Title $index',
      'channel': 'Channel Name',
      'views': '1M views',
      'time': '1 day ago',
      'thumbnail': 'assets/streamingsite.jpg',
      'profile': 'https://via.placeholder.com/150'
    },
  );

  void _addVideo() {
    setState(() {
      videos.insert(
        0,
        {
          'title': 'New Video',
          'channel': 'New Channel',
          'views': '0 views',
          'time': 'just now',
          'thumbnail': 'assets/streamingsite.jpg',
          'profile': 'https://via.placeholder.com/150'
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddVideos()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150',
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            ...videos.map((video) {
              return Column(
                children: [
                  Image.asset(
                    video['thumbnail']!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(video['profile']!),
                    ),
                    title: Text(video['title']!),
                    subtitle: Text(
                      '${video['channel']} • ${video['views']} • ${video['time']}',
                    ),
                  ),
                  const Divider(),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
