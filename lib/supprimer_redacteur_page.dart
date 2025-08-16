import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SupprimerRedacteurPage extends StatelessWidget {
  final String redacteurId;

  SupprimerRedacteurPage({super.key, required this.redacteurId});

  final ButtonStyle stylebouton = ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
  );

  void _supprimerRedacteur(BuildContext context) async {
    await FirebaseFirestore.instance.collection('redacteurs').doc(redacteurId).delete();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Succès'),
          content: const Text('Le rédacteur a été supprimé avec succès !'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supprimer Rédacteur'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Êtes-vous sûr de vouloir supprimer ce rédacteur ?'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: stylebouton,
              onPressed: () => _supprimerRedacteur(context),
              child: const Text('Supprimer le Rédacteur'),
            ),
          ],
        ),
      ),
    );
  }
}