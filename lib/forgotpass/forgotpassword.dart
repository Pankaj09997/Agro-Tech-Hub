import 'package:agrotech_app/forgotpass/otp.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final _orientation = MediaQuery.of(context).orientation;
    final _formKey = GlobalKey<FormState>();

    TextEditingController _emailController = TextEditingController();

    final _formState = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Forgot Password"),
          backgroundColor: const Color.fromARGB(255, 91, 172, 10),
        ),
        body: _orientation == Orientation.portrait
            ?
            //code for portrait
            Column(
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Welcome To Agro-Tech Hub!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Enter Your E-mail",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'You cannot leave this field empty';
                        } else {
                          return null;
                        }
                      },
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "E-mail",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16))),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("OTP has been successfully sent"),
                            duration: Duration(seconds: 2),
                          ));
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => otp()));
                        }
                      },
                      child: Container(
                        height: height * 0.05,
                        width: height * 0.13,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.green),
                        child: Center(
                          child: Container(
                            child: Text("Send OTP"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            :
            //code for landscape
            Column(
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Welcome To Agro-Tech Hub!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Enter Your E-mail",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "E-mail",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16))),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("OTP has been successfully sent to ypur E-mail"),
                            duration: Duration(seconds: 2),
                          ));
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => otp()));
                        }
                      },
                      child: Container(
                        height: height * 0.1,
                        width: height * 0.25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.green),
                        child: Center(
                          child: Container(
                            child: Text("Send OTP"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
