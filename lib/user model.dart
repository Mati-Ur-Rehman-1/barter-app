

class Userss {
  String uid;
  String itemname;
  String descripton;
  String category;
  String condition;
  String unit;
  String city;
  String purchaseprice;
  String taxin;
  String taxinprice;
  String image;

  Userss({
    required this.uid,
    required this.itemname,
    required this.descripton,
    required this.category,
    required this.condition,
    required this.unit,
    required this.city,
    required this.purchaseprice,
    required this.taxin,
    required this.taxinprice,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid':uid,
      'itemname': itemname,
      'descripton': descripton,
      'category': category,
      'condition': condition,
      'unit': unit,
      'city': city,
      'purchaseprice': purchaseprice,
      'taxin': taxin,
      'taxinprice': taxinprice,
      'image': image,
    };
  }

  factory Userss.fromMap(Map<String, dynamic> map) {
    return Userss(
      uid: map['uid'],
      itemname: map['itemname'],
      descripton: map['descripton'],
      category: map['category'],
      condition: map['condition'],
      unit: map['unit'],
      city: map['city'],
      purchaseprice: map['purchaseprice'],
      taxin: map['taxin'],
      taxinprice: map['taxinprice'],
      image: map['image'],
    );
  }
}
