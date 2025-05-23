
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'add_items.dart';
import 'user model.dart';
import 'product_detail.dart';

class ProductInventory extends StatefulWidget {
  @override

  State<ProductInventory> createState() => _ProductInventoryState();
}
class _ProductInventoryState extends State<ProductInventory> {
  final _dbRef = FirebaseDatabase.instance.ref().child('products');
  List<Userss> products = [];

  String selectedCategory = "All Items";

  List<Userss> get filteredProducts {
    if (selectedCategory == "All Items") return products;
    return products.where((product) => product.category == selectedCategory).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    final snapshot = await _dbRef.get();  //_dbRef refers to the Firebase products node    .get() fetches all data under that node once, snapshot holds the result.
    final List<Userss> loaded = [];  // Creates an empty list to store the converted product objects.

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);  // snapshot.value is the actual Firebase data (all the products).

      data.forEach((key, value) {
        loaded.add(Userss.fromMap(Map<String, dynamic>.from(value)));
      });
    }

    setState(() {
      products = loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Barter Maketplace",style: TextStyle(color: Colors.white),), centerTitle: true,backgroundColor: Colors.purple,),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All Items", "Bikes", "Clothes", "Laptops"].map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: selectedCategory == category,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: filteredProducts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                //final imageBytes = base64Decode(product.image);

                 return
                InkWell(
                    onTap: () {
                  Navigator.push(
                    context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: product),
                      ));
                  //   MaterialPageRoute(builder: (_) => AddItemPage(entry: product)),
                  // ).then((_) => fetchProducts());
                },
                child:
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.memory(
                            base64Decode(product.image),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.itemname,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            // Text(product.descripton, style: TextStyle(fontSize: 12)),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.purple),
                                Text( "${product.city}"),
                                SizedBox(width: 4),]),
                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            //   decoration: BoxDecoration(
                            //     color: Colors.green[100],
                            //     borderRadius: BorderRadius.circular(4),
                            //   ),
                            //   child: Text(
                            //     "${product.saleprice} PKR",
                            //     style: TextStyle(
                            //         color: Colors.green[800],
                            //         fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.add_task, size: 16, color: Colors.purple),
                                SizedBox(width: 4),
                                Text("Condition: ${product.condition}", style: TextStyle(fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
                );

              },
            ),
          ),

        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (_) => AddItemPage(entry: null,)))
      //         .then((_) => fetchProducts());
      //
      //   },
      //   child: Icon(Icons.add,color: Colors.white),
      //   backgroundColor: Colors.purple,
      // ),
    );
  }
}

