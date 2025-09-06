import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EventAddScreen extends StatefulWidget {
  const EventAddScreen({super.key});

  @override
  State<EventAddScreen> createState() => _EventAddScreenState();
}

class _EventAddScreenState extends State<EventAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  String _titre = '';
  DateTime _date = DateTime.now();
  String _lieu = '';
  String _description = '';
  String? _errorMessage;
  String? _imagePath; // Chemin local de l'image
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await Future.delayed(const Duration(seconds: 2));
    print('Initialisation des permissions...');
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      print('Demande de permission caméra...');
      var newCameraStatus = await Permission.camera.request();
      if (!newCameraStatus.isGranted) {
        setState(() {
          _errorMessage = 'Permission caméra refusée';
        });
        print('Permission caméra non accordée: $newCameraStatus');
        return;
      }
    }
    print('Permission caméra accordée, initialisation caméra...');
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);
    try {
      await _cameraController.initialize();
      setState(() {
        _isCameraReady = true;
      });
      print('Caméra initialisée avec succès');
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur d\'initialisation de la caméra : $e';
      });
      print('Erreur caméra: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _takePicture() async {
    if (!_isCameraReady) {
      setState(() {
        _errorMessage = 'Caméra non prête';
      });
      return;
    }
    try {
      final XFile file = await _cameraController.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = path.join(directory.path, 'event_image_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.saveTo(imagePath);
      setState(() {
        _imagePath = imagePath;
      });
      _errorMessage = null; // Efface l'erreur si succès
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la capture : $e';
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _firestore.collection('events').add({
          'titre': _titre,
          'date': _date,
          'lieu': _lieu,
          'description': _description,
          'imageUrl': _imagePath ?? '', // Chemin local
          'isFavori': false,
        });
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _errorMessage = 'Erreur lors de l\'ajout : $e';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs';
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Ajouter Événement',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF4500)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFFFF4500)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Titre: ex. Festival des Masques',
                    labelStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Color(0xFF228B22),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                  onSaved: (value) => _titre = value!,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date: ex. Janvier 2026',
                      labelStyle: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Color(0xFF228B22),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      DateFormat('MMMM yyyy').format(_date),
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Lieu: ex. Porto Novo',
                    labelStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Color(0xFF228B22),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                  onSaved: (value) => _lieu = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description:',
                    labelStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Color(0xFF228B22),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                  onSaved: (value) => _description = value!,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF228B22),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _takePicture,
                  child: const Text('Ajouter Image', style: TextStyle(fontFamily: 'Roboto')),
                ),
                if (_imagePath != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.file(
                      File(_imagePath!),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler', style: TextStyle(fontFamily: 'Roboto')),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF228B22),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _submitForm,
                      child: const Text('Soumettre', style: TextStyle(fontFamily: 'Roboto')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}