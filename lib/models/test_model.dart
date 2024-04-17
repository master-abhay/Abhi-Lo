import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseTestClass {
  String? name;
  String? state;

  FirebaseTestClass({required this.name, required this.state});

  factory FirebaseTestClass.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return FirebaseTestClass(name: data?['name'], state: data?['state']);
  }

  Map<String, dynamic> toFirestore() {
    return {'name': this.name, 'state': this.state};
  }
}
