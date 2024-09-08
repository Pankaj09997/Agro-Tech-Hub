import 'package:agrotech_app/api.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late WebSocketChannel channel;
  late ApiService apiService;
  String? token;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _initWebSocket();
  }

  Future<void> _initWebSocket() async {
    token = await apiService.getToken(); // Fetch the token from ApiService
    if (token != null) {
      channel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:8000/ws/wsc/?token=$token'),
      );
      setState(() {});
    } else {
      // Handle the case when the token is not available
      print('Token not available');
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      channel.sink.add(message); // Send the message through WebSocket
      _controller.clear(); // Clear the text field
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: token == null
          ? Center(child: Text('No token available'))
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: channel.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: [
                            ListTile(
                              title: Text(snapshot.data.toString()),
                            ),
                          ],
                        );
                      }
                      return Center(child: Text('No messages'));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: _sendMessage, // Send message when submitted
                          decoration: InputDecoration(
                            labelText: 'Send a message',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () => _sendMessage(_controller.text), // Send message when icon button is pressed
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
