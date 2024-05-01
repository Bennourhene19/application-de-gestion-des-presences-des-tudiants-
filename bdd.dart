import 'package:flutter/material.dart';

class MyAppState extends ChangeNotifier {
  User? currentUser;

  void setCurrentUser(User user) {
    currentUser = user;
    notifyListeners();
  }
}

class Student {
  final String firstName;
  final String lastName;
  final String section;
  final String group;
  final String subject;
  bool isPresent;
  List<int> grades;

  Student(this.firstName, this.lastName, this.section, this.group, this.subject,
      {this.isPresent = false, required this.grades});

  // Méthode pour créer une instance de Student à partir d'un objet JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      json['firstName'],
      json['lastName'],
      json['section'],
      json['group'],
      json['subject'],
      isPresent: json['isPresent'] ?? false,
      grades: List<int>.from(json['grades'].map((x) => x as int)),
    );
  }

  // Méthode pour convertir un objet Student en un objet JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'section': section,
      'group': group,
      'subject': subject,
      'isPresent': isPresent,
      'grades': grades,
    };
  }
}

List<Student> students = [
  Student('John', 'Doe', 'Section A', 'Groupe 1', 'Mathématiques',
      isPresent: true, grades: [12, 14, 11]),
  Student('Jane', 'Smith', 'Section A', 'Groupe 1', 'Mathématiques',
      isPresent: true, grades: [12, 14, 11]),
  Student('Alice', 'Johnson', 'Section A', 'Groupe 1', 'Mathématiques',
      isPresent: false, grades: [12, 14, 11]),
  //------------
  Student('Bob', 'Brown', 'Section A', 'Groupe 2', 'Physique',
      isPresent: true, grades: [0, 0, 0]),
  Student('Emily', 'Wilson', 'Section A', 'Groupe 2', 'Physique',
      isPresent: true, grades: [0, 0, 0]),
  Student('Michael', 'Taylor', 'Section A', 'Groupe 2', 'Physique',
      isPresent: true, grades: [0, 0, 0]),
  //------------
  Student('David', 'Clark', 'Section A', 'Groupe 3', 'Chimie',
      isPresent: true, grades: [0, 0, 0]),
  Student('Sophia', 'Martinez', 'Section A', 'Groupe 3', 'Chimie',
      grades: [0, 0, 0]),
  Student('Olivia', 'Garcia', 'Section A', 'Groupe 3', 'Chimie',
      isPresent: true, grades: [0, 0, 0]),
  //------------
  Student('Chloe', 'Brich', 'Section A', 'Groupe 4', 'Science',
      grades: [0, 0, 0]),
  Student('Brianna', 'Stew', 'Section A', 'Groupe 4', 'Science',
      isPresent: true, grades: [0, 0, 0]),
  Student('Nia', 'Lu', 'Section A', 'Groupe 4', 'Science',
      isPresent: true, grades: [0, 0, 0]),
];

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
  final String imageURL; // Champ pour l'URL de l'image

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
    required this.imageURL, // Ajoutez cet argument au constructeur
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
      schoolYear: '2024/2025',
      imageURL:
          'URL_de_l_image'), // Remplacez 'URL_de_l_image' par l'URL réelle de l'image

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
      schoolYear: '2024/2025',
      imageURL: 'URL_de_l_image'),

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
      schoolYear: '2024/2025',
      imageURL: 'URL_de_l_image'),
  // Ajoutez d'autres utilisateurs au besoin
];

class Seance {
  DateTime date;
  String sujet;
  List<Student> etudiants;
  String salle;
  String groupe; // Ajout du champ groupe
  String matiere; // Ajout du champ matiere
  String typeSeance; // Ajout du champ typeSeance

  Seance({
    required this.date,
    required this.sujet,
    required this.etudiants,
    required this.salle,
    required this.groupe,
    required this.matiere,
    required this.typeSeance,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'sujet': sujet,
      'etudiants': etudiants.map((student) => student.toJson()).toList(),
      'salle': salle,
      'groupe': groupe,
      'matiere': matiere,
      'typeSeance': typeSeance,
    };
  }

  static Seance fromJson(Map<String, dynamic> json) {
    List<Student> etudiants = (json['etudiants'] as List)
        .map((studentJson) => Student.fromJson(studentJson))
        .toList();

    return Seance(
      date: DateTime.parse(json['date']),
      sujet: json['sujet'],
      etudiants: etudiants,
      salle: json['salle'],
      groupe: json['groupe'],
      matiere: json['matiere'],
      typeSeance: json['typeSeance'],
    );
  }
}
