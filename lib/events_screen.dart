import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'event_add_screen.dart';
import 'event_detail_screen.dart';
import 'models/event.dart';
import 'page_accueil.dart'; // Assure-toi que ce fichier existe
import 'gallery_screen.dart';
import 'history_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';
  String _locationFilter = '';

  void _navigateToScreen(int index) {
    if (index != 1) { // Évite de rediriger si l'onglet actuel est déjà "Événements"
      Widget screen;
      switch (index) {
        case 0:
          screen = const PageAccueil();
          break;
        case 2:
          screen = const HistoryScreen();
          break;
        case 3:
          screen = const GalleryScreen();
          break;
        default:
          screen = const EventsScreen();
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
        title: const Text(
          'Événements',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFFF4500)),
            onPressed: () {
              // Peut-être ajouter un dialogue de recherche
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFFF4500)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventAddScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Rechercher (titre, description)',
                      labelStyle: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: Color(0xFF228B22),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 0.5),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Localisation: ex. Ouidah',
                      labelStyle: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: Color(0xFF228B22),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 0.5),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _locationFilter = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('events')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                print('Données reçues: ${snapshot.data!.docs.length} documents');
                final events = snapshot.data!.docs
                    .map((doc) => Event.fromMap({
                          ...doc.data() as Map<String, dynamic>,
                          'id': doc.id,
                        }))
                    .where((event) =>
                        event.titre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        event.description.toLowerCase().contains(_searchQuery.toLowerCase()))
                    .where((event) => event.lieu.toLowerCase().contains(_locationFilter.toLowerCase()))
                    .toList();
                if (events.isEmpty) {
                  return const Center(child: Text('Aucun événement trouvé'));
                }
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: ListTile(
                        leading: event.imageUrl.isNotEmpty && File(event.imageUrl).existsSync()
                            ? Hero(
                                tag: 'event_image_${event.id}',
                                child: Image.file(
                                  File(event.imageUrl),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Image.asset(
                                    'assets/images/default_event.jpg',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Hero(
                                tag: 'event_image_${event.id}',
                                child: Image.asset(
                                  'assets/images/default_event.jpg',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        title: Text(
                          event.titre,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Date/Lieu: ${event.lieu}, ${event.date.year}',
                          style: const TextStyle(fontFamily: 'Roboto', fontSize: 14),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                event.isFavori ? Icons.favorite : Icons.favorite_border,
                                color: const Color(0xFF228B22),
                              ),
                              onPressed: () async {
                                await _firestore.collection('events').doc(event.id).update({
                                  'isFavori': !event.isFavori,
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.share, color: Color(0xFF228B22)),
                              onPressed: () {
                                // Implémenter le partage
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailScreen(event: event),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Événements'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histoire'),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Galerie'),
        ],
        currentIndex: 1, // Événements actif par défaut
        selectedItemColor: const Color(0xFF228B22),
        unselectedItemColor: const Color(0xFFFF4500),
        onTap: _navigateToScreen,
      ),
    );
  }
}