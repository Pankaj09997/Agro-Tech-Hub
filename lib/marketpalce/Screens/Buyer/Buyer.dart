import 'package:agrotech_app/api.dart';

import 'package:flutter/material.dart';

class BuyerScreen extends StatelessWidget {
  final ApiService apiService = ApiService(); // Initialize ApiService instance
  final String baseUrl = 'http://127.0.0.1:8000'; // Define the base URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
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
              final productId = product['id']; // Ensure you extract the product ID

              // Construct the full image URL
              final fullImageUrl = imageUrl != null ? '$baseUrl$imageUrl' : null;

              return Card(
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
                              ? Image.network(fullImageUrl, fit: BoxFit.cover, height: 150.0)
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
                              style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '\$${productPrice.toString()}',
                              style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.green),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              productDescription,
                              style: Theme.of(context).textTheme.bodyText2,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(height: 8.0),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle button press
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue, // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0), // Button shape
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                ),
                                child: Text('Buy'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
