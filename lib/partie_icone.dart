import 'package:flutter/material.dart';

class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Column(
            children: [
              Icon(Icons.phone, size: 40),
              Text('Tel'),
            ],
          ),
          Column(
            children: [
              Icon(Icons.email, size: 40),
              Text('Mail'),
            ],
          ),
          Column(
            children: [
              Icon(Icons.share, size: 40),
              Text('Partage'),
            ],
          ),
        ],
      ),
    );
  }
}