// import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tflite/tflite.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:fish/ListPage.dart';

// import 'package:skripsifishh/Camera.dart';

void main() => runApp(MaterialApp(
      home: HomeScreen(),
    ));

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late File image;
  List<dynamic>? _output;
  bool isImageloaded = false;
  String _conf = "";

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
        isImageloaded = true;
      });
      classifyImage(this.image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
        isImageloaded = true;
      });
      classifyImage(this.image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  int _currentIndex = 0;

  classifyImage(File _image) async {
    // var tfl;
    // var output = await tfl.interpreter.runModelOnImage(
    //     path: _image.path,
    //     numResults: 2,
    //     threshold: 0.5,
    //     imageMean: 127.5,
    //     imageStd: 127.5
    // );
    var output = await Tflite.runModelOnImage(
        path: _image.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    print(output);
    setState(() {
      _output = output;
      _conf = (_output![0]['confidence'] * 100.0).toString().substring(0, 2) + "%";
    });
  }

  loadModel() async {

    await Tflite.loadModel(
      model: 'assets/model2.tflite',
      labels: 'assets/label.txt',
    );
    // var tfl;
    // await tfl.interpreter.loadModel(

  }

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {});
  }

  @override
  void dispose() {
    // interpreter.close();
    // Interpreter.close();
    Tflite.close();
    setState(() {
      _output = null;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size srz = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00b4d8),
        title: Center(
          child: Text(
            'DETEKSI IKAN',
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: Container(
            color: Color(0xffDCF9FF),
            child: Center(
                child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    // SizedBox(height: 30),
                    Center(
                      child: Column(
                        children: [
                          isImageloaded
                              ? Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: srz.height * 0.4,
                                        width: srz.width * 0.85,
                                        margin: EdgeInsets.all(25.0),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    FileImage(File(image.path)),
                                                fit: BoxFit.contain)),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 3,
                                              blurRadius: 10,
                                              offset: Offset(5,
                                                  8), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(top: 5.0),
                                              // color: Colors.white,
                                              height: srz.height * 0.0575,
                                              width: srz.width * 0.85,
                                              child: Center(
                                                child: _output != null
                                                    ? Text(
                                                        getLabel(
                                                            '${_output![0]["label"]}'),
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      )
                                                    : CircularProgressIndicator(),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20.0,
                                                  bottom: 15.0),
                                              height: srz.height * 0.3,
                                              width: srz.width * 0.85,
                                              // color: Colors.yellow,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    _output != null
                                                        ? Text(
                                                            getDeskripsi(
                                                                '${_output![0]["label"]}'),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                          )
                                                        : Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    Container(
                                      height: srz.height * 0.1,
                                      // height: 500,
                                      width: srz.width * 0.7,
                                      // color: Colors.yellow,
                                      child: Center(
                                        child: Text(
                                          "Choose kamera or gallery",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF00b4d8),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  pickImageC();
                },
                icon: Icon(Icons.camera)),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              icon: Icon(Icons.article_outlined),
            ),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                pickImage();
              },
              icon: Icon(Icons.photo),
            ),
            label: 'Gallery',
          ),
        ],
        // onTap: (index) {
        //   setState(() {
        //     _currentIndex = index;
        //   });
        // },
      ),
    );
  }
}

String getLabel(String nama) {
  if (nama == 'Bandeng') {
    return 'Bandeng';
  } else if (nama == 'Cakalang') {
    return 'Cakalang';
  } else if (nama == 'Dorang') {
    return 'Dorang';
  } else if (nama == 'Kakap') {
    return 'Kakap';
  } else if (nama == 'Kembung') {
    return 'Kembung';
  } else if (nama == 'Tenggiri') {
    return 'Tenggiri';
  } else if (nama == 'Tongkol') {
    return 'Tongkol';
  } else {
    return 'Tidak terdeteksi';
  }
  // switch (nama) {
  //   case 'Bandeng':
  //     return 'Bandeng';
  //     break;
  //   case 'Cakalang':
  //     return 'Cakalang';
  //     break;
  //   case 'Dorang':
  //     return 'Dorang';
  //     break;
  //   case 'Kakap':
  //     return 'Kakap';
  //     break;
  //   case 'Kembung':
  //     return 'Kembung';
  //     break;
  //   case 'Tenggiri':
  //     return 'Tenggiri';
  //     break;
  //   case 'Tongkol':
  //     return 'Tongkol';
  //     break;
  //   default:
  //     return "Tidak terdeteksi";
  //     break;
  // }
}

String getDeskripsi(String nama) {
  if (nama == 'Bandeng') {
    return '(Chanos chanos) \n Family : Chanidae \n Tempat Hidup : Air Tawar, Air Payau, Air Laut (Lingkungan yang memiliki kadar garam tinggi) \n Ciri-ciri :  ';
  } else if (nama == 'Cakalang') {
    return '(Katsuwonus pelamis) \n Family : Skombride \n Tempat Hidup : Air Tawar, Air Payau, Air Laut (Lingkungan yang memiliki kadar garam tinggi) \n Ciri-ciri :  ';
  }  else if (nama == 'Dorang') {
    return '( Pampus argenteus) \n Family : Stromateidae \n Tempat Hidup : Air Tawar, Air Payau, Air Laut (Lingkungan yang memiliki kadar garam tinggi) \n Ciri-ciri :  ';
  } else if (nama == 'Kakap') {
    return '(Lutjanus campechanus) \n Family : Lutjanidae \n Tempat Hidup : Air Tawar, Air Payau, Air Laut (Lingkungan yang memiliki kadar garam tinggi) \n Ciri-ciri : ';
  } else if (nama == 'Kembung') {
    return '(Rastrelliger sp) \n Family : Scombridae \n Tempat Hidup : Air Tawar, Air Payau, Air Laut (Lingkungan yang memiliki kadar garam tinggi) \n Ciri-ciri : ';
  } else if (nama == 'Tenggiri') {
    return '(Scomberomorus) \n Family : Scombridae \n Tempat Hidup : Air Tawar, Air Payau, Air Laut (Lingkungan yang memiliki kadar garam tinggi) \n Ciri-ciri : ';
  } else if (nama == 'Tongkol') {
    return '(Euthynnus affinis) \n Family : Skombride \n Tempat Hidup : Air Tawar, Air Payau, Air Laut (Lingkungan yang memiliki kadar garam tinggi) \n Ciri-ciri : ';
  } else {
    return 'Tidak terdeteksi';
  }
}
