import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  ProductDetailScreen({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(imageUrl, fit: BoxFit.cover),
            SizedBox(height: 16.0),
            Text(name, style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 8.0),
            Text('\$${price.toString()}', style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 16.0),
            Text(description),
          ],
        ),
      ),
    );
  }
}
