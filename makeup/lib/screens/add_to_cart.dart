

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
User loggedInUser;

class AddToCart extends StatefulWidget {

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart>with TickerProviderStateMixin {
  CollectionReference productReference = _firestore.collection('products');



  final _authh = FirebaseAuth.instance;
  void getCurrentUser()async{
    try{
      final user = await _authh.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }catch(e){
      print(e);
    }
  }


  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: productReference.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> asyncSnapshot){
            if(asyncSnapshot.hasError){ print("Hata oluştu");}
            else{
              if(!asyncSnapshot.hasData){
                return Center(child: CircularProgressIndicator(),);
              }
              else{
                List<DocumentSnapshot> productList = asyncSnapshot.data.docs;

                return ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: (context, index){
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          child: Icon(Icons.delete,color: Colors.white,),
                          color: Colors.red,
                        ),
                        onDismissed: (_){
                          productList[index].reference.delete();
                          print(productList[index].id);
                          print('USER ID : ${loggedInUser.uid}');
                        },
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Image.network('${productList[index].data()['image']}'),
                            ),
                            title: Text(productList[index].data()['product']),
                            subtitle: Text('${productList[index].data()['price']} ₺'),
                          ),
                        ),
                      );
                    }
                );
              }

            }
          }

      ),
    );
  }
}






