import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sellerpage/firebase_options.dart';
import 'package:sellerpage/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Demo());     
}

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Root();
  }
}
