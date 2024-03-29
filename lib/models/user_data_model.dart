import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

///User model class with attributes which define what a user is
class UserModel{
  String? uid;
  String? displayName;
  Timestamp? dateCreated = Timestamp.now();
  String? avatar;
  String? email;
  List<dynamic>? courses;
  List<dynamic>? interests;
  int? studentLevel;


  ///A constructor for setting attribute values when creating a user object
   UserModel ({
    required this.uid,
    required this.displayName,
    required this.dateCreated,
    this.avatar,
    this.email,
     this.courses
  });

  ///Receives a map which matches class attributes
  UserModel.fromMap(Map<String, dynamic> data) {
    uid = data['uid'];
    displayName = data['displayName'];
    dateCreated = data['dateCreated'];
    avatar = data['avatar'];
    email = data['email'];
    courses = data['courses'];
    interests = data['interests'];
    studentLevel = data['studentLevel'];
  }
}