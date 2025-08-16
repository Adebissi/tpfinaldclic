import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AjoutRedacteurPage extends StatefulWidget {
  const AjoutRedacteurPage({super.key});

  @override
  State<AjoutRedacteurPage> createState() => _AjoutRedacteurPageState();
}

class _AjoutRedacteurPageState extends State<AjoutRedacteurPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _specialiteController = TextEditingController();

  final ButtonStyle stylebouton = ElevatedButton.styleFrom(
    backgroundColor: Colors.pink,
  );

  void _ajouterRedacteur() async {
    if (_formKey.currentState!.validate()) {
      final nom = _nomController.text;
      final specialite = _specialiteController.text;

      await FirebaseFirestore.instance.collection('redacteurs').add({
        'nom': nom,
        'specialite': specialite,
      });

      _afficherSuccesDialog();
    }
  }

  void _afficherSuccesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Succès'),
          content: const Text('Le rédacteur a été ajouté avec succès !'),
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
  void dispose() {
    _nomController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Rédacteur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom du Rédacteur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _specialiteController,
                decoration: const InputDecoration(labelText: 'Spécialité du Rédacteur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une spécialité';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: stylebouton,
                onPressed: _ajouterRedacteur,
                child: const Text('Ajouter Rédacteur'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}