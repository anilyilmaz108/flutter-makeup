import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:makeup/screens/beginning.dart';
import 'package:provider/provider.dart';
import 'data/auth.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<Auth>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Make-Up",
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: Beginning(),
      ),
    );
  }
}

