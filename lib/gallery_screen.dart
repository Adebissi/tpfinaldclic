import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'art_piece_add_screen.dart';
import 'models/art_piece.dart';
import 'art_piece_detail_screen.dart';
import 'page_accueil.dart'; // Assure-toi que ce fichier existe
import 'events_screen.dart'; // Assure-toi que ce fichier existe
import 'history_screen.dart'; // Assure-toi que ce fichier existe

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _navigateToScreen(int index) {
    if (index != 3) { // Évite de rediriger si l'onglet actuel est "Galerie"
      Widget screen;
      switch (index) {
        case 0:
          screen = const PageAccueil();
          break;
        case 1:
          screen = const EventsScreen();
          break;
        case 2:
          screen = const HistoryScreen();
          break;
        default:
          screen = const GalleryScreen();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.camera_alt, color: Color(0xFFFF4500)),
          onPressed: () {
            // Implémenter l'ouverture de la caméra (à lier à ArtPieceAddScreen)
          },
        ),
        title: const Text(
          'Galerie',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFFF4500)),
            onPressed: () {
              // Implémenter la recherche
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFFF4500)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArtPieceAddScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('art_pieces').snapshots(), // Corrige en 'art_pieces'
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final items = snapshot.data!.docs
                        .map((doc) => ArtPiece.fromMap({
                              ...doc.data() as Map<String, dynamic>,
                              'id': doc.id,
                            }))
                        .toList();
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArtPieceDetailScreen(item: item),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: 'art_image_${item.id}',
                                  child: item.imageUrl.isNotEmpty && File(item.imageUrl).existsSync()
                                      ? Image.file(
                                          File(item.imageUrl),
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Image.asset(
                                            'assets/images/default_event.jpg',
                                            height: 120,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Image.asset(
                                          'assets/images/default_event.jpg',
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item.titre,
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
                BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Événements'),
                BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histoire'),
                BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Galerie'),
              ],
              currentIndex: 3, // "Galerie" actif par défaut
              selectedItemColor: const Color(0xFF228B22),
              unselectedItemColor: const Color(0xFFFF4500),
              onTap: _navigateToScreen,
            ),
          ],
        ),
      ),
    );
  }
}