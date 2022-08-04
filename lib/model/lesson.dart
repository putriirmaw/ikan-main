class Product {

  String id;
  String nama;
  String deskripsi;

  Product({this.id = "",
    this.nama = "",
    this.deskripsi = "",
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        nama: json['nama'],
        deskripsi: json['deskripsi']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama'] = this.nama;
    data['deskripsi'] = this.deskripsi;
    return data;
  }

}