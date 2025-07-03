import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/marketpalce/Screens/Buyer/Form.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ApiService _apiService = ApiService();
  final String baseurl = "http://127.0.0.1:8000";

  double _calculateTotalPrice(List<dynamic> cartItems) {
    double total = 0;
    for (var item in cartItems) {
      final price = (item['item']['price'] is String)
          ? double.tryParse(item['item']['price']) ?? 0
          : item['item']['price'] ?? 0;

      final quantity = item['quantity'] ?? 1;

      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _apiService.fetchCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items in cart.'));
          }

          final cartItems = snapshot.data!;

          final totalPrice = _calculateTotalPrice(cartItems);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    final itemId = cartItem['item']['name'];
                    final quantity = cartItem['quantity'] ?? 1;
                    final priceAtTheTime = cartItem['item']['price'] ?? 'N/A';
                    final productName = "Product Name: $itemId";
                    final productImage = cartItem['item']['productimage'];
                    final fullImageUrl = "$baseurl$productImage";

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
                              flex: 1,
                              child: productImage != null
                                  ? Image.network(
                                      fullImageUrl,
                                      height: 80.0,
                                      width: 80.0,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 80.0,
                                      width: 80.0,
                                      color: Colors.grey,
                                      child: Icon(Icons.image_not_supported),
                                    ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    productName,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text('Quantity: $quantity'),
                                  SizedBox(height: 8.0),
                                  Text('Price: Rs $priceAtTheTime'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'RS ${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Your Order Has Been placed Sucessfully")));
                        print("Proceed to buy items");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => FormPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
