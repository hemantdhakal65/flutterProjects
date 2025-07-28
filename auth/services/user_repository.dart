import '../../firebase/firestore_service.dart';  // <- fixed path
import '../models/user_model.dart';               // <- fixed path

class UserRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> createUser(UserModel user) async {
    await _firestoreService.createUser(user);
  }

  Future<UserModel?> getUser(String uid) async {
    return await _firestoreService.getUser(uid);
  }
}
