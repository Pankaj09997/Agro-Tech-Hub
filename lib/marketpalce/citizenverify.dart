import 'dart:io';
import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/colors/Colors.dart';
import 'package:agrotech_app/marketpalce/roles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CitizenshipVerificationScreen extends StatefulWidget {
  @override
  _CitizenshipVerificationScreenState createState() =>
      _CitizenshipVerificationScreenState();
}

class _CitizenshipVerificationScreenState
    extends State<CitizenshipVerificationScreen> {
  File? _citizenshipCard;
  final ApiService _apiService = ApiService();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _citizenshipCard = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitVerification() async {
    if (_citizenshipCard == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload a citizenship card')),
      );
      return;
    }

    try {
      final result =
          await _apiService.submitCitizenshipVerification(_citizenshipCard);

      // Debug prints to check the result
      print("Verification result: $result");

      // Check if result is a Map and handle it accordingly
      if (result is Map) {
        final status = result['status'];
        final response = result['response'];

        if (response != null || response['is_verified'] == true) {
          // Navigate to RoleSelection page if verification is complete
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
          );
        } else {
          // Check the status and show a message if processing or failed
          if (status == 'processing') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(result['message'] ??
                      'Your verification request is pending.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      result['message'] ?? 'Failed to submit verification')),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected response format')),
        );
      }
    } catch (e) {
      // Log or display error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Citizenship Verification'),
      backgroundColor: colorsPallete.appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _citizenshipCard != null
                  ? Image.file(_citizenshipCard!)
                  : Text('No citizenship card selected'),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: colorsPallete.appBarColor),
                onPressed: _pickImage,
                child: Text('Select Citizenship Card',style: TextStyle(color: Colors.white),),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitVerification,
                child: Text('Submit for Verification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
