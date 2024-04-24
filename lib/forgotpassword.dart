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
    bool _obsecureText=false;
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: const Color.fromARGB(255, 91, 172, 10),
      ),
      body: _orientation==Orientation.portrait?
      //code for portrait
      Column(
         children: [

         ],
      )
      :
      //code for landscape
      Column(
        children: [
          
        ],
      )
      ,
    );
  }
}
