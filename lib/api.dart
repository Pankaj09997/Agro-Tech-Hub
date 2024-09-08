import 'dart:convert';
import 'dart:ffi';
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
      print(_token);
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

  Future<String?> getToken() async {
    await _loadToken();
    return _token;
  }

  Future<List<dynamic>> fetchExpenses() async {
    await _loadToken();
    if (_token == null) {
      throw Exception("User is not authenticated");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/expenses/'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  Future<void> addExpense(Map<String, dynamic> expenseData) async {
    await _loadToken();
    if (_token == null) {
      throw Exception("User is not authenticated");
    }

    final response = await http.post(
      Uri.parse('$baseUrl/expenses/'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: json.encode(expenseData),
    );

    if (response.statusCode != 201) {
      print("Error response: ${response.body}");
      throw Exception('Failed to add expense');
    }
  }

  Future<Map<String, dynamic>> submitCitizenshipVerification(
      File? citizenshipCard) async {
    await _loadToken(); // Load the token for authentication
    if (_token == null) {
      throw Exception('User is not authenticated');
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/citizenship/submit/'));
    request.headers['Authorization'] =
        'Bearer $_token'; // Add the authorization header

    // Add the citizenship card if it exists
    if (citizenshipCard != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'citizenship_card',
          await citizenshipCard.readAsBytes(),
          filename: citizenshipCard.path.split('/').last,
        ),
      );
    }

    var response = await request.send(); // Send the request

    // Check for different success and failure status codes
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      return {'status': 'success', 'data': jsonDecode(responseBody)};
    } else if (response.statusCode == 202) {
      final responseBody = await response.stream.bytesToString();
      return {
        'status': 'processing',
        'message': 'Verification request is being processed',
        'response': responseBody
      };
    } else {
      final responseBody = await response.stream.bytesToString();
      return {
        'status': 'failed',
        'message': response.reasonPhrase,
        'response': responseBody
      };
    }
  }

  Future<Map<String, dynamic>> selectRole(String role) async {
    await _loadToken();
    if (_token == null) {
      throw Exception('User is not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/select-role/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({'role': role}),
    );

    // Handle the response based on status codes
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {'status': 'success', 'data': data};
    } else {
      // Use response.body to get the error message
      return {
        'status': 'failed',
        'message': response.reasonPhrase ?? 'Unknown error',
        'response': response.body
      };
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    await _loadToken();
    if (_token == null) {
      throw Exception('User is not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/products/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load products: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> fetchProduct(int productId) async {
    await _loadToken();
    if (_token == null) {
      throw Exception('User is not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/products/$productId/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load product: ${response.body}');
    }
  }

Future<Map<String, dynamic>> createProduct(
    String name, File? image, String description, double price) async {
  await _loadToken(); // Load the JWT token
  if (_token == null) {
    throw Exception('User is not authenticated');
  }

  // Create a multipart request to send both text data and the image file
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/products/add/'),
  );

  // Set headers, including authorization token
  request.headers['Authorization'] = 'Bearer $_token';
  request.headers['Content-Type'] = 'multipart/form-data';

  // Add fields to the request (name, description, price)
  request.fields['name'] = name;
  request.fields['description'] = description;
  request.fields['price'] = price.toString();

  // Add the image file to the request if it exists
  if (image != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'productimage', // Ensure this matches the Django field
        image.path,
      ),
    );
  }

  // Send the request and wait for a response
  var response = await request.send();

  // Read the response and handle it
  final responseBody = await response.stream.bytesToString();
  if (response.statusCode == 201) {
    // If the request is successful, return the decoded response
    return {'status': 'success', 'data': jsonDecode(responseBody)};
  } else {
    // If the request fails, return the error response
    return {
      'status': 'failed',
      'message': response.reasonPhrase,
      'response': responseBody
    };
  }
}


Future<Map<String, dynamic>> updateProduct(int productId, String name,
    File? image, String description, double price) async {
  await _loadToken();
  if (_token == null) {
    throw Exception('User is not authenticated');
  }

  var request = http.MultipartRequest(
      'PUT', Uri.parse('$baseUrl/products/$productId/'));  // Correct URL path
  request.headers['Authorization'] = 'Bearer $_token';
  request.headers['Content-Type'] = 'multipart/form-data';

  request.fields['name'] = name;
  request.fields['description'] = description;
  request.fields['price'] = price.toString();

  if (image != null) {
    request.files.add(
      http.MultipartFile.fromBytes(
        'productimage',
        await image.readAsBytes(),
        filename: image.path.split('/').last,
      ),
    );
  }

  var response = await request.send();

  if (response.statusCode == 200) {
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


  Future<Map<String, dynamic>> deleteProduct(int productId) async {
    await _loadToken();
    if (_token == null) {
      throw Exception('User is not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/products/$productId/'),
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 204) {
      return {'status': 'success', 'message': 'Product deleted successfully'};
    } else {
      throw Exception('Failed to delete product: ${response.body}');
    }
  }
}


