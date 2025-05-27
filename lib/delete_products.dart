import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user model.dart';
import 'add_items.dart';

class DeleteProductsPage extends StatefulWidget {
  const DeleteProductsPage({Key? key}) : super(key: key);

  @override
  State<DeleteProductsPage> createState() => _DeleteProductsPageState();
}

class _DeleteProductsPageState extends State<DeleteProductsPage> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref().child('products');

  List<MapEntry<String, Userss>> _productsWithKeys = [];

  @override
  void initState() {
    super.initState();
    _listenToProducts();
  }

  void _listenToProducts() {
    _ref.onValue.listen((event) {
      final data = event.snapshot.value;
      List<MapEntry<String, Userss>> loaded = [];

      if (data != null && data is Map) {
        data.forEach((key, value) {
          final user = Userss.fromMap(Map<String, dynamic>.from(value));
          loaded.add(MapEntry(key, user));
        });
      }

      setState(() {
        _productsWithKeys = loaded;
      });
    });
  }

  void _deleteProduct(String key) {
    _ref.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product deleted")),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete product")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete / Edit Products",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: _productsWithKeys.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _productsWithKeys.length,
        itemBuilder: (context, index) {
          final entry = _productsWithKeys[index];
          final key = entry.key;
          final product = entry.value;

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: MemoryImage(base64Decode(product.image)),
              ),
              title: Text(product.itemname),
              subtitle: Text("City: ${product.city}"),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteProduct(key),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddItemPage(entry: product),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
