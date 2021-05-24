import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makeup/data/auth.dart';
import 'package:makeup/screens/home_page.dart';

import 'package:makeup/widgets/intro_view.dart';

import 'package:provider/provider.dart';

class Beginning extends StatefulWidget {
  @override
  _BeginningState createState() => _BeginningState();
}

class _BeginningState extends State<Beginning> {
  bool _isLogged = true;
  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
        _isLogged = false;
      } else {
        print('User is signed in!');
        _isLogged = true;
      }
      setState(() {

      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context,listen: false);
    return StreamBuilder<User>(
        stream: _auth.authStatus(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            return snapshot.data != null ? HomePage() : IntroView();
          }
          else{
            return SizedBox(
              width: 300,
              height: 300,
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}
