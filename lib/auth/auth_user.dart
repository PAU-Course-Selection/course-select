import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String id;
  final String name;
  final String email;
  final bool isEmailVerified;
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
    id: user.uid,
    email: user.email!,
    name: user.displayName!,
    isEmailVerified: user.emailVerified,
  );
}