// import 'package:agrotech_app/api.dart';
// import 'package:agrotech_app/screen/messenger/ChatScreen.dart';
// import 'package:agrotech_app/screen/messenger/service.dart';
// import 'package:flutter/material.dart';

// class ListUserPage extends StatefulWidget {
//   @override
//   _ListUserPageState createState() => _ListUserPageState();
// }

// class _ListUserPageState extends State<ListUserPage> {
//   List<dynamic> _allUsers = [];
//   List<dynamic> _filteredUsers = [];
//   TextEditingController _searchController = TextEditingController();
//   ApiService _apiService = ApiService();
//   WebSocketService _webSocketService =
//       WebSocketService(); // WebSocketService instance
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUsers();
//     _searchController.addListener(_filterUsers);
// // Connect to the WebSocket
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _webSocketService
//         .closeConnection(); // Close WebSocket connection when leaving
//     super.dispose();
//   }

//   Future<void> _fetchUsers() async {
//     try {
//       List<dynamic> users = await _apiService.fetchUsers();
//       print("$users");
//       setState(() {
//         _allUsers = users;
//         _filteredUsers = users;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       print("Error fetching users: $e");
//     }
//   }

//   void _filterUsers() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredUsers = _allUsers.where((user) {
//         String userName = user['name'].toLowerCase();
//         return userName.contains(query);
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('List of Users'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search Users...',
//                       prefixIcon: Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _filteredUsers.length,
//                     itemBuilder: (context, index) {
//                       var user = _filteredUsers[index];
//                       return ListTile(
//                         title: Text(user['name']),
//                         subtitle: Text(
//                             user['email']), // Display email or other details
//                         onTap: () {
//                           // Replace 'meId' with the current user's ID, e.g., from shared preferences
//                           String meId = 'currentUserId';
//                           String frndId =
//                               user['id'].toString(); // Friend's user ID
//                           print('$frndId');

//                           // Navigate to the ChatScreen and pass the selected user's details
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ChatScreen(
//                                 userName: user['name'],
//                                 meId: meId.toString(),
//                                 frndId: frndId.toString(),
//                                 webSocketService: _webSocketService,
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
// import 'package:agrotech_app/api.dart';
// import 'package:agrotech_app/screen/messenger/ChatScreen.dart';
// import 'package:agrotech_app/screen/messenger/service.dart';
// import 'package:flutter/material.dart';

// class ListUserPage extends StatefulWidget {
//   @override
//   _ListUserPageState createState() => _ListUserPageState();
// }

// class _ListUserPageState extends State<ListUserPage> {
//   List<dynamic> _allUsers = [];
//   List<dynamic> _filteredUsers = [];
//   TextEditingController _searchController = TextEditingController();
//   ApiService _apiService = ApiService();
//   WebSocketService _webSocketService = WebSocketService(); // WebSocketService instance
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUsers();
//     _searchController.addListener(_filterUsers);

//     // Connect to the WebSocket and handle incoming messages
//     _webSocketService.connect((message) {
//       // Handle incoming messages here if needed
//       print('Message from WebSocket: $message');
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _webSocketService.closeConnection(); // Close WebSocket connection when leaving
//     super.dispose();
//   }

//   Future<void> _fetchUsers() async {
//     try {
//       List<dynamic> users = await _apiService.fetchUsers();
//       setState(() {
//         _allUsers = users;
//         _filteredUsers = users;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       print("Error fetching users: $e");
//     }
//   }

//   void _filterUsers() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredUsers = _allUsers.where((user) {
//         String userName = user['name'].toLowerCase();
//         return userName.contains(query);
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('List of Users'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search Users...',
//                       prefixIcon: Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _filteredUsers.length,
//                     itemBuilder: (context, index) {
//                       var user = _filteredUsers[index];
//                       return ListTile(
//                         title: Text(user['name']),
//                         subtitle: Text(user['email']), // Display email or other details
//                         onTap: () {
//                           // Replace 'meId' with the current user's ID, e.g., from shared preferences
//                           // String meId = 'currentUserId';
//                           String frndId = user['id'].toString(); // Friend's user ID
//                           print('$frndId');

//                           // Navigate to the ChatScreen and pass the selected user's details
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ChatScreen(
//                                 userName: user['name'],
//                                 meId: 1.toString(),
//                                 frndId: 2.toString(),
//                                 webSocketService: _webSocketService,
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:agrotech_app/api.dart';
// import 'package:agrotech_app/screen/messenger/ChatScreen.dart';
// import 'package:agrotech_app/screen/messenger/service.dart';

// class ListUserPage extends StatefulWidget {
//   @override
//   _ListUserPageState createState() => _ListUserPageState();
// }

// class _ListUserPageState extends State<ListUserPage> {
//   List<dynamic> _allUsers = [];
//   List<dynamic> _filteredUsers = [];
//   TextEditingController _searchController = TextEditingController();
//   ApiService _apiService = ApiService();
//   WebSocketService _webSocketService = WebSocketService(); // WebSocketService instance
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUsers();
//     _searchController.addListener(_filterUsers);

//     // Connect to the WebSocket and handle incoming messages
//     _webSocketService.connect((message) {
//       // Handle incoming messages here if needed
//       print('Message from WebSocket: $message');
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _webSocketService.closeConnection(); // Close WebSocket connection when leaving
//     super.dispose();
//   }

//   Future<void> _fetchUsers() async {
//     try {
//       List<dynamic> users = await _apiService.fetchUsers();
//       setState(() {
//         _allUsers = users;
//         _filteredUsers = users;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       print("Error fetching users: $e");
//     }
//   }

//   void _filterUsers() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredUsers = _allUsers.where((user) {
//         String userName = user['name'].toLowerCase();
//         return userName.contains(query);
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('List of Users'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search Users...',
//                       prefixIcon: Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _filteredUsers.length,
//                     itemBuilder: (context, index) {
//                       var user = _filteredUsers[index];
//                       return ListTile(
//                         title: Text(user['name']),
//                         subtitle: Text(user['email']), 
//                         onTap: () {
                        
//                           int frndId = user['id']; 

                        
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ChatScreen(
//                                 userName: user['name'],
//                                 meId: 1, 
//                                 frndId: frndId,
//                                 webSocketService: _webSocketService,
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/screen/messenger/ChatScreen.dart';
import 'package:agrotech_app/screen/messenger/service.dart';

class ListUserPage extends StatefulWidget {
  @override
  _ListUserPageState createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {
  List<dynamic> _allUsers = [];
  List<dynamic> _filteredUsers = [];
  TextEditingController _searchController = TextEditingController();
  ApiService _apiService = ApiService();
  WebSocketService _webSocketService = WebSocketService(); // WebSocketService instance
  bool _isLoading = true;
  int? meId; // Variable to store the current user's ID

  @override
  void initState() {
    super.initState();
    _loadProfileAndFetchUsers();
    _searchController.addListener(_filterUsers);

    // Connect to the WebSocket and handle incoming messages
    _webSocketService.connect((message) {
      // Handle incoming messages here if needed
      print('Message from WebSocket: $message');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _webSocketService.closeConnection(); // Close WebSocket connection when leaving
    super.dispose();
  }

  Future<void> _loadProfileAndFetchUsers() async {
    try {
      // Fetch profile to get the logged-in user's ID
      Map<String, dynamic> profileData = await _apiService.profilePage();
      meId = profileData['id']; // Get the current logged-in user ID

      // Now fetch the list of users
      List<dynamic> users = await _apiService.fetchUsers();
      setState(() {
        _allUsers = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
    }
  }

  void _filterUsers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        String userName = user['name'].toLowerCase();
        return userName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Users'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Users...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      var user = _filteredUsers[index];
                      return ListTile(
                        title: Text(user['name']),
                        subtitle: Text(user['email']), // Display email or other details
                        onTap: () {
                          int frndId = user['id']; // Friend's user ID

                          // Navigate to the ChatScreen and pass the current user ID (meId) dynamically
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                userName: user['name'],
                                meId: meId!, // Pass the logged-in user ID
                                frndId: frndId,
                                webSocketService: _webSocketService,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
