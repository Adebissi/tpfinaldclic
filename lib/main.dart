import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testfirebase/database/database_helper.dart';
import 'package:testfirebase/events_screen.dart';
import 'package:testfirebase/gallery_screen.dart';
import 'package:testfirebase/history_screen.dart';
import 'page_accueil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  await Firebase.initializeApp();
  runApp(const MonAppli());
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bénin Culture Hub',
      theme: ThemeData(
        primarySwatch: Colors.pink, 
        fontFamily: 'Roboto', 
      ),
      home: const PageAccueil(),
    );
  }
}