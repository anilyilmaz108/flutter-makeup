import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:makeup/data/auth.dart';
import 'package:makeup/data/product.dart';
import 'package:makeup/data/product_operations.dart';
import 'package:makeup/data/review_data.dart';
import 'package:makeup/screens/add_to_cart.dart';
import 'package:makeup/screens/product_review.dart';
import 'package:makeup/screens/contact_page.dart';


import 'package:provider/provider.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductOperations _productOperations = ProductOperations();

  final _authh = FirebaseAuth.instance;

  List data = [];
  bool isLoading = true;
  void fetchData() async {
    var data = await http.get('http://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline');
    var dataParsed = jsonDecode(data.body);;
    for(var i=0; i<53;i++){
      _productOperations.products.add(Product(
          productName: dataParsed[i]['name'],
          productPrice: dataParsed[i]['price'],
          productImage: dataParsed[i]['image_link'],
          description: dataParsed[i]['description'],
          rating: dataParsed[i]['rating']
      ));

    }
    setState(() => isLoading = false);
  }

  @override
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

  void initState() {
    _productOperations.getProduct();
    _productOperations.products;
    getCurrentUser();
    super.initState();
    fetchData();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Go to Cart'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to go to your cart?'),
                Text('You can access the added products from the cart section.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Go to Cart'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddToCart()));
                print(ProductOperations.addedProducts.length);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Make-Up Project"),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Make Up"),
              accountEmail: Text("anilyilmaz108@gmail.com"),
              currentAccountPicture: Image.network("https://png.pngtree.com/png-vector/20190429/ourmid/pngtree-eyelashes-logo-design-vector-png-image_996516.jpg"),

            ),

            Expanded(
              child: ListView(
                children: [
                  ListTile(leading: Icon(Icons.home), title: Text("Home Page"),trailing: Icon(Icons.chevron_right), tileColor: Colors.grey.shade200,),
                  ListTile(leading: Icon(Icons.shopping_cart_outlined), title: Text("Cart"),trailing: Icon(Icons.chevron_right),onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddToCart()));
                  },),
                  ListTile(leading: Icon(Icons.contacts), title: Text("Contact"),trailing: Icon(Icons.chevron_right),onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactPage()));
                  },),
                  ListTile(leading: Icon(Icons.exit_to_app), title: Text("Logout"),trailing: Icon(Icons.chevron_right),onTap: ()async{
                    Provider.of<Auth>(context,listen: false).SignOut();
                    //exit(0);
                  },),
                ],
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(value: 20,))
          : homePageBody()
    );   
  }

  Widget homePageBody() {

    return ListView.builder(
      itemCount: _productOperations.products.length,
        itemBuilder: (context, index) {
        return ListTile(
          title: Text("${_productOperations.products[index].productName}"),
          subtitle: Row(
            children: [
              Text("${_productOperations.products[index].productPrice}"),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text('₺'),
              ),
            ],
          ),
          leading: CircleAvatar(
            child: Image.network('${_productOperations.products[index].productImage}'),
          ),
          trailing: IconButton(
            highlightColor: Colors.pink,
            splashColor: Colors.pink,
            onPressed: (){

            final snackBar = SnackBar(
              backgroundColor: Colors.pinkAccent,
              content: Text("${_productOperations.products[index].productName} has been added to cart"),
              duration: Duration(seconds: 2),

            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            ProductOperations.addedProducts.add(Product(
                    productName: _productOperations.products[index].productName,
                  productPrice: _productOperations.products[index].productPrice,
                  productImage: _productOperations.products[index].productImage,
                ));

            _firestore.collection('products').add({
              'product': _productOperations.products[index].productName,
              'member': loggedInUser.email,
              'price' : _productOperations.products[index].productPrice,
              'image' : _productOperations.products[index].productImage,
            });

            },



            icon: Icon(
                Icons.shopping_cart_outlined,
            ),
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductReview(
              AddData(
                name: _productOperations.products[index].productName,
                price: _productOperations.products[index].productPrice,
                image: _productOperations.products[index].productImage,
                description: _productOperations.products[index].description,
                rating: _productOperations.products[index].rating,
              )
            )));
          },
          onLongPress: (){
            _showMyDialog();
          },
        );
        }
    )
    ;
  }
}



