import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  String? _token;
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['Token']['access'];
      return data;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> registration(
      String email, String name, String password, String password2) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'name': name,
        'password': password,
        'password2': password2,
      }),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      _token = data['Token']['access'];
      return data;
    } else {
      throw Exception('Failed to sign up');
    }
  }

  Future<Map<String, dynamic>> userInfo() async {
    print('Access Token: $_token');
    final response = await http.get(
      Uri.parse('$baseUrl/profile/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  // Future<Map<String, dynamic>> postFunction(String post,String filePath,String imagePath) async {
  //   final response = await http.post(Uri.parse('$baseUrl/post/'),

  //         headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     }, 
  //     body: jsonEncode({
  //       'post':post,
  //       'filepath':filePath,
  //       'imagePath':imagePath
  //     })

  //   );
  //   if(response.statusCode==200){
      
  //   }
    

  // }
}
