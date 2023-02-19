import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> userSetup({required String displayName, required String email}) async {
  final data  = FirebaseFirestore.instance ;
  CollectionReference users = data.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String? uid = auth.currentUser?.uid.toString();
  users.add(
      {
        'displayName': displayName,
        'uid': uid,
        'email': email
      });
}
