import 'package:cloud_firestore/cloud_firestore.dart';

class ArtPiece {
  final String id;
  final String titre;
  final String artiste; 
  final String description;
  final String imageUrl;
  final bool isFavori;

  ArtPiece({
    this.id = '',
    required this.titre,
    required this.artiste,
    required this.description,
    required this.imageUrl,
    this.isFavori = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'artiste': artiste,
      'description': description,
      'imageUrl': imageUrl,
      'isFavori': isFavori,
    };
  }

  factory ArtPiece.fromMap(Map<String, dynamic> map) {
    return ArtPiece(
      id: map['id'] ?? '',
      titre: map['titre'] ?? '',
      artiste: map['artiste'] ?? 'Anonyme',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isFavori: map['isFavori'] ?? false,
    );
  }
}