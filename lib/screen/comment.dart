import 'package:flutter/material.dart';
import 'package:agrotech_app/api.dart'; // Adjust import as needed

class CommentPage extends StatefulWidget {
  final int postId;

  const CommentPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final ApiService _apiService = ApiService();
  List<dynamic> comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments(widget.postId);
  }

  Future<void> _fetchComments(int postId) async {
    try {
      final commentData = await _apiService.commentView(postId);
      setState(() {
        comments = commentData;
      });
    } catch (e) {
      print('Failed to fetch comments: $e');
      // Handle error state or inform the user appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: comments.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loader if comments are being fetched
          : ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                var comment = comments[index];
                return ListTile(
                  title: Text(comment['comment']),
                  // You can add more information here like comment author, timestamp, etc.
                );
              },
            ),
    );
  }
}
