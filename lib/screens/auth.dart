import 'package:firebase_auth/firebase_auth.dart';

///Encapsulates all needed FirebaseAuth methods and useful getters for later use
class Auth{
  ///Creates a  firebase instance for the whole app
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ///Gets current user if exists
  User? get currentUser => _firebaseAuth.currentUser;

  ///Get notifications if the auth sign changes states
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  ///Sends an email to reset password and do input validation and verification under the hood
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  ///Signs in a user with valid email and password credentials
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  ///Creates a new  user with valid email and password inputs
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  ///Logs out a current user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}