// import 'package:agrotech_app/screen/messenger/service.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';


// class ChatPage extends StatefulWidget {
//   final String friendId;
//   final String myId;

//   ChatPage({required this.myId, required this.friendId});

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _controller = TextEditingController();
//   final WebSocketService _webSocketService = WebSocketService();
//   List<Map<String, dynamic>> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     // Initialize WebSocket connection
//     _webSocketService.connect().then((_) {
//       // Fetch chat history
//       _fetchChatHistory();
//     });
//   }

//   Future<void> _fetchChatHistory() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('jwt_token');

//     final response = await http.get(
//       Uri.parse('http://127.0.0.1:8000/api/chat-history/?user=${widget.friendId}'),
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         _messages = List<Map<String, dynamic>>.from(data['my_chats']);
//       });
//     }
//   }

//   void _sendMessage() {
//     final message = _controller.text.trim();
//     if (message.isNotEmpty) {
//       _webSocketService.sendMessage(widget.myId, widget.friendId, message);
//       _controller.clear();

//       setState(() {
//         _messages.add({'sender': widget.myId, 'message': message});
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _webSocketService.closeConnection();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with Friend'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 final isMe = message['sender'] == widget.myId;
//                 return ListTile(
//                   title: Align(
//                     alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       color: isMe ? Colors.blue : Colors.grey[300],
//                       child: Text(message['message']),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       labelText: 'Type a message',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
