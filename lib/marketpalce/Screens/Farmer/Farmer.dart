import 'package:flutter/material.dart';
import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/marketpalce/Screens/Farmer/AddProductScreen.dart';
import 'package:agrotech_app/marketpalce/Screens/Farmer/UpdateProductScreen.dart';

class FarmerProductsScreen extends StatefulWidget {
  @override
  _FarmerProductsScreenState createState() => _FarmerProductsScreenState();
}

class _FarmerProductsScreenState extends State<FarmerProductsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _products;

  // Define the base URL
  final String baseUrl =
      'http://127.0.0.1:8000'; // Use 10.0.2.2 for Android emulators

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
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text('My Products')),
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
            return Center(child: Text('No products found.'));
          }

          final products = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(8.0), // Reduced padding around the ListView
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final imageUrl = product['productimage'];
              final fullimage = '$baseUrl$imageUrl';

              // Construct the full URL for the image
              final fullImageUrl =
                  imageUrl != null ? '$baseUrl$imageUrl' : null;

              // Convert price to double if needed
              final price = double.tryParse(product['price'].toString()) ?? 0.0;

              return Container(
                margin: EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 8.0), // Reduced margin
                child: Card(
                  color: Colors.white, // Set the card color to white
                  elevation: 1, // Added shadow
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Adjusted border radius
                  ),
                  child: SizedBox(
                    height: 160, // Adjusted height for larger image
                    child: ListTile(
                      contentPadding: EdgeInsets.all(
                          8.0), // Reduced padding inside ListTile
                      leading: Image.network(fullimage,fit: BoxFit.fill,),
                      title: Text(
                        product['name'],
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              fontSize: 18, // Font size
                              fontWeight: FontWeight.bold,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              fontSize: 16, // Font size
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateProductScreen(
                              productId: product['id'],
                              name: product['name'],
                              description: product['description'],
                              price:
                                  price, // Ensure price is passed as a double
                              imageUrl: fullImageUrl,
                            ),
                          ),
                        ).then((_) {
                          // Refresh the product list after updating
                          setState(() {
                            _products = _apiService.fetchAllProducts();
                          });
                        });
                      },
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
