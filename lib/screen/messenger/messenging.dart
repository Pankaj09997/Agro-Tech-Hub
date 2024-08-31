import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/colors/Colors.dart';
import 'package:agrotech_app/screen/fields.dart';
import 'package:flutter/material.dart';

class MessengingScreen extends StatefulWidget {
  const MessengingScreen({super.key});

  @override
  State<MessengingScreen> createState() => _MessengingScreenState();
}

class _MessengingScreenState extends State<MessengingScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _users;

  @override
  void initState() {
    _users = _apiService.fetchUsers();
    super.initState();
  }

  // Function to filter users based on search query
  List<dynamic> _searchquery(List<dynamic> users, String query) {
    if (query.isEmpty) {
      return users;
    } else {
      return users.where((user) {
        final name = user['name'].toString().toLowerCase();
        final email = user['email'].toString().toLowerCase();
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || email.contains(searchLower);
      }).toList();
    }
  }

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messenging"),
        backgroundColor: colorsPallete.appBarColor,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          // Use Flexible here instead of Expanded
          Flexible(
            child: FutureBuilder<List<dynamic>>(
              future: _users,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  // When the data is loaded
                  final users =
                      _searchquery(snapshot.data!, _nameController.text);
                  print("users are $users");
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text(user['name']),
                        subtitle: Text(user['email']),
                        onTap: () {},
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
