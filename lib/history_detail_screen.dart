import 'dart:io';
import 'package:flutter/material.dart';
import 'models/history_item.dart';

class HistoryDetailScreen extends StatelessWidget {
  final HistoryItem item;

  const HistoryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    print('Détails chargés: titre = ${item.titre}, periode = ${item.periode}, imageUrl = ${item.imageUrl}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF4500)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          item.titre,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Hero(
                tag: 'history_image_${item.id}',
                child: item.imageUrl.isNotEmpty && File(item.imageUrl).existsSync()
                    ? Image.file(
                        File(item.imageUrl),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Erreur image: $error');
                          return Image.asset(
                            'assets/images/default_event.jpg',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/default_event.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Période: ${item.periode}',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Détails: ${item.description}',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        label: 'Favoris',
                        icon: Icons.favorite,
                        onTap: () {
                          // Implémenter la logique des favoris
                        },
                      ),
                      _buildActionButton(
                        label: 'Partager',
                        icon: Icons.share,
                        onTap: () {
                          // Implémenter la logique de partage
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(1.0),
        transformAlignment: Alignment.center,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF228B22),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: Icon(icon, size: 16),
          label: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}