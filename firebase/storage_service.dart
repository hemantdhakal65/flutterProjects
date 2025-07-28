import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadPostImage(String filePath) async {
    final ref = _storage.ref().child('post_images/${DateTime.now().millisecondsSinceEpoch}');
    await ref.putFile(File(filePath));
    return await ref.getDownloadURL();
  }

  Future<String> uploadUserImage(String userId, String filePath) async {
    final ref = _storage.ref().child('user_images/$userId');
    await ref.putFile(File(filePath));
    return await ref.getDownloadURL();
  }
}