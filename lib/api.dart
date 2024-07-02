import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  String? _token;
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
  }
//  saves the JWT token under the key 'jwt_token' in the shared preferences.
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

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
      await _saveToken(_token!);
      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
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
      await _saveToken(_token!);
      return data;
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> userInfo() async {
    await _loadToken();
    if (_token == null) {
      throw Exception('User is not authenticated');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/profile/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> postFunction(
      String post, File? image, File? file) async {
    await _loadToken();
    if (_token == null) {
      throw Exception('User is not authenticated');
    }
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/post/'));
    request.headers['Authorization'] = 'Bearer $_token';
    request.fields['post'] = post;
    if (image != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          await image.readAsBytes(),
          filename: image.path.split('/').last,
        ),
      );
    }

    if (file != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          await file.readAsBytes(),
          filename: file.path.split('/').last,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      return {'status': 'success'};
    } else {
      return {'status': 'failed', 'message': response.reasonPhrase};
    }
  }
}
