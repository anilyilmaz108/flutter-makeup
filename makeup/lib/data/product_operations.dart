
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:makeup/data/product.dart';

class ProductOperations{
  List<Product> products = [];
  static List<Product> addedProducts = [];
  static Product productReview;



  Future<void> getProduct()async{

    var data = await http.get('http://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline');
    var dataParsed = jsonDecode(data.body);

    for(var i=0; i<53;i++){
      products.add(Product(
        productName: dataParsed[i]['name'],
        productPrice: dataParsed[i]['price'],
        productImage: dataParsed[i]['image_link'],
        description: dataParsed[i]['description'],
        rating: dataParsed[i]['rating']
      ));




    }
  }



}