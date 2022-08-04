import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;

import 'DetailProduct.dart';
import 'model/lesson.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'List Ikan',
          ),
        ),
        body: FutureBuilder(
          future: ReadJsonData(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {
              var items = data.data as List<Product>;
              return ListView.builder(
                  itemCount: items == null ? 0 : items.length,
                  itemBuilder: (context, index) {
                    return Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Container(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: ListTile(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                    border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
                    child: Icon(Icons.autorenew, color: Colors.white),
                    ),
                    title: Text(
                      items[index].nama.toString(),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    trailing:
                    Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                    onTap: () {
                      Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: jsonEncode(items[index]));
                    },
                    )
                    ,
                    ));
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
    );
  }

  Future<List<Product>> ReadJsonData() async {
    final jsondata = await rootBundle.rootBundle.loadString('assets/data.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => Product.fromJson(e)).toList();
  }
}