import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ArtPieceAddScreen extends StatefulWidget {
  const ArtPieceAddScreen({super.key});

  @override
  State<ArtPieceAddScreen> createState() => _ArtPieceAddScreenState();
}

class _ArtPieceAddScreenState extends State<ArtPieceAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _titre = '';
  String _artiste = '';
  String _description = '';
  String? _errorMessage;
  String? _imagePath;
  String? _imageUrl;
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      var newCameraStatus = await Permission.camera.request();
      if (!newCameraStatus.isGranted) {
        setState(() {
          _errorMessage = 'Permission caméra refusée';
        });
        return;
      }
    }
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);
    try {
      await _cameraController.initialize();
      setState(() {
        _isCameraReady = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur d\'initialisation de la caméra : $e';
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
      final imagePath = path.join(directory.path, 'art_piece_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.saveTo(imagePath);
      setState(() {
        _imagePath = imagePath;
        _imageUrl = imagePath; // Assure que _imageUrl est défini
      });
      _errorMessage = null;
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
        await _firestore.collection('art_pieces').add({ // Corrige en 'art_pieces' sans 's' au pluriel
          'titre': _titre,
          'artiste': _artiste.isEmpty ? 'Anonyme' : _artiste, // Par défaut "Anonyme" si vide
          'description': _description,
          'imageUrl': _imageUrl ?? '',
          'isFavori': false,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Œuvre ajoutée avec succès')),
        );
        Navigator.pop(context);
      } catch (e) {
        print('Erreur Firestore : $e'); // Log pour débogage
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF4500)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ajouter Œuvre',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Titre: ex. Masques',
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
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                        ],
                      ),
                    ),
                  ],
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