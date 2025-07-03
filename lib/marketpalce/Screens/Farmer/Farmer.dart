
import 'package:flutter/material.dart';
import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/marketpalce/Screens/Farmer/AddProductScreen.dart';
import 'package:agrotech_app/marketpalce/Screens/Farmer/UpdateProductScreen.dart';
import 'package:flutter/widgets.dart';

class FarmerProductsScreen extends StatefulWidget {
  @override
  _FarmerProductsScreenState createState() => _FarmerProductsScreenState();
}

class _FarmerProductsScreenState extends State<FarmerProductsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _products;

  final String baseUrl = 'http://127.0.0.1:8000';

  @override
  void initState() {
    super.initState();
    _products = _apiService.fetchAllProducts(); // Fetch user's products
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddProductScreen()),
          );
        },
        child: Icon(Icons.add, size: 30),
        backgroundColor: Colors.green,
        tooltip: 'Add Product',
      ),
      appBar: AppBar(
        title: Text('My Products'),
        backgroundColor: Colors.green,

      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No products found.',
                    style: TextStyle(fontSize: 18, color: Colors.grey)));
          }

          final products = snapshot.data!;
          return ListView.builder(
            padding:
                EdgeInsets.all(8.0), // Increased padding around the ListView
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final imageUrl = product['productimage'];
              final fullImageUrl = '$baseUrl$imageUrl';

              // Convert price to double
              final priceString = product['price'].toString();
              final price = double.tryParse(priceString) ?? 0.0;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => UpdateProductScreen(
                              productId: product['id'],
                              name: product['name'],
                              description: product['description'],
                              price: price))); // Pass price as double
                },
                child: Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 8.0), // Increased margin
                  child: Card(
                    color: Colors.white,
                    elevation: 2, // Enhanced shadow
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Rounded corners
                    ),
                    child: SizedBox(
                      height: 150, // Increased height
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                            ),
                            child: Image.network(
                              fullImageUrl,
                              width: 150, // Increased width
                              height: 200, // Increased height
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  16.0), // Increased padding inside the card
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    product['name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 20, // Larger font size
                                          fontWeight: FontWeight.bold,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    '\Rs ${price.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 18, // Larger font size
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
