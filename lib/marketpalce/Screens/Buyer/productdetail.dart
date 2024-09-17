import 'package:agrotech_app/api.dart';
import 'package:flutter/material.dart';

class BuyerDetailPage extends StatefulWidget {
  final int productId;

  const BuyerDetailPage({Key? key, required this.productId}) : super(key: key);

  @override
  _BuyerDetailPageState createState() => _BuyerDetailPageState();
}

class _BuyerDetailPageState extends State<BuyerDetailPage> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _productDetailFuture;

  @override
  void initState() {
    super.initState();
    _productDetailFuture = _apiService.BuyerDetailView(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _productDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final product = snapshot.data!;
            final baseUrl = 'http://127.0.0.1:8000';
            final imageUrl = product['productimage'] ?? '';
            final fullurl = '$baseUrl$imageUrl';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display Product Image if available
                  if (fullurl.isNotEmpty)
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          fullurl,
                          fit: BoxFit.cover,
                          height: 250.0,
                          width: double.infinity,
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Container(
                        height: 250.0,
                        color: Colors.grey[300],
                        child: Icon(Icons.image, size: 100),
                      ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    product['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Price: \$${product['price']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 16),
                  Text(
                    product['description'],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle purchase logic here
                    },
                    child: Text('Buy Now'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No product details available.'));
          }
        },
      ),
    );
  }
}
