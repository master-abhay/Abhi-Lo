import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String? itemName;
  String? quantity;
  String? totalAmount;
  String? imageUrl;
  String? itemId;

  Cart(
      {required this.itemName,
      required this.quantity,
      required this.totalAmount,
      required this.imageUrl,
      required this.itemId});

  factory Cart.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return Cart(
        itemName: data?["itemName"],
        quantity: data?["quantity"],
        totalAmount: data?["totalAmount"],
        imageUrl: data?["imageUrl"],
        itemId: data?["itemId"]);
  }

  Map<String, dynamic> toFireStore() {
    Map<String, dynamic> data = {};
    data["itemName"] = itemName;
    data["quantity"] = quantity;
    data["totalAmount"] = totalAmount;
    data["imageUrl"] = imageUrl;
    data["itemId"] = itemId;

    return data;
  }
}
