import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
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

Future<Map<String, dynamic>> postFunction(String post, File? image, File? file) async {
  //multipart file system is used to add multiple files,images,post in the single http request
  var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/post/'));
//This line adds a text field named post with the value stored in the post variable to the HTTP request.
  request.fields['post'] = post;
// This line initiates the process of adding a file to the files list of the multipart request.
// request.files is a list that holds all the files to be uploaded with the request.
// add is a method that appends a new file to this list.
  if (image!= null) {
// This line initiates the process of adding a file to the files list of the multipart request.
// request.files is a list that holds all the files to be uploaded with the request.
// add is a method that appends a new file to this list.
    request.files.add(
//This line calls the constructor http.MultipartFile.fromBytes to create a new MultipartFile object from raw bytes.

      http.MultipartFile.fromBytes(
        'image',
        //convert the selected image to bytes
        await image.readAsBytes(),
        filename: image.path.split('/').last,
      ),
    );
  }

  if (file!= null) {
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
    return {'status': 'failed'};
  }
}
}
