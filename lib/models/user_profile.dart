import 'package:cloud_firestore/cloud_firestore.dart';

const String UID = 'uid';
const String NAME = 'name';
const String WALLET = 'wallet';
const String EMAIL = 'email';
const String PROFILEIMAGE = 'profileImage';

class UserProfile {
  String? uid;
  String? name;
  String? email;
  String? profileImage;
  int wallet = 0;

  //another style of creating constructor: because if want to use only some characters then we use only that.
  UserProfile(
      {required this.name,
      required this.uid,
      required this.wallet,
      required this.email,
      this.profileImage = ""});

  // Another named Constructor: which we calling as fromJSON

  UserProfile.fromFirestore(
    Map<String, dynamic> json,
    SnapshotOptions? options,
  ) {
    name = json[NAME];
    uid = json[UID];
    email = json[EMAIL];
    wallet = json[WALLET];
    profileImage = json[PROFILEIMAGE];
  }

  factory UserProfile.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final user = snapshot.data();
    return UserProfile(
        name: user?[NAME],
        uid: user?[UID],
        wallet: user?[WALLET],
        email: user?[EMAIL],
        profileImage: user?[PROFILEIMAGE]);
  }

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> user = {};
    user[NAME] = name;
    user[UID] = uid;
    user[EMAIL] = email;
    user[WALLET] = wallet;
    user[PROFILEIMAGE] = profileImage;

    return user;
  }
}
