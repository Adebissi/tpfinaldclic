import 'package:flutter/material.dart';

class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: const [
          Text(
            'Bienvenue au Magazine Infos',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Votre source d\'informations fiable et variée.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}