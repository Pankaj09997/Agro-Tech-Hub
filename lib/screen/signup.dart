import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/colors/Colors.dart';
import 'package:agrotech_app/colors/buttons.dart';
import 'package:agrotech_app/screen/fields.dart';
import 'package:agrotech_app/screen/homepage.dart';
import 'package:agrotech_app/login.dart';
import 'package:flutter/material.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();
  bool obsecureText = false;
  bool obsecureText2 = false;
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _apiService.registration(
          _emailcontroller.text,
          _namecontroller.text,
          _passwordcontroller.text,
          _confirmpassword.text,
        );

        print('Response: $response');

        if (response.containsKey('Token')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Successfully Signed up")),
          );
          Navigator.push(context, MaterialPageRoute(builder: (_) => Login()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to sign up: ${response}")),
          );
        }
      } catch (e) {
        print('Exception: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailcontroller.dispose();
    _namecontroller.dispose();
    _passwordcontroller.dispose();
    _confirmpassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Signup"),
          backgroundColor: colorsPallete.appBarColor,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome to Our App!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Enter Name",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Textfield(
                obsecureText: false,
                textEditingController: _namecontroller,
                hintString: "Name",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Enter E-mail",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Textfield(
                obsecureText: false,
                regExp: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
                textEditingController: _emailcontroller,
                hintString: "E-mail",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Enter Password",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Textfield(
                obsecureText: obsecureText,
                textEditingController: _passwordcontroller,
                hintString: "Password",
                icon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecureText = !obsecureText;
                      });
                    },
                    icon: obsecureText
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Confirm Password",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Textfield(
                obsecureText: obsecureText2,
                textEditingController: _confirmpassword,
                hintString: "Confirm Password",
                icon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecureText2 = !obsecureText2;
                      });
                    },
                    icon: obsecureText2
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility)),
              ),
            ),
            button(
              text: "Signup",
              onPressed: _signup,
            )
          ],
        ),
      ),
    );
  }
}
