import 'package:cloud_firestore/cloud_firestore.dart';

class AddItem {
  static const String IMGURL = 'imgUrl';
  static const String ITEMNAME = 'itemName';
  static const String ITEMPRICE = 'itemPrice';
  static const String ITEMDETAIL = 'itemDetail';
  static const String ITEMCATEGORY = 'itemCategory';

  String? imgUrl;
  String? itemName;
  String? itemPrice;
  String? itemDetail;
  String? itemCategory;

  AddItem(
      {required this.imgUrl,
      required this.itemName,
      required this.itemPrice,
      required this.itemDetail,
      required this.itemCategory});

  factory AddItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return AddItem(
        imgUrl: data?[IMGURL],
        itemName: data?[ITEMNAME],
        itemPrice: data?[ITEMPRICE],
        itemDetail: data?[ITEMDETAIL],
        itemCategory: data?[ITEMCATEGORY]);
  }

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> data = {};

    data[IMGURL] = imgUrl;
    data[ITEMNAME] = itemName;
    data[ITEMPRICE] = itemPrice;
    data[ITEMDETAIL] = itemDetail;
    data[ITEMCATEGORY] = itemCategory;

    return data;
  }
}
