import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'modifier_redacteur_page.dart';
import 'supprimer_redacteur_page.dart';

class RedacteurInfoPage extends StatelessWidget {
  // const RedacteurInfoPage({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations des Rédacteurs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('redacteurs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Erreur lors du chargement des données');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final redacteurs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: redacteurs.length,
            itemBuilder: (context, index) {
              final redacteur = redacteurs[index].data() as Map<String, dynamic>;
              final redacteurId = redacteurs[index].id;
              return Card(
                child: ListTile(
                  title: Text(redacteur['nom']),
                  subtitle: Text(redacteur['specialite']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModifierRedacteurPage(
                                redacteurId: redacteurId,
                                redacteurData: redacteur,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupprimerRedacteurPage(redacteurId: redacteurId),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}