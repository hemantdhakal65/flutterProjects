import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> initializeFirebaseServices() async {
  // Additional initialization if needed
}
