
class Userss {
  String uid;
  String itemname;
  String descripton;
  String category;
  String condition;
  String city;
  String image;

  Userss({
    required this.uid,
    required this.itemname,
    required this.descripton,
    required this.category,
    required this.condition,
    required this.city,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid':uid,
      'itemname': itemname,
      'descripton': descripton,
      'category': category,
      'condition': condition,
      'city': city,
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
      city: map['city'],
      image: map['image'],
    );
  }
}

