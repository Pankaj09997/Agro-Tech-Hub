import 'package:agrotech_app/colors/Colors.dart';
import 'package:agrotech_app/marketpalce/Screens/Buyer/Buyer.dart';
import 'package:agrotech_app/marketpalce/Screens/Farmer/Farmer.dart';
import 'package:flutter/material.dart';
import 'package:agrotech_app/api.dart';
// Import the BuyerScreen

class RoleSelectionScreen extends StatefulWidget {
  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;
  final List<String> _roles = ['farmer', 'buyer'];
  final ApiService _apiService = ApiService(); // Create an instance of ApiService

  Future<void> _submitRole() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a role')),
      );
      return;
    }

    try {
      final result = await _apiService.selectRole(_selectedRole!);

      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Role selected successfully')),
        );
        
        // Navigate to the appropriate screen based on the selected role
        if (_selectedRole == 'farmer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FarmerProductsScreen()),
          );
        } else if (_selectedRole == 'buyer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BuyerScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Failed to select role')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Your Role'),
      backgroundColor: colorsPallete.appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [    Text("Select your preferred role:",style: TextStyle(fontSize: 15),),
              SizedBox(width: 10,),
            DropdownButton<String>(
              value: _selectedRole,
              hint: Text('Select Role'),
              items: _roles.map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role.capitalize()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
            ),],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitRole,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringCapitalizeExtension on String {
  String capitalize() {
    return this.isEmpty ? this : this[0].toUpperCase() + this.substring(1).toLowerCase();
  }
}
