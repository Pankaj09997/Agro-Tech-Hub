import 'package:agrotech_app/colors/Colors.dart';
import 'package:agrotech_app/screen/messenger/messenging.dart';
import 'package:flutter/material.dart';
import 'package:agrotech_app/api.dart'; // Adjust import as needed
import 'package:agrotech_app/screen/profile.dart';
import 'package:agrotech_app/screen/comment.dart'; // Adjust import as needed
import 'package:agrotech_app/screen/postpage.dart'; // Adjust import as needed

class NetworkPage extends StatefulWidget {
  const NetworkPage({Key? key}) : super(key: key);

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  final ApiService _apiService = ApiService();
  List<dynamic> posts = [];
  List<bool> likedState = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final postsData = await _apiService.postAll();
      setState(() {
        posts = postsData;
        likedState = List<bool>.filled(posts.length, false);
      });
    } catch (e) {
      print('Failed to fetch posts: $e');
      // Handle error, e.g., show error message to user
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Networking"),
        backgroundColor: colorsPallete.appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color ?? Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ChatPage()));
            },
            icon: Icon(Icons.messenger, color: theme.iconTheme.color ?? Colors.black),
            iconSize: 30,
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications, color: theme.iconTheme.color ?? Colors.black),
            iconSize: 30,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PostPage()),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: "What's on your mind...?",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Divider(),
                    SizedBox(height: height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ActionButton(
                          icon: Icons.file_present,
                          color: theme.iconTheme.color ?? Colors.black,
                          label: "File",
                          onTap: () {},
                        ),
                        ActionButton(
                          icon: Icons.photo,
                          color: theme.iconTheme.color ?? Colors.black,
                          label: "Photos",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              posts.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        var post = posts[index];
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        'https://cdn4.vectorstock.com/i/1000x1000/08/38/avatar-icon-male-user-person-profile-symbol-vector-20910838.jpg', // Replace with actual avatar URL
                                      ),
                                      radius: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post['author_name'],
                                          style: theme.textTheme.bodyText1?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ) ?? TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Text(
                                          post['created_at'],
                                          style: theme.textTheme.bodyText2?.copyWith(
                                            color: theme.hintColor,
                                            fontSize: 12,
                                          ) ?? TextStyle(color: theme.hintColor, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  post['content'] ?? '',
                                  style: theme.textTheme.bodyText1,
                                ),
                                if (post['image'] != null)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FullScreenImageScreen(
                                            imageUrl:
                                                'http://127.0.0.1:8000${post['image']}',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          'http://127.0.0.1:8000${post['image']}',
                                          height: height * 0.3,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ActionButton(
                                      icon: Icons.thumb_up,
                                      color: likedState.length > index &&
                                              likedState[index]
                                          ? theme.colorScheme.secondary
                                          : theme.iconTheme.color ?? Colors.black,
                                      label: "Like",
                                      onTap: () {
                                        setState(() {
                                          likedState[index] =
                                              !likedState[index];
                                        });
                                      },
                                    ),
                                    ActionButton(
                                      icon: Icons.comment,
                                      color: theme.iconTheme.color ?? Colors.black,
                                      label: "Comment",
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CommentPage(
                                              postId: post['id'] ?? 0,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ActionButton(
                                      icon: Icons.share,
                                      color: theme.iconTheme.color ?? Colors.black,
                                      label: "Share",
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
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
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          SizedBox(width: 5),
          Text(label),
        ],
      ),
    );
  }
}

class FullScreenImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageScreen({required this.imageUrl, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
