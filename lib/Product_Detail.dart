import 'dart:convert';
import 'package:flutter/material.dart';
import 'user model.dart';
class ProductDetailPage extends StatelessWidget {
  final Userss product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    final image = base64Decode(product.image);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.itemname,style:   TextStyle(color: Colors.white), ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.memory(image, fit: BoxFit.cover, width: double.infinity, height: 250),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.itemname, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  // Text("Category: ${product.category}", style: TextStyle(fontSize: 16)),
                  // SizedBox(height: 10),
                  Text("City: ${product.city}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Condition: ${product.condition}/10", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        TextSpan(text: "Description: ", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: product.descripton),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: Icon(Icons.chat,color: Colors.white,),
                    label: Text("Chat",),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors. blueGrey,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      // Future feature: Navigate to chat screen with product.sellerId
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Chat feature coming soon!"))
                      );
                    },
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                      children: [
                       ElevatedButton( onPressed: () {}, child: Text("Buy Now"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                        Text("   or   "),
                        ElevatedButton( onPressed: () {}, child: Text("Borrow"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                       ]
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

