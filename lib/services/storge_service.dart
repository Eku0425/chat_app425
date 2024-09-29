import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  StorageService._();
  static StorageService service = StorageService._();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Future<String> uploadImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final reference = FirebaseStorage.instance.ref();
    final imageReference = reference.child("image/${image!.name}");
    await imageReference.putFile(File(image.path));
    String url = await imageReference.getDownloadURL();
    return url;
  }
}
