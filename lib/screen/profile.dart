import 'package:agrotech_app/api.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _futureProfileData;

  @override
  void initState() {
    super.initState();
    _futureProfileData = fetchInfo();
  }

  Future<Map<String, dynamic>> fetchInfo() async {
    try {
      final userInfo = await _apiService.profilePage();
      return userInfo;
    } catch (e) {
      throw Exception("Unable to fetch user profile");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureProfileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No profile data available'));
          } else {
            final profileData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        "https://cdn4.vectorstock.com/i/1000x1000/08/38/avatar-icon-male-user-person-profile-symbol-vector-20910838.jpg",
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Name: ${profileData['name']}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Email: ${profileData['email']}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 30),
                    Divider(),
                    SizedBox(height: 10),
                    buildProfileInfoItem('Phone Number', profileData['phone'] ?? 'Not provided'),
                    buildProfileInfoItem('Address', profileData['address'] ?? 'Not provided'),
                    buildProfileInfoItem('Date of Birth', profileData['dob'] ?? 'Not provided'),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildProfileInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
