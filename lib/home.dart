// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellerpage/routes.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
                        // SizedBox(height: 6,),
                        // Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                      ],
                    ),
                  ),
                 IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushNamed(context, Routes.login);
            },
            icon: Icon(Icons.logout),
            color: Color.fromARGB(255, 31, 31, 31),
          ),
                ],
              ),
            ),
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.only(top: 140),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.productlist);
                },
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                   
                    image: DecorationImage(
                      image: AssetImage("assets/ship.gif"),
                      fit: BoxFit.cover,
                    ),
                  ),
               
                ),
                
              ),
              Center(
                    child: Text(
                      "Seller Products",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 48, 27, 20),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.register);
                },
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                   
                    image: DecorationImage(
                      image: AssetImage("assets/ship.gif"),
                      fit: BoxFit.cover,
                    ),
                  ),
                 
                ),
              ),
        Center(
                    child: Text(
                      "Out of Order",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 48, 27, 20),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.prdctadd);
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    child: Image.asset("assets/addi.png"),
                   
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


