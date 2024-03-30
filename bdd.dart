import 'package:flutter/material.dart';

class MyAppState extends ChangeNotifier {
  User? currentUser;

  void setCurrentUser(User user) {
    currentUser = user;
    notifyListeners();
  }
}

class User {
  final String id;
  final String name;
  final String lastName;
  final String email;
  final int age;
  final String username;
  final String password;
  final String schoolLevel;
  final String specialty;
  final String section;
  final String group;
  final String schoolYear;

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.age,
    required this.username,
    required this.password,
    required this.schoolLevel,
    required this.specialty,
    required this.section,
    required this.group,
    required this.schoolYear,
  });

  static User? fromJson(Map<String, dynamic> user) {}
}

// Liste des utilisateurs autorisés
final List<User> validUsers = [
  User(
      id: '1',
      name: 'nourhene',
      lastName: 'benarbia',
      email: 'nour.example@gmail.com',
      age: 20,
      username: 'nour',
      password: 'nournour',
      schoolLevel: 'L3',
      specialty: 'isil',
      section: 'Section 1',
      group: 'Groupe 2',
      schoolYear: '2024/2025'),

  User(
      id: '2',
      name: 'ines',
      lastName: 'benarbia',
      email: 'ines.example@gmail.com',
      age: 18,
      username: 'ines',
      password: 'inesines',
      schoolLevel: 'L1',
      specialty: 'isil',
      section: 'Section A',
      group: 'Groupe 2',
      schoolYear: '2024/2025'),

  User(
      id: '3',
      name: 'assia',
      lastName: 'benmokrane',
      email: 'assia.example@gmail.com',
      age: 20,
      username: 'assia',
      password: 'assiaassia',
      schoolLevel: 'L3',
      specialty: 'isil',
      section: 'Section 1',
      group: 'Groupe 2',
      schoolYear: '2024/2025'),
  // Ajoutez d'autres utilisateurs au besoin
];
