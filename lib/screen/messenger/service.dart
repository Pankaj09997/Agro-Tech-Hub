// import 'dart:convert';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class WebSocketService {
//   WebSocketChannel? _channel;
//   String? _token;

//   Future<void> connect() async {
//     // Load the JWT token from shared preferences
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('jwt_token');

//     // Establish the WebSocket connection
//     _channel = WebSocketChannel.connect(
//       Uri.parse('ws://127.0.0.1:8000/ws/chat/?token=$_token'), // WebSocket URL
//     );

//     // Listen for messages from the server
//     _channel?.stream.listen((message) {
//       print('Received: $message');
//       // Handle the received message
//     });
//   }

//   // Send a message to the WebSocket
//   void sendMessage(String meId, String frndId, String message) {
//     if (_channel != null) {
//       final data = jsonEncode({
//         'me_id': meId,
//         'frnd_id': frndId,
//         'message': message,
//       });
//       _channel?.sink.add(data);  // Send message to the server
//     }
//   }

//   // Close the WebSocket connection
//   void closeConnection() {
//     _channel?.sink.close();
//   }
// }
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  String? _token;

  Future<void> connect(void Function(String) onMessageReceived) async {
    // Load the JWT token from shared preferences
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');

    // Establish the WebSocket connection
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8000/ws/chat/?token=$_token'), // WebSocket URL
    );

    // Listen for messages from the server
    _channel?.stream.listen((message) {
      print('Received: $message');
      onMessageReceived(message); // Pass the message to the callback
    });
  }

  // Send a message to the WebSocket
  void sendMessage(int meId, int frndId, String message) {
    if (_channel != null) {
      final data = jsonEncode({
        'me_id': meId,
        'frnd_id': frndId,
        'message': message,
      });
      _channel?.sink.add(data);  // Send message to the server
    }
  }

  // Close the WebSocket connection
  void closeConnection() {
    _channel?.sink.close();
  }
}
