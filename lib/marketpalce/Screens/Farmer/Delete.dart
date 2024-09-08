import 'package:agrotech_app/api.dart';
import 'package:flutter/material.dart';


class ProductDetailScreen extends StatelessWidget {
  final int productId;

  ProductDetailScreen({required this.productId});

  final ApiService _apiService = ApiService();

  Future<void> _deleteProduct(BuildContext context) async {
    try {
      final response = await _apiService.deleteProduct(productId);
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product deleted successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to delete product')),
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
      appBar: AppBar(title: Text('Product Details')),
      body: Center(child: Text('Product details here...')), // Placeholder for product details
      floatingActionButton: FloatingActionButton(
        onPressed: () => _deleteProduct(context),
        child: Icon(Icons.delete),
        backgroundColor: Colors.red,
      ),
    );
  }
}
