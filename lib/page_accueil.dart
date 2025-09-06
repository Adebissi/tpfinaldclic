import 'package:flutter/material.dart';
import 'gallery_screen.dart';
import 'history_screen.dart';
import 'events_screen.dart';

class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key});

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  int _selectedIndex = 0;

  // Liste des écrans
  final List<Widget> _screens = [
    const PageAccueilContent(),
    const EventsScreen(),
    const HistoryScreen(),
    const GalleryScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _screens[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(Icons.logo_dev_outlined, size: 24, color: Color(0xFFFF4500)),
        title: const Text(
          'Benin Culture Hub',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 24, color: Color(0xFFFF4500)),
            onPressed: () {},
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Événements'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histoire'),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Galerie'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF228B22),
        unselectedItemColor: const Color(0xFFFF4500),
        onTap: _onItemTapped,
      ),
    );
  }
}

// Contenu de la page d'accueil
class PageAccueilContent extends StatelessWidget {
  const PageAccueilContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            color: const Color(0xFFE0E0E0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '[Image Hero]',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Festival Vaudou',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Janvier 2026',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                Card(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '[Image]',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Histoire du Dahomey',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Color(0xFF228B22),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Card(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '[Image]',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Bronzes du Bénin',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Color(0xFF228B22),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder pour EventsScreen
