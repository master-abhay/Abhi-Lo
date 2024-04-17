import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageServices {
  late FirebaseStorage _firebaseStorage;

  StorageServices() {
    _firebaseStorage = FirebaseStorage.instance;
  }

  Future<String?> uploadItemImage(
      {required File file, required String? itemCategory}) async {
    Reference fileRef = _firebaseStorage
        .ref("Food/Food Items")
        .child('$itemCategory${DateTime.now().microsecondsSinceEpoch}${DateTime.now().millisecond}${p.extension(file.path)}');
    print(
        "Printing the file refrence in storage_services......................................................${fileRef}");

    UploadTask task = fileRef.putFile(file);
    print(
        "printing the task in the storage_services class..............................................................${task}");

    return task.then((myTask) {
      if (myTask.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
    });
  }
}
