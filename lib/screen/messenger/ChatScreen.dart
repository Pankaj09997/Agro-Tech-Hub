// // import 'package:agrotech_app/screen/messenger/service.dart';
// // import 'package:flutter/material.dart';
// // // Import your WebSocketService

// // class ChatScreen extends StatefulWidget {
// //   final String userName; // The name of the user you're chatting with
// //   final String meId; // Your user ID
// //   final String frndId; // The friend (other user's) ID
// //   final WebSocketService webSocketService; // WebSocketService instance

// //   ChatScreen({
// //     required this.userName,
// //     required this.meId,
// //     required this.frndId,
// //     required this.webSocketService,
// //   });

// //   @override
// //   _ChatScreenState createState() => _ChatScreenState();
// // }

// // class _ChatScreenState extends State<ChatScreen> {
// //   List<String> _messages = []; // Store chat messages
// //   TextEditingController _messageController = TextEditingController();
// //   late WebSocketService _webSocketService;

// //   @override
// //   void initState() {
// //     super.initState();
// //     // Get the WebSocketService instance from the parent widget
// //     _webSocketService = widget.webSocketService;
// //   }

// //   @override
// //   void dispose() {
// //     _messageController.dispose();
// //     super.dispose();
// //   }

// //   void _sendMessage() {
// //     String message = _messageController.text.trim();
// //     if (message.isNotEmpty) {
// //       // Add the message locally for display
// //       setState(() {
// //         _messages.add(message);
// //         _messageController.clear(); // Clear the text field
// //       });

// //       // Send the message via WebSocket
// //       _webSocketService.sendMessage(widget.meId, widget.frndId, message);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.userName), // Display the selected user's name
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: _messages.length,
// //               itemBuilder: (context, index) {
// //                 return Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Align(
// //                     alignment: Alignment.centerRight, // Align messages to the right
// //                     child: Container(
// //                       padding: EdgeInsets.all(10.0),
// //                       decoration: BoxDecoration(
// //                         color: Colors.blueAccent,
// //                         borderRadius: BorderRadius.circular(8.0),
// //                       ),
// //                       child: Text(
// //                         _messages[index],
// //                         style: TextStyle(color: Colors.white),
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _messageController,
// //                     decoration: InputDecoration(
// //                       hintText: 'Type a message...',
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(8.0),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.send),
// //                   onPressed: _sendMessage,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:agrotech_app/screen/messenger/service.dart';

// class ChatScreen extends StatefulWidget {
//   final String userName; // The name of the user you're chatting with
//   final String meId; // Your user ID
//   final String frndId; // The friend (other user's) ID
//   final WebSocketService webSocketService; // WebSocketService instance

//   ChatScreen({
//     required this.userName,
//     required this.meId,
//     required this.frndId,
//     required this.webSocketService,
//   });

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   List<String> _messages = []; // Store chat messages
//   TextEditingController _messageController = TextEditingController();
//   late WebSocketService _webSocketService;

//   @override
//   void initState() {
//     super.initState();
//     _webSocketService = widget.webSocketService;

//     // Connect to WebSocket and listen for messages
//     _webSocketService.connect((message) {
//       setState(() {
//         _messages.add(message); // Add the received message to the list
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _webSocketService.closeConnection(); // Close WebSocket connection when leaving
//     super.dispose();
//   }

//   void _sendMessage() {
//     String message = _messageController.text.trim();
//     if (message.isNotEmpty) {
//       // Add the message locally for display
//       setState(() {
//         _messages.add(message);
//         _messageController.clear(); // Clear the text field
//       });

//       // Send the message via WebSocket
//       _webSocketService.sendMessage(widget.meId, widget.frndId, message);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.userName), // Display the selected user's name
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Align(
//                     alignment: Alignment.centerRight, // Align messages to the right
//                     child: Container(
//                       padding: EdgeInsets.all(10.0),
//                       decoration: BoxDecoration(
//                         color: Colors.blueAccent,
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: Text(
//                         _messages[index],
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
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
// import 'package:flutter/material.dart';
// import 'package:agrotech_app/screen/messenger/service.dart';

// class ChatScreen extends StatefulWidget {
//   final String userName; // The name of the user you're chatting with
//   final int meId; // Your user ID
//   final int frndId; // The friend (other user's) ID
//   final WebSocketService webSocketService; // WebSocketService instance

//   ChatScreen({
//     required this.userName,
//     required this.meId,
//     required this.frndId,
//     required this.webSocketService,
//   });

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   List<String> _messages = []; // Store chat messages
//   TextEditingController _messageController = TextEditingController();
//   late WebSocketService _webSocketService;

//   @override
//   void initState() {
//     super.initState();
//     _webSocketService = widget.webSocketService;

//     // Connect to WebSocket and listen for messages
//     _webSocketService.connect((message) {
//       setState(() {
//         _messages.add(message); // Add the received message to the list
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _webSocketService.closeConnection(); // Close WebSocket connection when leaving
//     super.dispose();
//   }

//   void _sendMessage() {
//     String message = _messageController.text.trim();
//     if (message.isNotEmpty) {
//       _webSocketService.sendMessage(widget.meId, widget.frndId, message);
//       setState(() {
//         _messages.add(message); // Add the sent message to the list
//       });
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with ${widget.userName}'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_messages[index]),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
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
// import 'package:flutter/material.dart';
// import 'package:agrotech_app/screen/messenger/service.dart';

// class ChatScreen extends StatefulWidget {
//   final String userName; // The name of the user you're chatting with
//   final int meId; // Your user ID
//   final int frndId; // The friend (other user's) ID
//   final WebSocketService webSocketService; // WebSocketService instance

//   ChatScreen({
//     required this.userName,
//     required this.meId,
//     required this.frndId,
//     required this.webSocketService,
//   });

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   List<Map<String, dynamic>> _messages = []; // Store chat messages with metadata
//   TextEditingController _messageController = TextEditingController();
//   late WebSocketService _webSocketService;

//   @override
//   void initState() {
//     super.initState();
//     _webSocketService = widget.webSocketService;

//     // Connect to WebSocket and listen for messages
//     _webSocketService.connect((message) {
//       setState(() {
//         _messages.add({
//           'message': message,
//           'isMine': false, // Assuming the message is from the friend
//         });
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _webSocketService.closeConnection(); // Close WebSocket connection when leaving
//     super.dispose();
//   }

//   void _sendMessage() {
//     String message = _messageController.text.trim();
//     if (message.isNotEmpty) {
//       _webSocketService.sendMessage(widget.meId, widget.frndId, message);
//       setState(() {
//         _messages.add({
//           'message': message,
//           'isMine': true, // Mark as sent by the current user
//         });
//       });
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with ${widget.userName}'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               reverse: true, // Scroll to the bottom
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index]['message'];
//                 final isMine = _messages[index]['isMine'];

//                 return Align(
//                   alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMine ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       message,
//                       style: TextStyle(
//                         color: isMine ? Colors.white : Colors.black87,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.blueAccent),
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
import 'dart:convert';
import 'package:agrotech_app/screen/messenger/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String userName;
  final int meId;
  final int frndId;
  final WebSocketService webSocketService;

  ChatScreen({
    required this.userName,
    required this.meId,
    required this.frndId,
    required this.webSocketService,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> _messages = []; // Store chat messages
  TextEditingController _messageController = TextEditingController();
  late WebSocketService _webSocketService;

  @override
  void initState() {
    super.initState();
    _webSocketService = widget.webSocketService;

    // Fetch previous chat history
    _loadChatHistory();

    // Connect to WebSocket and listen for new messages
    _webSocketService.connect((message) {
      setState(() {
        _messages.add({
          'message': message,
          'isMine': false, // Assuming the message is from the friend
        });
      });
    });
  }

  Future<void> _loadChatHistory() async {
    final url = Uri.parse(
        'http://127.0.0.1:8000/api/chat-history/${widget.meId}/${widget.frndId}/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> chatHistory = jsonDecode(response.body);
        print('$chatHistory');

        setState(() {
          // Add chat history to the message list
          _messages = chatHistory.map((chat) {
            return {
              'message': chat['message'],
              'isMine': chat['sender_id'] == widget.meId,
            };
          }).toList();
        });
      } else {
        print('Failed to load chat history');
      }
    } catch (error) {
      print('Error fetching chat history: $error');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _webSocketService
        .closeConnection(); // Close WebSocket connection when leaving
    super.dispose();
  }

  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _webSocketService.sendMessage(widget.meId, widget.frndId, message);
      setState(() {
        _messages.add({
          'message': message,
          'isMine': true,
        });
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                return Align(
                  alignment: message['isMine']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: message['isMine'] ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message['message'],
                      style: TextStyle(
                        color: message['isMine'] ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
