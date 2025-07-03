import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/marketpalce/Screens/Buyer/cart.dart';
import 'package:agrotech_app/marketpalce/Screens/Buyer/productdetail.dart';
import 'package:agrotech_app/screen/homepage.dart';
import 'package:flutter/material.dart';

class BuyerScreen extends StatelessWidget {
  final ApiService apiService = ApiService(); // Initialize ApiService instance
  final String baseUrl = 'https://agro-tech-hub-api.onrender.com'; // Define the base URL

  // Function to handle adding a product to the cart
  void _addToCart(BuildContext context, int productId) async {
    try {
      // Call the ApiService to add the item to the cart
      await apiService.addtocart(productId, 1); // Default quantity is 1

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added to cart!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Handle any errors that might occur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding product to cart: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        automaticallyImplyLeading: true,
        leading:          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (_) => HomePage()), 
                      (Route<dynamic> route) => false,
                    );
              },
              icon: Icon(Icons.arrow_back)),
        actions: [

          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => CartPage()));
            },
            icon: const Icon(Icons.shopping_cart),
            iconSize: 25,
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: apiService.fetchAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available.'));
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final imageUrl = product['productimage'];
              final productName = product['name'];
              final productPrice = product['price'];
              final productDescription = product['description'];
              final productId =
                  product['id']; // Ensure you extract the product ID

              // Construct the full image URL
              final fullImageUrl =
                  imageUrl != null ? '$baseUrl$imageUrl' : null;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              BuyerDetailPage(productId: productId)));
                },
                child: Card(
                  margin: EdgeInsets.all(16.0),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: fullImageUrl != null
                                ? Image.network(fullImageUrl,
                                    fit: BoxFit.cover, height: 150.0)
                                : Container(color: Colors.grey, height: 150.0),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                productName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '\Rs ${productPrice.toString()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.green),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                productDescription,
                                style: Theme.of(context).textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              SizedBox(height: 8.0),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Call _addToCart when the button is pressed
                                    _addToCart(context, productId);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.blue, // Background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Button shape
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                  ),
                                  child: const Text(
                                    'Add to cart',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
