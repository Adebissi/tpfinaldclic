import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ModifierRedacteurPage extends StatefulWidget {
  final String redacteurId;
  final Map<String, dynamic> redacteurData;

  const ModifierRedacteurPage({
    super.key,
    required this.redacteurId,
    required this.redacteurData,
  });

  @override
  State<ModifierRedacteurPage> createState() => _ModifierRedacteurPageState();
}

class _ModifierRedacteurPageState extends State<ModifierRedacteurPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController _nomController;
  late TextEditingController _specialiteController;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.redacteurData['nom']);
    _specialiteController = TextEditingController(text: widget.redacteurData['specialite']);
  }

  void _enregistrerModifications() async {
    final modifications = {
      'nom': _nomController.text,
      'specialite': _specialiteController.text,
    };

    await _firestore.collection('redacteurs').doc(widget.redacteurId).update(modifications);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Succès'),
          content: const Text('Les informations du rédacteur ont été modifiées avec succès !'),
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
        title: const Text('Modifier Rédacteur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom du Rédacteur'),
            ),
            TextFormField(
              controller: _specialiteController,
              decoration: const InputDecoration(labelText: 'Spécialité du Rédacteur'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enregistrerModifications,
              child: const Text('Enregistrer les Modifications'),
            ),
          ],
        ),
      ),
    );
  }
}