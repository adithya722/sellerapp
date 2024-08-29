// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sellerpage/routes.dart';

class Productlist extends StatefulWidget {
  const Productlist({Key? key}) : super(key: key);

  @override
  State<Productlist> createState() => _ProductlistState();
}

class _ProductlistState extends State<Productlist> {
  final CollectionReference productlist =
      FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                          fontSize: 20,
                          color: Color.fromARGB(255, 48, 27, 20),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Products")
              .where("email",
                  isEqualTo: FirebaseAuth.instance.currentUser?.email)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No products found!!!",
                  style: TextStyle(
                    color: Color.fromARGB(255, 164, 163, 163),
                    fontSize: 18,
                  ),
                ),
              );
            }
            final data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final productsnap = data[index].data() as Map<String, dynamic>;

                // Handle null values with default values or empty strings
                final imageUrl = productsnap["Image"] ?? "";
                final brandName = productsnap["Brand Name"] ?? "Unknown Brand";
                final price = productsnap["Price"]?.toString() ?? "N/A";
                final description = productsnap["Description"] ?? "No Description";

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.error), // Handle image loading error
                        ),
                      ),
                      title: Text(
                        brandName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price: \$${price}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Description: ${description}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    context, data[index].id, imageUrl);
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            ),
                            IconButton(
                              onPressed: () {
                                _editProduct(data[index].id, productsnap);
                              },
                              icon: Icon(Icons.edit),
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.prdctadd);
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 188, 95, 41),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String productId, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this product?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _deleteProduct(
                    context, productId, imageUrl); // Call delete function
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(BuildContext context, String productId, String imageUrl) async {
    try {
      // Delete image from Firebase Storage if imageUrl is not empty
      if (imageUrl.isNotEmpty) {
        final ref = FirebaseStorage.instance.refFromURL(imageUrl);
        // Check if the file exists before attempting deletion
        final result = await ref.getMetadata();
        if (result.size != null && result.size! > 0) {
          await ref.delete();
        } else {
          print("Image not found. It might have been already deleted.");
        }
      }

      // Delete product document from Firestore
      await FirebaseFirestore.instance.collection("Products").doc(productId).delete();

      // Show snackbar to indicate successful deletion
      if (ScaffoldMessenger.of(context).mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Product deleted successfully"),
          ),
        );
      }
    } catch (e) {
      // Handle specific errors, like object-not-found (404)
      if (e is FirebaseException && e.code == 'storage/object-not-found') {
        print('Image not found. It might have been already deleted.');
      } else {
        print('Error deleting product: $e');
      }

      // Show snackbar with error message
      if (ScaffoldMessenger.of(context).mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete product"),
          ),
        );
      }
    }
  }

  void _editProduct(String productId, Map<String, dynamic> productsnap) {
    Navigator.pushNamed(
      context,
      Routes.prdctadd,
      arguments: {
        "image": productsnap["Image"] ?? "",
        "Brand": productsnap["Brand Name"] ?? "Unknown Brand",
        "price": productsnap["Price"]?.toString() ?? "N/A",
        "description": productsnap["Description"] ?? "No Description",
        "id": productId,
      },
    );
  }
}
