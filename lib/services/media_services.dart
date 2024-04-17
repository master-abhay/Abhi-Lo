import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MediaServices {
  late ImagePicker _imagePicker;

  MediaServices() {
    _imagePicker = ImagePicker();
  }

  Future<File?> getImageFromGallery() async {
    final XFile? file =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      return File(file.path);
    }
    return null;
  }
}
