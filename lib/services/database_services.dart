import 'package:abhi_lo/models/addItem_model.dart';
import 'package:abhi_lo/models/user_profile.dart';
import 'package:abhi_lo/services/auth_Services.dart';
import 'package:abhi_lo/services/shared_prefrences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../models/cart_model.dart';

class DatabaseServices {
  late AuthServices _authServices;
  late LocalDataSaver _localDataSaver;

  final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance; //this is a database

  CollectionReference? _userCollectionReference;
  CollectionReference? _itemIceCreamCollectionReference;
  CollectionReference? _itemNoodlesCollectionReference;

  CollectionReference? _itemPizzaCollectionReference;

  CollectionReference? _itemBurgerCollectionReference;

  CollectionReference? _cartCollectionReferences;

  DatabaseServices() {
    GetIt _getIt = GetIt.instance;
    _authServices = _getIt.get<AuthServices>();
    _localDataSaver = _getIt.get<LocalDataSaver>();

    // getLocalData().then((value) {
    _setupCollectionReferences();
    _setupIceCreamCollectionReferences();
    _setupNoodlesCollectionReferences();
    _setupPizzaCollectionReferences();
    _setupBurgerCollectionReferences();
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
    await _userCollectionReference!.doc(uid).delete();
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

  void _setupIceCreamCollectionReferences() {
    _itemIceCreamCollectionReference = _firebaseFirestore
        .collection("Ice-Cream")
        .withConverter<AddItem>(
            fromFirestore: (snapshots, _) =>
                AddItem.fromFirestore(snapshots, _),
            toFirestore: (AddItem addItem, options) => addItem.toFirestore());
  }

  void _setupNoodlesCollectionReferences() {
    _itemNoodlesCollectionReference = _firebaseFirestore
        .collection("Noodles")
        .withConverter<AddItem>(
            fromFirestore: (snapshots, _) =>
                AddItem.fromFirestore(snapshots, _),
            toFirestore: (AddItem addItem, options) => addItem.toFirestore());
  }

  void _setupPizzaCollectionReferences() {
    _itemPizzaCollectionReference = _firebaseFirestore
        .collection("Pizza")
        .withConverter<AddItem>(
            fromFirestore: (snapshots, _) =>
                AddItem.fromFirestore(snapshots, _),
            toFirestore: (AddItem addItem, options) => addItem.toFirestore());
  }

  void _setupBurgerCollectionReferences() {
    _itemBurgerCollectionReference = _firebaseFirestore
        .collection("Burger")
        .withConverter<AddItem>(
            fromFirestore: (snapshots, _) =>
                AddItem.fromFirestore(snapshots, _),
            toFirestore: (AddItem addItem, options) => addItem.toFirestore());
  }

  Future<bool> setUpItem(AddItem addItem) async {
    final _categoryList = ['Ice-Cream', "Pizza", "Noodles", "Burger"];

    String? itemCategory = addItem.itemCategory;

    if (itemCategory == _categoryList[0]) {
      await _itemIceCreamCollectionReference!
          .doc(
              "${DateTime.now().microsecondsSinceEpoch.toString()}${addItem.itemCategory}")
          .set(addItem);
      return true;
    }
    if (itemCategory == _categoryList[1]) {
      await _itemPizzaCollectionReference!
          .doc(
              "${DateTime.now().microsecondsSinceEpoch.toString()}${addItem.itemCategory}")
          .set(addItem);
      return true;
    }
    if (itemCategory == _categoryList[2]) {
      await _itemNoodlesCollectionReference!
          .doc(
              "${DateTime.now().microsecondsSinceEpoch.toString()}${addItem.itemCategory}")
          .set(addItem);
      return true;
    }
    if (itemCategory == _categoryList[3]) {
      await _itemBurgerCollectionReference!
          .doc(
              "${DateTime.now().microsecondsSinceEpoch.toString()}${addItem.itemCategory}")
          .set(addItem);
      return true;
    }
    return false;
  }

  //Stream to get items from collection Reference:
  Stream<QuerySnapshot<AddItem>>? getAllIceCreamDocuments(
      String collectionReferenceName) {
    if (collectionReferenceName == "_itemIceCreamCollectionReference") {
      return _itemIceCreamCollectionReference!.snapshots()
          as Stream<QuerySnapshot<AddItem>>;
    }
    if (collectionReferenceName == "_itemPizzaCollectionReference") {
      return _itemPizzaCollectionReference!.snapshots()
          as Stream<QuerySnapshot<AddItem>>;
    }
    if (collectionReferenceName == "_itemBurgerCollectionReference") {
      return _itemBurgerCollectionReference!.snapshots()
          as Stream<QuerySnapshot<AddItem>>;
    }
    if (collectionReferenceName == "_itemNoodlesCollectionReference") {
      return _itemNoodlesCollectionReference!.snapshots()
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

  Future<void> setupCart(Cart cart, String? uid) async {
    _cartCollectionReferences = _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .collection("Cart")
        .withConverter<Cart>(
            fromFirestore: (snapshots, _) => Cart.fromFirestore(snapshots, _),
            toFirestore: (Cart cart, _) => cart.toFireStore());

    await _cartCollectionReferences!.doc(cart.itemId).set(cart);
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

  Future<void> deleteCartItem(String uid,String cartItemId) async{
    _cartCollectionReferences = _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .collection("Cart")
        .withConverter<Cart>(
        fromFirestore: (snapshots, _) => Cart.fromFirestore(snapshots, _),
        toFirestore: (Cart cart, _) => cart.toFireStore());

    await _cartCollectionReferences!.doc(cartItemId).delete();
  }
}
