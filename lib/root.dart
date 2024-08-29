import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellerpage/home.dart';
import 'package:sellerpage/login.dart';
import 'package:sellerpage/productadd.dart';
import 'package:sellerpage/productlist.dart';
import 'package:sellerpage/register.dart';
import 'package:sellerpage/routes.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser==null?Routes.login:Routes.home,
  
      routes: {
        Routes.login: (context) => const Login(),
        Routes.register: (context) => const Register(),
        Routes.home: (context) => const Home(),
        Routes.prdctadd: (context) => const Productadd(),
        Routes.productlist: (context) =>   const Productlist(),
       
       
      },
    );
  }
}
