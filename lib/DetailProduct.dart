import 'dart:convert';

import 'package:flutter/material.dart';
import 'model/lesson.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static const String routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var productName = "";
  Product? product;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var productString = ModalRoute.of(context)?.settings.arguments as String;
    print('page 2');
    print(productString);

    var productJson = jsonDecode(productString);
    print(productJson);

    setState(() {
      product = Product.fromJson(productJson);
      productName = product!.nama;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.all(5.0),
                  child: Image(image: AssetImage('assets/images/' + product!.nama.toString() + '.jpg')),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.all(5.0),
                  child: Text("Nama Ikan : " + (product!.nama),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0)),
                ),
                SizedBox(height: 10,),
                Container(
                    margin: EdgeInsets.all(5.0),
                    child: Text("Deskripsi : " + (product!.deskripsi),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0))
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
