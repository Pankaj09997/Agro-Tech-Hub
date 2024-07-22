import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/colors/Colors.dart';
import 'package:agrotech_app/login.dart'; // Adjust import as needed
import 'package:agrotech_app/screen/changepassword.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late final List<Map<String, dynamic>> settingsOptions;
  @override
  void initState() {
    super.initState();
    settingsOptions = [
      {
        'icon': Icons.lock,
        'title': 'Change Password',
        'action': () {
          Navigator.push(context, MaterialPageRoute(builder: (_)=>ChangePassword()));
        },
      },
      {
        'icon': Icons.logout,
        'title': 'Logout',
        'action': () {
          // Implement navigation or action for logging out
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    Login()), // Replace with your login page widget
            (route) => false, // Remove all routes
          );
        },
      },
      {
        'icon': Icons.person,
        'title': 'Edit Profile',
        'action': () {
          // Implement navigation or action for editing profile
          print('Edit Profile tapped');
        },
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: colorsPallete.appBarColor,
      ),
      body: ListView.builder(
        itemCount: settingsOptions.length,
        itemBuilder: (context, index) {
          final option = settingsOptions[index];

          return ListTile(
            leading: Icon(option['icon']),
            title: Text(option['title']),
            trailing: Icon(Icons.arrow_right),
            onTap: option['action'], // Call the action when tapped
          );
        },
      ),
    );
  }
}
