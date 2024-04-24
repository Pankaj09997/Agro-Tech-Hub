import 'package:agrotech_app/forgotpassword.dart';
import 'package:agrotech_app/homepage.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  const login({Key? key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obsecureText = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final _orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text("Agro-Tech Hub"),
        backgroundColor: const Color.fromARGB(255, 91, 172, 10),
      ),
      body: _orientation == Orientation.portrait
          ? Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align children to the start
              children: [
                SizedBox(height: 25), // Add SizedBox to create space
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Welcome To Agro-Tech Hub!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Enter Your E-mail",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("This Field cannot be empty")));
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    obscureText: _obsecureText,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obsecureText = !_obsecureText;
                            });
                          },
                          icon: _obsecureText
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ForgotPassword()));
                    },
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => homepage()));
                    },
                    child: Container(
                      height: height * 0.05,
                      width: height * 0.13,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.green),
                      child: Center(
                        child: Container(
                          child: Text("Login"),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Don't Have an Account?"),
                    ),
                    Text(
                      " Signup",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:
                      Container(alignment: Alignment.center, child: Text("OR")),
                ),
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
                        Text("Sign in with Google")
                      ],
                    ),
                  ),
                )
              ],
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Enter Your E-mail",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _emailController,
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      obscureText: _obsecureText,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obsecureText = !_obsecureText;
                              });
                            },
                            icon: _obsecureText
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility)),
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
                        )),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => homepage()));
                      },
                      child: Container(
                        height: height * 0.1,
                        width: height * 0.30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.green),
                        child: Center(
                          child: Container(
                            child: Text("Login"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("Don't Have an Account?"),
                      ),
                      Text(
                        " Signup",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                        alignment: Alignment.center, child: Text("OR")),
                  ),
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
                              height: height * 2,
                            ),
                          ),
                          SizedBox(width: 8), // Add SizedBox for gap
                          Text("Sign in with Google")
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
