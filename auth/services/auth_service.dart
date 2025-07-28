import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase/firebase_config.dart';
import '../../firebase/firestore_service.dart';
import '../../auth/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = firebaseAuth;
  final FirestoreService _firestore = FirestoreService();

  /// Sign in anonymously and create minimal user profile
  Future<User?> signInAnonymously() async {
    try {
      final cred = await _auth.signInAnonymously();
      final user = cred.user;

      if (user != null) {
        // Create minimal anonymous user profile
        final userModel = UserModel(
          uid: user.uid,
          isAnonymous: true,
        );

        // Save to Firestore
        await _firestore.createUser(userModel);
      }
      return user;
    } catch (e) {
      throw Exception('Anonymous sign-in failed: $e');
    }
  }

  /// Email/password sign-in
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      throw Exception('Email sign-in failed: $e');
    }
  }

  /// Email/password registration
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      throw Exception('Email registration failed: $e');
    }
  }

  /// Start phone verification and return the verificationId
  Future<String> getVerificationId(String phone) async {
    final completer = Completer<String>();
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (_) {},
      verificationFailed: (e) => completer.completeError(e),
      codeSent: (verificationId, _) => completer.complete(verificationId),
      codeAutoRetrievalTimeout: (verificationId) {
        if (!completer.isCompleted) completer.complete(verificationId);
      },
    );
    return completer.future;
  }

  /// Alias for existing callers who expect `verifyPhoneNumber()`
  Future<String> verifyPhoneNumber(String phone) {
    return getVerificationId(phone);
  }

  /// Sign in with SMS code
  Future<User?> loginWithPhone(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final cred = await _auth.signInWithCredential(credential);
      return cred.user;
    } catch (e) {
      throw Exception('Phone login failed: $e');
    }
  }

  /// Register via phone + password
  Future<User?> registerWithPhone(
      String phone,
      String password,
      String verificationId,
      String smsCode,
      ) async {
    try {
      // 1) Sign in with the SMS credential
      final smsCred = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCred = await _auth.signInWithCredential(smsCred);

      // 2) Create a dummy email and attach password
      final email = '$phone@bookme.app';
      await userCred.user!
          .verifyBeforeUpdateEmail(email)
          .then((_) => userCred.user!.updatePassword(password));

      return userCred.user;
    } catch (e) {
      throw Exception('Phone registration failed: $e');
    }
  }

  /// Send password‑reset email
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Confirm password reset with OOB code
  Future<void> confirmPasswordReset(String oobCode, String newPassword) async {
    try {
      await _auth.confirmPasswordReset(
        code: oobCode,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception('Password reset confirmation failed: $e');
    }
  }

  /// Change password for the current user
  Future<void> changePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Password change failed: $e');
    }
  }
}