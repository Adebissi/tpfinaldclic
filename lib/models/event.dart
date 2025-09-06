import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String titre;
  final DateTime date;
  final String lieu;
  final String description;
  final String imageUrl;
  final bool isFavori;

  Event({
    this.id = '',
    required this.titre,
    required this.date,
    required this.lieu,
    required this.description,
    required this.imageUrl,
    this.isFavori = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'date': date, // Firestore convertira automatiquement en Timestamp
      'lieu': lieu,
      'description': description,
      'imageUrl': imageUrl,
      'isFavori': isFavori,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      titre: map['titre'] ?? '',
      date: (map['date'] is Timestamp)
          ? (map['date'] as Timestamp).toDate() 
          : DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()), 
      lieu: map['lieu'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isFavori: map['isFavori'] ?? false,
    );
  }
}