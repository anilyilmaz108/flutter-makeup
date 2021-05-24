import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:makeup/data/product.dart';
import 'package:makeup/data/product_operations.dart';
import 'package:makeup/data/review_data.dart';
import 'package:makeup/screens/add_to_cart.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ProductReview extends StatefulWidget {

  final AddData _addData;

  ProductReview(this._addData);

  @override
  _ProductReviewState createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  final _authh = FirebaseAuth.instance;
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
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${widget._addData.name}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.pink.shade200,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            RatingBar.builder(
              initialRating: widget._addData.rating == null ? 1 : widget._addData.rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: widget._addData.rating == null ? Text('1.0',style: TextStyle(
                  fontSize: 18,
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold)) : Text('${widget._addData.rating}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold),),
            ),



            Image.network('${widget._addData.image}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("${widget._addData.price} ₺", style: TextStyle(fontSize: 25,),
                  textAlign: TextAlign.center,),
                IconButton(
                  icon: Icon(
                      Icons.shopping_cart_outlined, color: Colors.yellow),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    ProductOperations.addedProducts.add(Product(
                      productName: widget._addData.name,
                      productPrice: widget._addData.price,
                      productImage: widget._addData.image,
                    ));
                    _firestore.collection('products').add({
                      'product': widget._addData.name,
                      'member': loggedInUser.email,
                      'price' : widget._addData.price,
                      'image' : widget._addData.image,
                    });
                    print('User : ${loggedInUser.uid}');
                   Navigator.push(context, MaterialPageRoute(builder: (context) => AddToCart()));
                  },

                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("${widget._addData.description}"),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.grey.shade500,
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




