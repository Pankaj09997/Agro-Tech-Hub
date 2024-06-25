// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class button extends StatelessWidget {
  final String text;
  final  VoidCallback onPressed;
  const button({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap:onPressed ,
      child: Container(
        height: height * 0.05,
        width: height * 0.13,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.green,
        ),
        child: Center(
          child: Text(text),
        ),
      ),
      
    );
  }
}
