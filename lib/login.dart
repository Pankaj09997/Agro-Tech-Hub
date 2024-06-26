import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/forgotpass/forgotpassword.dart';
import 'package:agrotech_app/screen/homepage.dart';
import 'package:agrotech_app/screen/signup.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obsecureText = true;
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _apiService.login(
            _emailController.text, _passwordController.text);
        if (response.containsKey('Token')) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Login Successful")));
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomePage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Invalid login credentials")));
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid Login Credentials: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final _orientation = MediaQuery.of(context).orientation;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Agro-Tech Hub"),
          backgroundColor: const Color.fromARGB(255, 91, 172, 10),
        ),
        body: _orientation == Orientation.portrait
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align children to the start
                  children: [
                    SizedBox(height: 25), // Add SizedBox to create space
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Welcome To Agro-Tech Hub!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Enter Your E-mail",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'You cannot leave this field empty';
                          } else if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "E-mail",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Enter Your Password",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        obscureText: _obsecureText,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'You cannot leave this field empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obsecureText = !_obsecureText;
                              });
                            },
                            icon: _obsecureText
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ForgotPassword()));
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Center(
                      child: GestureDetector(
                        onTap: _login,
                        child: Container(
                          height: height * 0.05,
                          width: height * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.green,
                          ),
                          child: Center(
                            child: Text("Login"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't Have an Account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Signuppage()));
                          },
                          child: Text(
                            " Signup",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        height: 20,
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),

                    SizedBox(height: height * 0.02),
                    Center(
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color.fromARGB(255, 232, 226, 226),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/google.png",
                                height: height * 0.04,
                              ),
                            ),
                            SizedBox(width: 8), // Add SizedBox for gap
                            Text("Sign in with Google"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align children to the start
                  children: [
                    SizedBox(height: 20), // Add SizedBox to create space
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Welcome To Agro-Tech Hub!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Enter Your E-mail",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'You cannot leave this field empty';
                          } else if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "E-mail",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Enter Your Password",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        obscureText: _obsecureText,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'You cannot leave this field empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obsecureText = !_obsecureText;
                              });
                            },
                            icon: _obsecureText
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Login Successful")));
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => HomePage()));
                          }
                        },
                        child: Container(
                          height: height * 0.1,
                          width: height * 0.30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.green,
                          ),
                          child: Center(
                            child: Text("Login"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't Have an Account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Signuppage()));
                          },
                          child: Text(
                            " Signup",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text("OR"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        height: 20,
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Center(
                      child: Container(
                        height: height * 0.1,
                        width: width * 0.55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color.fromARGB(255, 232, 226, 226),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/google.png",
                                height: height * 0.04,
                              ),
                            ),
                            SizedBox(width: 8), // Add SizedBox for gap
                            Text("Sign in with Google"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
