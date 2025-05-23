
import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'user model.dart';
import 'delete_products.dart';


class AddItemPage extends StatefulWidget {
  final Userss? entry;
  const AddItemPage({super.key,required this.entry});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _database = FirebaseDatabase.instance.ref();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _base64Image;
  Uint8List? _imageBytes;


  final itemName = TextEditingController();
  final descripton = TextEditingController();
  final category = TextEditingController();
  final condition = TextEditingController();
  final unit = TextEditingController();
  final city = TextEditingController();
  final purchaseprice = TextEditingController();
  final taxin = TextEditingController();
  final taxinprice = TextEditingController();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = picked);
      final bytes = await picked.readAsBytes();
      _base64Image = base64Encode(bytes);
    }
  }

  void _saveToDatabase() async {
    String uid = _database.push().key.toString();


    if(widget.entry!=null){
      final user = Userss(
        uid: uid,
        itemname: itemName.text,
        descripton: descripton.text,
        category: category.text,
        condition: condition.text,
        unit: unit.text,
        city: city.text,
        purchaseprice: purchaseprice.text,
        taxin: taxin.text,
        taxinprice: taxinprice.text,
        image: _base64Image ?? "",
      );
      await _database.child('products').child(widget.entry!.uid).set(user.toMap()).then((_){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated')));
      });

    }else{
      try {
        final user = Userss(
          uid: uid,
          itemname: itemName.text,
          descripton: descripton.text,
          category: category.text,
          condition: condition.text,
          unit: unit.text,
          city: city.text,
          purchaseprice: purchaseprice.text,
          taxin: taxin.text,
          taxinprice: taxinprice.text,
          image: _base64Image ?? "",
        );

        await _database.child('products').child(uid).set(user.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product saved successfully!")),
        );

        Navigator.pop(context);
      } catch (e) {
        print("Error saving product: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save product.")),
        );
      }
    }
  }

  @override
  void initState() {
    if(widget.entry!=null){
      final item = widget.entry!;
      itemName.text = item.itemname;
      descripton.text = item.descripton;
      category.text = item.category;
      condition.text = item.condition;
      unit.text = item.unit;
      city.text = item.city;
      purchaseprice.text = item.purchaseprice;
      taxin.text = item.taxin;
      taxinprice.text = item.taxinprice;
      if (item.image.isNotEmpty) {
        try {
          _base64Image = item.image;
          _imageBytes = base64Decode(item.image);
        } catch (e) {
          print("Failed to decode image: $e");
        }
      }

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Item",style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.purple, centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 150,

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),

                ),
                child: Center(
                  child: _image != null
                      ? kIsWeb
                      ? Image.network(_image!.path)
                      : Image.file(File(_image!.path))
                      : _imageBytes != null
                      ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                      : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 30),
                      Text("Tap to add image"),
                    ],
                  ),
                ),

              ),
            ),
            // CircleAvatar(
            //   backgroundImage: MemoryImage(base64Decode(_base64Image.toString())),
            // ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: TextField(
                controller: itemName,
                decoration: InputDecoration(
                  labelText: "Items Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: TextField(
                  // expands: true,
                  maxLines: 100,
                  minLines: null,
                  controller: descripton,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: TextField(
                controller: category,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      category.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return ['Bikes', 'Clothes', 'Laptops'].map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: TextField(
                      controller: condition,
                      decoration: InputDecoration(
                        labelText: "condition",
                        hintText: " 'write condition like'  _/10",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: TextField(
                      controller: unit,
                      decoration: InputDecoration(
                        labelText: "Unit",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        suffixIcon: PopupMenuButton<String>(
                          icon: const Icon(Icons.arrow_drop_down),
                          onSelected: (String value) {
                            unit.text = value;
                          },
                          itemBuilder: (BuildContext context) {
                            return ['Pcs', 'Bundles'].map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: TextField(
                      controller: city,
                      decoration: InputDecoration(
                        labelText: "City",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: TextField(
                      controller: purchaseprice,
                      decoration: InputDecoration(
                        labelText: "Purchase Price",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),

              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: TextField(
                      controller: taxin,
                      decoration: InputDecoration(
                        labelText: "Tax in %",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: TextField(
                      controller: taxinprice,
                      decoration: InputDecoration(
                        labelText: "Tax in Price",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),

              ],
            ),
            Row(
              children: [
                Text("Delete any previously added item",style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold
                ),)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 35,
                 child: ElevatedButton(onPressed: (){    Navigator.push(context, MaterialPageRoute(builder: (_) => DeleteProductsPage()));
                  },
                     child: Text("Click Here",style: TextStyle(color: Colors.black, fontSize: 10,
                      fontWeight:FontWeight.bold

                  ),)),


                )],
            )

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveToDatabase,
        label: const Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold) ,),
        icon: const Icon(Icons.save_outlined,color: Colors.white,),
        backgroundColor: Colors.purple,
      ),
    );
  }

}
