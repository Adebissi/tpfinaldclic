import 'package:flutter/material.dart';

class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Text(
        'Magazine Infos est un magazine numérique couvrant divers sujets comme la technologie, la science, le sport et plus encore.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}