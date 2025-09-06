import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryItem {
  final String id;
  final String titre;
  final String periode; 
  final String description;
  final String imageUrl;
  final bool isFavori;

  HistoryItem({
    this.id = '',
    required this.titre,
    required this.periode,
    required this.description,
    required this.imageUrl,
    this.isFavori = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'periode': periode,
      'description': description,
      'imageUrl': imageUrl,
      'isFavori': isFavori,
    };
  }

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'] ?? '',
      titre: map['titre'] ?? '',
      periode: map['periode'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isFavori: map['isFavori'] ?? false,
    );
  }
}