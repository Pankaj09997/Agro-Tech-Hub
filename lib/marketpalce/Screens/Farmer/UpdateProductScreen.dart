import 'dart:io';
import 'package:flutter/material.dart';
import 'package:agrotech_app/api.dart';

class UpdateProductScreen extends StatefulWidget {
  final int productId;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;

  UpdateProductScreen({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
  });

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _descriptionController.text = widget.description;
    _priceController.text = widget.price.toString();
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final response = await _apiService.updateProduct(
          widget.productId,
          _nameController.text,
          _image,
          _descriptionController.text,
          double.parse(_priceController.text),
        );
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product updated successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Failed to update product')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    // Implement image picking logic here (e.g., using image_picker package)
    // Example:
    // final picker = ImagePicker();
    // final pickedFile = await picker.getImage(source: ImageSource.gallery);
    // setState(() {
    //   _image = File(pickedFile!.path);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter product name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter description' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter price' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              if (_image != null) ...[
                Image.file(_image!),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProduct,
                child: Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
