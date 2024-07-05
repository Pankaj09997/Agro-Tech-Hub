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
  TextEditingController _commentController = TextEditingController();
  List<dynamic> comments = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    print('Fetching comments for post ID: ${widget.postId}');
    _fetchComments(widget.postId);
  }

  Future<void> _fetchComments(int postId) async {
    try {
      final commentData = await _apiService.commentView(postId);
      setState(() {
        comments = commentData;
        isLoading = false;
        errorMessage =
            null; // Reset error message if comments are successfully fetched
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch comments: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _postComment(String commentText) async {
    try {
      await _apiService.writeComment(commentText, widget.postId);
      // Refresh comments after posting
      _fetchComments(widget.postId);
      _commentController.clear(); // Clear the comment field after posting
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to post comment: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : errorMessage != null
                          ? Center(child: Text(errorMessage!))
                          : comments.isEmpty
                              ? Center(child: Text("No comments found."))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: comments.length,
                                  itemBuilder: (context, index) {
                                    var comment = comments[index];
                                    return _buildCommentItem(comment);
                                  },
                                ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey), // Divider line
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String commentText = _commentController.text.trim();
                    if (commentText.isNotEmpty) {
                      _postComment(commentText);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            // Placeholder for commenter's profile picture
            backgroundImage: NetworkImage(
                "https://cdn4.vectorstock.com/i/1000x1000/08/38/avatar-icon-male-user-person-profile-symbol-vector-20910838.jpg"),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment['author'], // Display commenter's name
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  comment['comment'], // Display comment text
                ),
                SizedBox(height: 8),
                Text(
                  comment['created_at'], // Placeholder for comment timestamp
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
