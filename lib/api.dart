import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  String? _token;
  final String baseUrl = "http://127.0.0.1:8000/api";
// shared preferences to store the token
  Future<void> _loadToken() async {
    // instance to get the access to the shared preferences storage
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    // jwt_token is the key under which token is stored whenever retrireving the token we just need to use key i.e is 'jwt_token'
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

  Future<Map<String, dynamic>> postFunction(
      String post, File? image, File? file) async {
    await _loadToken();
    if (_token == null) {
      throw Exception('User is not authenticated');
    }
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/post/'));
    request.headers['Authorization'] = 'Bearer $_token';
    request.fields['content'] = post;

    if (image != null) {
      // adding something to the request
      request.files.add(
        //convert the added itm to bytes for easy transfomation
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
          'pdf',
          await file.readAsBytes(),
          filename: file.path.split('/').last,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      return {'status': 'success', 'data': jsonDecode(responseBody)};
    } else {
      final responseBody = await response.stream.bytesToString();
      return {
        'status': 'failed',
        'message': response.reasonPhrase,
        'response': responseBody
      };
    }
  }

  Future<List<dynamic>> postAll() async {
    await _loadToken();
    if (_token == null) {
      throw Exception("User is not authenticated");
    }
    final response = await http.get(
      Uri.parse('$baseUrl/postall/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token'
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> posts = jsonDecode(response.body);
      return posts;
    } else {
      throw Exception("Failed to load posts: ${response.body}");
    }
  }

  Future<List<dynamic>> commentView(int postId) async {
    await _loadToken();
    if (_token == null) {
      throw Exception("User is not authenticated");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/posts/$postId/comments/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> comments = jsonDecode(response.body);
      return comments;
    } else {
      throw Exception("Failed to load comments: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> profilePage() async {
    await _loadToken();
    if (_token == null) {
      throw Exception("Unable to find the user");
    }
    final response = await http
        .get(Uri.parse("$baseUrl/profile/"), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $_token'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unable to find User");
    }
  }

  Future<Map<String, dynamic>> writeComment(String comment, int postId) async {
    try {
      await _loadToken();
      if (_token == null) {
        throw Exception("User is not authenticated");
      }
      final response = await http.post(
        Uri.parse('$baseUrl/posts/$postId/comments/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({'comment': comment}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data; // Return the response data, which includes the success message
      } else {
        throw Exception("Failed to write comment: ${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to write comment: $e");
    }
  }

  Future<Map<String, dynamic>> videoUpload(
      String caption, File? videoFile) async {
    try {
      await _loadToken();
      if (_token == null) {
        throw Exception('User is not authenticated');
      }

      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/videosUpload/'));
      request.headers['Authorization'] = 'Bearer $_token';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['caption'] = caption;

      if (videoFile != null) {
        //adding the file to the request file
        request.files.add(
          //convering the file to the bytes which is suitable for using
          http.MultipartFile.fromBytes(
            'video',
            //reading the videos as bytes
            await videoFile.readAsBytes(),
            filename: videoFile.path.split('/').last,
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        //changing the videos to string because the data is in bytes
        final responseBody = await response.stream.bytesToString();
        return {'status': 'success', 'data': jsonDecode(responseBody)};
      } else {
        final responseBody = await response.stream.bytesToString();
        return {
          'status': 'failed',
          'message': response.reasonPhrase,
          'response': responseBody
        };
      }
    } catch (e) {
      throw Exception('Error uploading video: $e');
    }
  }

  Future<List<Map<String, dynamic>>> allVideos() async {
    await _loadToken();
    if (_token == null) {
      throw Exception("Unauthorized User");
    }
    final response = await http.get(
      Uri.parse('$baseUrl/videosall/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Error ${response.body}");
    }
  }

  Future<Map<String, dynamic>> changePassword(
      String password, String password2) async {
    await _loadToken();
    if (_token == null) {
      throw Exception("User is not authorized");
    }
    final response = await http.post(
      Uri.parse("$baseUrl/changepassword/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'password': password,
        'password2': password2,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // Assuming the API returns a new token on successful password change
    } else {
      throw Exception("Unable to change password: ${response.body}");
    }
  }

  Future<List<dynamic>> fetchUsers() async {
    await _loadToken();
    if (_token == null) {
      throw Exception("User is not authenticated");
    }
    final response = await http.get(Uri.parse("$baseUrl/usersall/"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unable to Fetch the users");
    }
  }
}
