import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String roomName;
  final int senderId;

  ChatScreen({required this.roomName, required this.senderId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _messageStreamController = StreamController<String>.broadcast();

  late WebSocketChannel _webSocketChannel;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    _messageStreamController.close();
    _webSocketChannel.sink.close(status.goingAway);
    super.dispose();
  }

  void _connectToWebSocket() {
    final url = 'ws://localhost:8000/ws/chat/${widget.roomName}/';
    _webSocketChannel = WebSocketChannel.connect(Uri.parse(url));

    _webSocketChannel.stream.listen((message) {
      _messageStreamController.add(message);
    }, onError: (error) {
      print('Error occurred: $error');
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final message = {
        'message': _messageController.text,
        'name': widget.senderId ,// Replace with actual user name
        'receiver': widget.roomName, // Adjust if necessary
      };
      _webSocketChannel.sink.add(json.encode(message));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room ${widget.roomName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: _messageStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data!.split('\n').map((message) {
                        return ListTile(
                          title: Text(message),
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
