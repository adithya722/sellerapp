// ignore_for_file: unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellerpage/routes.dart';

class Productadd extends StatefulWidget {
  const Productadd({Key? key}) : super(key: key);

  @override
  State<Productadd> createState() => _ProductaddState();
}

class _ProductaddState extends State<Productadd> {
  final List<String> categories = [
    "Fashion",
    "Snacks",
    "Electronics",
    "Mobiles",
    "Home appliances",
    "Grocery",
    "Clothes"
  ];

  String? selectedCategory;
  TextEditingController brand = TextEditingController();
  TextEditingController price = TextEditingController();
TextEditingController desc = TextEditingController();

  File? profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Seller Central",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 78, 46, 35),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // SizedBox(height: 6,),
                        // Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                      ],
                    ),
                  ),
                 
                ],
              ),
            ),
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: () async {
                  XFile? image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                   
                  );
                  if (image != null) {
                    setState(() {
                      profile = File(image.path);
                    });
                  }
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 201, 196, 196),
                  ),
                  child: profile != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(profile!),
                          radius: 30,
                        )
                      : Icon(
                          Icons.add_a_photo,
                          size: 48,
                          color: Colors.grey[700],
                        ),
                ),
              ),
            ),
            SizedBox(height: 25),
            TextFormField(
              controller: brand,
              decoration: InputDecoration(
                labelText: "Brand Name",
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 102, 101, 101),
                ),
              ),
            ),
            SizedBox(height: 25),
            TextFormField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Price",
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 102, 101, 101),
                ),
              ),
            ),
             SizedBox(height: 25),
            TextFormField(
              controller: desc,
          
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 102, 101, 101),
                ),
              ),
            ),
            SizedBox(height: 25),

            

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Category",
              ),
              value: selectedCategory,
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                if (profile == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please select an image"),
                    ),
                  );
                  return;
                }

                UploadTask task = FirebaseStorage.instance
                    .ref()
                    .child("Products")
                    .child("${brand.text.trim()}.png")
                    .putFile(profile!);
                TaskSnapshot taskSnapshot = await task;
                String url = await taskSnapshot.ref.getDownloadURL();
                await FirebaseFirestore.instance.collection("Products").add({
                  "Brand Name": brand.text.trim(),
                  "Price": price.text.trim(),
                  "Description": desc.text.trim(),
                  "Category": selectedCategory,
                 
                  "Image": url,
                  "email": FirebaseAuth.instance.currentUser?.email,
                });
                brand.clear();
                price.clear();
               desc.clear();
                setState(() {
                  profile = null;
                });
                Navigator.pushNamed(context, Routes.productlist);
              },
              child: Text("Add Product"),
            ),
          ],
        ),
      ),
    );
  }
}
