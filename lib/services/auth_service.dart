import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> registerUser(
      String firstName, String lastName, String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
        );
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        return newUser;
      }
    } catch (e) {
      print('Error registering user: $e');
    }
    return null;
  }

  Future<UserModel?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error logging in user: $e');
    }
    return null;
  }

  Future<void> logoutUser() async {
    await _firebaseAuth.signOut();
  }
}
