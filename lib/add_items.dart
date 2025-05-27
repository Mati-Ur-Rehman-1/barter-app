import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_barter_marketplace/main_navigation.dart';
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
  final  _picker = ImagePicker();

  XFile? _image;
  String? _base64Image;
  Uint8List? _imageBytes;
  String? selectedCategory;
  String? selectedCondtion;



  final itemName = TextEditingController();
  final descripton = TextEditingController();
   final category = TextEditingController();
   final condition = TextEditingController();
  final city = TextEditingController();


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
        city: city.text,
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
           category: selectedCategory!,
           condition: selectedCondtion!,
          city: city.text,
          image: _base64Image ?? "",
        );

        await _database.child('products').child(uid).set(user.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product saved successfully!")),
        );

// Safely navigate back or replace the screen
        Future.delayed(Duration(milliseconds: 300), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainNavigation()), // Replace with your actual screen
            );
          }
        });

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
      city.text = item.city;
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
          backgroundColor: Colors.teal, centerTitle: true),
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
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: ['English', 'Poetry', 'Novel'].map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedCategory = newValue!;
          });
        },
      ),
    ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: DropdownButtonFormField<String>(
                value: selectedCondtion,
                decoration: InputDecoration(
                  labelText: 'Condition',
                  hintText: 'rate out o 10',

                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: ['10', '9', '8', '7', '6', '5', '4', '3', '2', '1'].map((String condition) {
                  return DropdownMenuItem<String>(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCondtion = newValue!;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: TextField(
                controller: city,
                decoration: InputDecoration(
                  labelText: "location",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
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
        backgroundColor: Colors.teal,
      ),

    );
  }

}


