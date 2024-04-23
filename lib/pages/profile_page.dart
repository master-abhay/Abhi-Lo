import 'package:abhi_lo/services/media_services.dart';
import 'package:abhi_lo/services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/auth_Services.dart';
import '../services/database_services.dart';
import '../services/navigation_services.dart';
import '../services/shared_prefrences.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationServices _navigationServices;
  late AuthServices _authServices;
  late LocalDataSaver _localDataSaver;
  late DatabaseServices _databaseServices;
  late StorageServices _storageServices;
  late MediaServices _mediaServices;

  String name = "";
  String email = "";
  String uid = "";
  String? image;

  Future<void> getSharedPrefData() async {
    final _name = await _localDataSaver.getName() ?? "";
    final _email = await _localDataSaver.getEmail() ?? "";
    final _uid = await _localDataSaver.getUID() ?? "";
    final _image = await _localDataSaver.getProfileImageUrl();

    setState(() {
      name = _name;
      email = _email;
      uid = _uid;
      image = _image;
    });
  }


  @override
  void initState() {
    _navigationServices = _getIt.get<NavigationServices>();
    _authServices = _getIt.get<AuthServices>();
    _databaseServices = _getIt.get<DatabaseServices>();
    _localDataSaver = _getIt.get<LocalDataSaver>();
    _storageServices = _getIt.get<StorageServices>();
    _mediaServices = _getIt.get<MediaServices>();



    super.initState();
    getSharedPrefData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileSection(),
            _contentSection(),
          ],
        ),
      ),
    );
  }

  Widget _profileSection() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height / 4.3,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom:
                    Radius.elliptical(MediaQuery.sizeOf(context).width, 105),
              ),
              color: Colors.black),
          child: Center(
              child: Text(
            name!,
            style: const TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          )),
        ),
        GestureDetector(
          onTap: () async {
            final _file = await _mediaServices.getImageFromGallery();
            final downloadUrl = await _storageServices.uploadItemImage(
                file: _file!, itemCategory: "profileImage");
            print(
                "---------------->>>>>>>>>>>>printing the download Url:$downloadUrl");

            await _localDataSaver.saveProfileImage(downloadUrl);

            final saveImage = await _localDataSaver.getProfileImageUrl();
            setState(() {
              image = saveImage!;
            });

            // await _databaseServices.updateUserProfile(uid, image);
            await _databaseServices.updateUserProfile(uid, downloadUrl);
          },
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 6.5),
            child: Center(
              child: Material(
                borderRadius: BorderRadius.circular(60),
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            image!,
                            fit: BoxFit.cover,
                            height: 120,
                            width: 120,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "images/profileDummy.jpeg",
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                              );
                            },
                          ))
                      : const Icon(
                          Icons.photo_camera_back_outlined,
                          size: 120,
                        ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _contentSection() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.02,
          vertical: MediaQuery.sizeOf(context).height * 0.01),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.02,
                vertical: MediaQuery.sizeOf(context).height * 0.01),
            child: Material(
              elevation: 5,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.09,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.03,
                      vertical: MediaQuery.sizeOf(context).height * 0.01),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 25),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.04,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Name",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.02,
                vertical: MediaQuery.sizeOf(context).height * 0.01),
            child: Material(
              elevation: 5,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.09,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.03,
                      vertical: MediaQuery.sizeOf(context).height * 0.01),
                  child: Row(
                    children: [
                      const Icon(Icons.email, size: 25),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.04,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Email",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            email,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.02,
                vertical: MediaQuery.sizeOf(context).height * 0.01),
            child: Material(
              elevation: 5,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.09,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.03,
                      vertical: MediaQuery.sizeOf(context).height * 0.01),
                  child: Row(
                    children: [
                      const Icon(Icons.file_copy, size: 25),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.04,
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Terms and Conditions",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text("Are you sure!"),
                  actions: [
                    TextButton(onPressed: (){
                      _navigationServices.goBack();

                    }, child: Text("Cancel")),
                    TextButton(onPressed: ()async{
                      bool result = await _authServices.deleteAccount();


                      if(result){
                        _navigationServices.goBack();

                        _databaseServices.deleteUser(uid);

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.orangeAccent,
                            content: Text("Account Deleted")));
                        _navigationServices.pushReplacement("/login");
                      }

                      else{
                        _navigationServices.goBack();

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.deepOrangeAccent,
                            content: Text("Kindly re-login first")));
                      }
                    }, child: Text("Yes")),

                  ],
                );
              });
              





            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.02,
                  vertical: MediaQuery.sizeOf(context).height * 0.01),
              child: Material(
                elevation: 5,
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.09,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width * 0.03,
                        vertical: MediaQuery.sizeOf(context).height * 0.01),
                    child: Row(
                      children: [
                        const Icon(Icons.delete, size: 25),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.04,
                        ),
                        const Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delete Account",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              bool result = await _authServices.logOut();

              print(result);
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.orangeAccent,
                    content: Text("Logging Out")));
                _navigationServices.pushReplacement("/login");
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.02,
                  vertical: MediaQuery.sizeOf(context).height * 0.01),
              child: Material(
                elevation: 5,
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.09,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width * 0.03,
                        vertical: MediaQuery.sizeOf(context).height * 0.01),
                    child: Row(
                      children: [
                        const Icon(Icons.logout, size: 25),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.04,
                        ),
                        const Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "LogOut",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:abhi_lo/Widgets/custom_button.dart';
// import 'package:abhi_lo/models/user_profile.dart';
// import 'package:abhi_lo/services/database_services.dart';
// import 'package:abhi_lo/services/shared_prefrences.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
//
// import '../services/auth_Services.dart';
// import '../services/navigation_services.dart';
//
// class Profilepage extends StatefulWidget {
//   const Profilepage({super.key});
//
//   @override
//   State<Profilepage> createState() => _ProfilepageState();
// }
//
// class _ProfilepageState extends State<Profilepage> {

//
//   @override
//   void initState() {

//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             IconButton(
//               onPressed: () async {
//                 bool result = await _authServices.logOut();
//                 print(result);
//                 if (result) {
//                   _navigationServices.pushReplacement("/login");
//                 }
//               },
//               icon: Icon(Icons.logout),
//             ),
//             CustomButton(
//                 text: "Firebase Test",
//                 isLoading: false,
//                 onPressed: () async {
//                   // await _databaseServices.getCurrentUser();
//                   String? name = await _localDataSaver.getName();
//                   String? email = await _localDataSaver.getEmail();
//                   int? walletAmount = await _localDataSaver.getWalletAmount();
//
//
//                   print("------------------------------>>>>>>>>>>>>>>>>>>>>>>>>printing the name from the localDataSaver: $name");
//                   print("------------------------------>>>>>>>>>>>>>>>>>>>>>>>>printing the name from the localDataSaver: $email");
//                   print("------------------------------>>>>>>>>>>>>>>>>>>>>>>>>printing the name from the localDataSaver: $walletAmount");
//
//
//                 },
//                 buttonColor: Colors.purple),
//             CustomButton(text: "Add Item", isLoading: false, onPressed: (){
//               _navigationServices.pushNamed("/addFood");
//             }, buttonColor: Colors.green)
//           ],
//         ),
//       ),
//     );
//   }
// }
