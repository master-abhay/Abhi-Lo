import 'dart:io';

import 'package:abhi_lo/Widgets/custom_button.dart';
import 'package:abhi_lo/models/addItem_model.dart';
import 'package:abhi_lo/services/alert_services.dart';
import 'package:abhi_lo/services/database_services.dart';
import 'package:abhi_lo/services/media_services.dart';
import 'package:abhi_lo/services/storage_services.dart';
import 'package:abhi_lo/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/navigation_services.dart';
import 'admin_widgets/addItem_formField.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  // for button:
  bool isLoading = false;
  late MediaServices _mediaServices;
  File? selectedImage;

  late GlobalKey<FormState> _addItemFormKey;
  String? itemName, itemPrice, itemDetail, itemCategory;

  String? _selectedCategoryValue = "";
  final _categoryList = ['Veg', "Non-Veg", "Chinese", "Sweets"];

  late NavigationServices _navigationServices;
  late StorageServices _storageServices;
  late DatabaseServices _databaseServices;
  late AlertServices _alertServices;

  @override
  void initState() {
    _addItemFormKey = GlobalKey<FormState>();

    _selectedCategoryValue = _categoryList[0];
    GetIt _getIt = GetIt.instance;
    _navigationServices = _getIt.get<NavigationServices>();
    _mediaServices = _getIt.get<MediaServices>();
    _storageServices = _getIt.get<StorageServices>();
    _databaseServices = _getIt.get<DatabaseServices>();
    _alertServices = _getIt.get<AlertServices>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUI(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        "Add Item",
        style: boldTextStyle(),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          _navigationServices.goBack();
        },
        icon: const Icon(
          Icons.arrow_back_ios_new,
          size: 25,
        ),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height * 0.02,
            horizontal: MediaQuery.sizeOf(context).width * 0.05),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height * 0.03,
          ),
          child: Form(
            key: _addItemFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Upload the Item picture",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.01,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      File? file = await _mediaServices.getImageFromGallery();

                      if (file != null) {
                        setState(() {
                          selectedImage = file;
                        });
                      }
                    },
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * 0.2,
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black),
                            color: Colors.grey.withOpacity(0.2)),
                        child: selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ))
                            : const Icon(Icons.photo_camera_back_outlined),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                const Text(
                  "Item Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.01,
                ),
                AddItemFormField(
                  onSaved: (value) {
                    setState(() {
                      itemName = value;
                      print(
                          "-------------------->>>>>>>>>>>>>>>>>printing the itemName: $itemName");
                    });
                  },
                  hintText: 'Enter Item Name',
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                const Text(
                  "Item Price",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.01,
                ),
                AddItemFormField(
                  onSaved: (value) {
                    setState(() {
                      itemPrice = value;
                      print(
                          "-------------------->>>>>>>>>>>>>>>>>printing the itemName: $itemPrice");
                    });
                  },
                  hintText: 'Enter Item Price',
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                const Text(
                  "Item Detail",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.01,
                ),
                AddItemFormField(
                  onSaved: (value) {
                    setState(() {
                      itemDetail =
                          value!.replaceAll(RegExp(r'\s+'), ' ').trim();
                      print(
                          "-------------------->>>>>>>>>>>>>>>>>printing the itemName: $itemDetail");
                    });
                  },
                  hintText: 'Enter Item Detail',
                  maxLines: 5,
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                const Text(
                  "Item Category",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.02),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonFormField(
                    onSaved: (value) {
                      itemCategory = _selectedCategoryValue;
                      print(
                          "-------------------->>>>>>>>>>>>>>>>>printing the itemName: $itemCategory");
                    },
                    value: _selectedCategoryValue,
                    items: _categoryList
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryValue = value;
                      });
                    },
                    dropdownColor: Colors.grey,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          (Icons.category_outlined),
                          color: Colors.purple,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                Center(
                    child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        child: CustomButton(
                            text: "Add Item",
                            isLoading: isLoading,
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                              if (selectedImage != null &&
                                  _addItemFormKey.currentState!.validate()) {
                                //Saving the values of the form:
                                _addItemFormKey.currentState!.save();

                                //Getting the Download url of the image
                                String? imageDownloadUrl =
                                    await _storageServices.uploadItemImage(
                                        file: selectedImage!,
                                        itemCategory: itemCategory);

                                print(
                                    "-------------------->>>>>>>>>>>>>Image Uploaded and the image url is: $imageDownloadUrl");

                                AddItem addItem = AddItem(
                                    imgUrl: imageDownloadUrl,
                                    itemName: itemName,
                                    itemPrice: itemPrice,
                                    itemDetail: itemDetail,
                                    itemCategory: itemCategory);

                                bool result =
                                    await _databaseServices.setUpItem(addItem);
                                if (result) {
                                  setState(() {});
                                  _alertServices.showToast(
                                      text: "Item Added successfully");
                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  setState(() {});
                                  _alertServices.showToast(
                                      text: "Something went Wrong");
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            buttonColor: Colors.black)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
