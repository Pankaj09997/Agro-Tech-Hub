// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Textfield extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintString;
  final IconButton? icon;
  final bool obsecureText;
  final String Function(String?)? validator;
  final Icon ?prefixIcon;

  final RegExp? regExp;

  const Textfield({
    Key? key,
    required this.textEditingController,
    required this.hintString,
    this.icon,
    this.obsecureText = true,
    this.regExp,
    this.validator,
    this.prefixIcon
  }) : super(key: key);

  @override
  State<Textfield> createState() => _TextfieldState();
}

class _TextfieldState extends State<Textfield> {
  final TextEditingController _passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obsecureText,
      controller: widget.textEditingController,
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'You cannot leave this field this empty';
            }
            if (widget.regExp != null && !widget.regExp!.hasMatch(value)) {
              return 'Invalid E-mail Format ';
            }
            if (value != _passwordcontroller) {
            } else {
              return null;
            }
          },
      decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintString,
          suffixIcon: widget.icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          )),
    );
  }
}
