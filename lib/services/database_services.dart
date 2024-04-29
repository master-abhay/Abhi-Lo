import 'package:abhi_lo/models/addItem_model.dart';
import 'package:abhi_lo/models/user_profile.dart';
import 'package:abhi_lo/services/alert_services.dart';
import 'package:abhi_lo/services/auth_Services.dart';
import 'package:abhi_lo/services/shared_prefrences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../models/cart_model.dart';

class DatabaseServices {
  late AuthServices _authServices;
  late LocalDataSaver _localDataSaver;
  late AlertServices _alertServices;

  final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance; //this is a database

  CollectionReference? _userCollectionReference;
  CollectionReference? _itemNonVegCollectionReference;
  CollectionReference? _itemChineseCollectionReference;

  CollectionReference? _itemSweetsCollectionReference;

  CollectionReference? _itemVegCollectionReference;

  CollectionReference? _cartCollectionReferences;

  CollectionReference? _adminCollectionReferences;

  DatabaseServices() {
    GetIt _getIt = GetIt.instance;
    _alertServices = _getIt.get<AlertServices>();
    _authServices = _getIt.get<AuthServices>();
    _localDataSaver = _getIt.get<LocalDataSaver>();

    // getLocalData().then((value) {
    _setupCollectionReferences();
    _setupNonVegCollectionReferences();
    _setupChineseCollectionReferences();
    _setupSweetsCollectionReferences();
    _setupVegCollectionReferences();

    // _setupCartCollectionReferences();
    // });
  }

// String? uid;
// Future<void> getLocalData()async{
//     String? _uid = await _localDataSaver.getUID();
//     print("------------------inside the getLocalData: $_uid");
//     uid = _uid;
// }

  //Correct Version
  // void _setupCollectionReferences() {
  //   _userCollectionRefrence = _firebaseFirestore
  //       .collection("Users")
  //       .withConverter<UserProfile>(
  //           fromFirestore: (snapshots, _) =>
  //               UserProfile.fromFirestore(snapshots.data()!, _),
  //           toFirestore: (UserProfile userProfile, options) =>
  //               userProfile.toFirestore());
  // }

  void _setupCollectionReferences() {
    _userCollectionReference = _firebaseFirestore
        .collection("Users")
        .withConverter<UserProfile>(
            fromFirestore: (snapshots, _) => UserProfile.fromJson(snapshots, _),
            toFirestore: (UserProfile userProfile, options) =>
                userProfile.toFirestore());
  }

  Future<void> setUpUser(UserProfile userProfile) async {
    await _userCollectionReference!.doc(userProfile.uid).set(userProfile);
    _cartCollectionReferences = _firebaseFirestore
        .collection("Users")
        .doc(userProfile.uid)
        .collection("Cart")
        .withConverter<Cart>(
            fromFirestore: (snapshots, _) => Cart.fromFirestore(snapshots, _),
            toFirestore: (Cart cart, _) => cart.toFireStore());
  }

  Future<void> updateUserProfile(String? uid, String? imgUrl) async {
    await _userCollectionReference!
        .doc(uid)
        .update({'profileImage': '$imgUrl'});
  }

  Future<void> deleteUser(String uid) async {
    // Delete the user document
    await _userCollectionReference!.doc(uid).delete();

    // Delete the user's cart collection
    _cartCollectionReferences = _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .collection("Cart");
    final cartSnapshot = await _cartCollectionReferences!.get();
    for (QueryDocumentSnapshot doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }
  }


  //Correct Version
  // void _setupItemCollectionRefrences() {
  //   _itemCollectionRefrence = _firebaseFirestore
  //       .collection("Items")
  //       .withConverter<AddItem>(
  //           fromFirestore: (snapshots, _) =>
  //               AddItem.fromFirestore(snapshots, _),
  //           toFirestore: (AddItem addItem, options) => addItem.toFirestore());
  // }

  void _setupVegCollectionReferences() {
    _itemVegCollectionReference = _firebaseFirestore
        .collection("Veg")
        .withConverter<AddItem>(
            fromFirestore: (snapshots, _) =>
                AddItem.fromFirestore(snapshots, _),
            toFirestore: (AddItem addItem, options) => addItem.toFirestore());
  }

  void _setupNonVegCollectionReferences() {
    _itemNonVegCollectionReference = _firebaseFirestore
        .collection("Non-Veg")
        .withConverter<AddItem>(
            fromFirestore: (snapshots, _) =>
                AddItem.fromFirestore(snapshots, _),
            toFirestore: (AddItem addItem, options) => addItem.toFirestore());
  }

  void _setupChineseCollectionReferences() {
    _itemChineseCollectionReference = _firebaseFirestore
        .collection("Chinese")
        .withConverter<AddItem>(
            fromFirestore: (snapshots, _) =>
                AddItem.fromFirestore(snapshots, _),
            toFirestore: (AddItem addItem, options) => addItem.toFirestore());
  }

  void _setupSweetsCollectionReferences() {
    _itemSweetsCollectionReference = _firebaseFirestore
        .collection("Sweets")
        .withConverter<AddItem>(
            fromFirestore: (snapshots, _) =>
                AddItem.fromFirestore(snapshots, _),
            toFirestore: (AddItem addItem, options) => addItem.toFirestore());
  }

  Future<bool> setUpItem(AddItem addItem) async {
    final _categoryList = ['Veg', "Non-Veg", "Chinese", "Sweets"];

    String? itemCategory = addItem.itemCategory;

    if (itemCategory == _categoryList[0]) {
      await _itemVegCollectionReference!
          .doc(
              "${DateTime.now().microsecondsSinceEpoch.toString()}${addItem.itemCategory}")
          .set(addItem);
      return true;
    }

    if (itemCategory == _categoryList[1]) {
      await _itemNonVegCollectionReference!
          .doc(
              "${DateTime.now().microsecondsSinceEpoch.toString()}${addItem.itemCategory}")
          .set(addItem);
      return true;
    }

    if (itemCategory == _categoryList[2]) {
      await _itemChineseCollectionReference!
          .doc(
              "${DateTime.now().microsecondsSinceEpoch.toString()}${addItem.itemCategory}")
          .set(addItem);
      return true;
    }
    if (itemCategory == _categoryList[3]) {
      await _itemSweetsCollectionReference!
          .doc(
              "${DateTime.now().microsecondsSinceEpoch.toString()}${addItem.itemCategory}")
          .set(addItem);
      return true;
    }

    return false;
  }

  //Stream to get items from collection Reference:
  Stream<QuerySnapshot<AddItem>>? getAllDocuments(
      String collectionReferenceName) {
    if (collectionReferenceName == "_itemVegCollectionReference") {
      return _itemVegCollectionReference!.snapshots()
          as Stream<QuerySnapshot<AddItem>>;
    }

    if (collectionReferenceName == "_itemNonVegCollectionReference") {
      return _itemNonVegCollectionReference!.snapshots()
          as Stream<QuerySnapshot<AddItem>>;
    }

    if (collectionReferenceName == "_itemChineseCollectionReference") {
      return _itemChineseCollectionReference!.snapshots()
          as Stream<QuerySnapshot<AddItem>>;
    }

    if (collectionReferenceName == "_itemSweetsCollectionReference") {
      return _itemSweetsCollectionReference!.snapshots()
          as Stream<QuerySnapshot<AddItem>>;
    }
    return null;
  }

  // Correct Version:
  // Future<UserProfile?> getCurrentUser() async {
  //   final docSnap =
  //       await _userCollectionRefrence!.doc(_authServices.user!.uid).get();
  //   print("------------------------->>>>>>>>>>>>>>>>>>$docSnap");
  //
  //   if (docSnap.exists) {
  //     UserProfile user = docSnap.data() as UserProfile;
  //     print("------------------------->>>>>>>>>>>>>>>>>>$user");
  //
  //     return user;
  //   } else {
  //     return null;
  //   }
  // }

  Future<UserProfile?> getCurrentUser() async {
    final docSnap =
        await _userCollectionReference!.doc(_authServices.user!.uid).get();
    print("------------------------->>>>>>>>>>>>>>>>>>$docSnap");

    if (docSnap.exists) {
      final data = docSnap.data();
      print("------------------------->>>>>>>>>>>>>>>>>>$data");
      return data as UserProfile;
    } else {
      return null;
    }
  }

  // Correct version:
  // Stream<DocumentSnapshot<UserProfile>> getLiveUser() {
  //   return _userCollectionRefrence!
  //       .doc(_authServices.user!.uid)
  //       .snapshots()
  //       .map((snapshot) => snapshot as DocumentSnapshot<UserProfile>);
  // }

  Stream<UserProfile> getLiveUser() {
    return _userCollectionReference!
        .doc(_authServices.user!.uid)
        .snapshots()
        .map((snapshot) => snapshot.data() as UserProfile);
  }

  Future<void> updateWalletBalance(int value) async {
    await _userCollectionReference!
        .doc(_authServices.user!.uid)
        .update({'wallet': FieldValue.increment(value)});
  }

  Future<void> setUpCartCollection(UserProfile userProfile) async {
    _cartCollectionReferences = _firebaseFirestore
        .collection("Users")
        .doc(userProfile.uid)
        .collection("Cart")
        .withConverter<Cart>(
            fromFirestore: (snapshots, _) => Cart.fromFirestore(snapshots, _),
            toFirestore: (Cart cart, _) => cart.toFireStore());
  }

  // // original code:
  // Future<void> setupCart(Cart cart, String? uid) async {
  //   _cartCollectionReferences = _firebaseFirestore
  //       .collection("Users")
  //       .doc(uid)
  //       .collection("Cart")
  //       .withConverter<Cart>(
  //           fromFirestore: (snapshots, _) => Cart.fromFirestore(snapshots, _),
  //           toFirestore: (Cart cart, _) => cart.toFireStore());
  //
  //   await _cartCollectionReferences!.doc(cart.itemId).set(cart);
  //   print("Executed Successfully");
  // }

  Future<void> setupCart(Cart cart, String? uid) async {
    _cartCollectionReferences = _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .collection("Cart")
        .withConverter<Cart>(
            fromFirestore: (snapshots, _) => Cart.fromFirestore(snapshots, _),
            toFirestore: (Cart cart, _) => cart.toFireStore());

    await _cartCollectionReferences!.doc(cart.itemName).set(cart);
    print("Executed Successfully");
  }

  Stream<QuerySnapshot<Cart>>? getCartData(String uid) {
    _cartCollectionReferences = _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .collection("Cart")
        .withConverter<Cart>(
            fromFirestore: (snapshots, _) => Cart.fromFirestore(snapshots, _),
            toFirestore: (Cart cart, _) => cart.toFireStore());
    return _cartCollectionReferences!.snapshots()
        as Stream<QuerySnapshot<Cart>>;
  }

  Future<void> deleteCartData(String uid) async {
    _cartCollectionReferences = _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .collection("Cart")
        .withConverter<Cart>(
            fromFirestore: (snapshots, _) => Cart.fromFirestore(snapshots, _),
            toFirestore: (Cart cart, _) => cart.toFireStore());

    final cartSnapshot = await _cartCollectionReferences!.get();
    for (QueryDocumentSnapshot doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<bool> checkItemInCartExists(Cart cart, String? uid) async {
    _cartCollectionReferences = _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .collection("Cart")
        .withConverter<Cart>(
            fromFirestore: (snapshots, _) => Cart.fromFirestore(snapshots, _),
            toFirestore: (Cart cart, _) => cart.toFireStore());

    final result = await _cartCollectionReferences?.doc(cart.itemName).get();

    if (result != null &&
        result.data() != null &&
        !result.metadata.isFromCache) {
      // Existing item in the cart
      return true;
    }
// Item not found or deleted
    return false;

  }

  Future updateItemCount(String itemName,int quantity) async{
   await _cartCollectionReferences!.doc(itemName).update({'quantity' : FieldValue.increment(quantity)});
  }

  // // original code:
  // Future<void> deleteCartItem(String uid, String cartItemId) async {
  //   _cartCollectionReferences = _firebaseFirestore
  //       .collection("Users")
  //       .doc(uid)
  //       .collection("Cart")
  //       .withConverter<Cart>(
  //           fromFirestore: (snapshots, _) => Cart.fromFirestore(snapshots, _),
  //           toFirestore: (Cart cart, _) => cart.toFireStore());
  //
  //   await _cartCollectionReferences!.doc(cartItemId).delete();
  // }
  Future<void> deleteCartItem(String uid, String itemName) async {
    _cartCollectionReferences = _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .collection("Cart")
        .withConverter<Cart>(
            fromFirestore: (snapshots, _) => Cart.fromFirestore(snapshots, _),
            toFirestore: (Cart cart, _) => cart.toFireStore());

    await _cartCollectionReferences!.doc(itemName).delete();
  }

  Future<Map<String, dynamic>> loginAdmin() async {
    print(
        "------------------Inside the adminLoginAccess method in database services............");
    _adminCollectionReferences = _firebaseFirestore.collection("Admin");

    final documentSnap = await _adminCollectionReferences!.doc("admin").get();

    final data = documentSnap.data();

    print(
        "--------------------------Returning the details of the admin from adminLoginAccess function");
    return data as Map<String, dynamic>;
  }
}
