import 'package:flutter/material.dart';

class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Rubriques',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/rubrique1.jpg',
                width: 150,
                height: 120,
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/images/rubrique2.jpg',
                width: 150,
                height: 120,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ],
      ),
    );
  }
}