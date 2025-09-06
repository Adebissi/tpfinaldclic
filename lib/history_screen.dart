import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'history_add_screen.dart';
import 'models/history_item.dart';
import 'history_detail_screen.dart';
import 'page_accueil.dart'; // Assure-toi que ce fichier existe
import 'events_screen.dart'; // Assure-toi que ce fichier existe
import 'gallery_screen.dart'; // Assure-toi que ce fichier existe

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _navigateToScreen(int index) {
    if (index != 2) { // Évite de rediriger si l'onglet actuel est "Histoire"
      Widget screen;
      switch (index) {
        case 0:
          screen = const PageAccueil();
          break;
        case 1:
          screen = const EventsScreen();
          break;
        case 3:
          screen = const GalleryScreen();
          break;
        default:
          screen = const HistoryScreen();
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
          icon: const Icon(Icons.search, color: Color(0xFFFF4500)),
          onPressed: () {
            // Implémenter la recherche
          },
        ),
        title: const Text(
          'Histoire',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFFF4500)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryAddScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Timeline Interactive',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore.collection('history').orderBy('periode').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          final items = snapshot.data!.docs
                              .map((doc) => HistoryItem.fromMap({
                                    ...doc.data() as Map<String, dynamic>,
                                    'id': doc.id,
                                  }))
                              .toList();
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HistoryDetailScreen(item: item),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 250,
                                    child: Card(
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Hero(
                                            tag: 'history_image_${item.id}',
                                            child: item.imageUrl.isNotEmpty && File(item.imageUrl).existsSync()
                                                ? Image.file(
                                                    File(item.imageUrl),
                                                    height: 80, // Réduit à 80 pixels
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) => Image.asset(
                                                      'assets/images/default_event.jpg',
                                                      height: 80,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : Image.asset(
                                                    'assets/images/default_event.jpg',
                                                    height: 80,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    item.titre,
                                                    style: const TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: const Color(0xFF228B22),
                                                        foregroundColor: Colors.white,
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                        minimumSize: const Size(0, 0),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => HistoryDetailScreen(item: item),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text('Détails', style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Section Quiz',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF228B22),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // Implémenter le quiz
                      },
                      child: const Text('Tester vos connaissances', style: TextStyle(fontFamily: 'Roboto')),
                    ),
                  ),
                ],
              ),
            ),
            BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
                BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Événements'),
                BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histoire'),
                BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Galerie'),
              ],
              currentIndex: 2, // "Histoire" actif par défaut
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