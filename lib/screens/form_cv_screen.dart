import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cv_model.dart';
import '../services/firestore_service.dart';
import 'home_screen.dart';
import '../widgets/custom_input_field.dart';

class FormCVScreen extends StatefulWidget {
  const FormCVScreen({super.key});

  @override
  _FormCVScreenState createState() => _FormCVScreenState();
}

class _FormCVScreenState extends State<FormCVScreen> {
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController competencesController = TextEditingController();

  List<Map<String, TextEditingController>> formationsControllers = [];
  List<Map<String, TextEditingController>> experiencesControllers = [];

  String? uploadedPhotoUrl;

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _addFormation();
    _addExperience();
  }

  void _addFormation() {
    setState(() {
      formationsControllers.add({
        'diplome': TextEditingController(),
        'annee': TextEditingController(),
      });
    });
  }

  void _addExperience() {
    setState(() {
      experiencesControllers.add({
        'poste': TextEditingController(),
        'entreprise': TextEditingController(),
      });
    });
  }

  Future<void> _uploadPhoto() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      final File file = File(result.files.single.path!);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('photos/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = await storageRef.putFile(file);

      final url = await uploadTask.ref.getDownloadURL();

      setState(() {
        uploadedPhotoUrl = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo uploadée avec succès')),
      );
    }
  }

  void _saveCV() async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utilisateur non connecté')),
        );
        return;
      }

      final List<Map<String, dynamic>> formations = formationsControllers
          .map((controllers) => {
                'diplome': controllers['diplome']!.text.trim(),
                'annee': controllers['annee']!.text.trim(),
              })
          .toList();

      final List<Map<String, dynamic>> experiences = experiencesControllers
          .map((controllers) => {
                'poste': controllers['poste']!.text.trim(),
                'entreprise': controllers['entreprise']!.text.trim(),
              })
          .toList();

      CvModel cv = CvModel(
        prenom: prenomController.text.trim(),
        nom: nomController.text.trim(),
        email: emailController.text.trim(),
        telephone: telephoneController.text.trim(),
        formations: formations,
        experiences: experiences,
        competences: competencesController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .toList(),
        photoUrl: uploadedPhotoUrl ?? '',
      );

      await _firestoreService.saveCV(uid, cv);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CV sauvegardé avec succès')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulaire CV'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CustomInputField(label: 'Prénom', controller: prenomController),
            CustomInputField(label: 'Nom', controller: nomController),
            CustomInputField(label: 'Email', controller: emailController),
            CustomInputField(
                label: 'Téléphone', controller: telephoneController),
            const SizedBox(height: 20),
            const Text('Formations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            for (var formation in formationsControllers)
              Column(
                children: [
                  CustomInputField(
                      label: 'Diplôme', controller: formation['diplome']!),
                  CustomInputField(
                      label: 'Année', controller: formation['annee']!),
                  const SizedBox(height: 10),
                ],
              ),
            TextButton(
              onPressed: _addFormation,
              child: const Text('Ajouter une formation'),
            ),
            const SizedBox(height: 20),
            const Text('Expériences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            for (var experience in experiencesControllers)
              Column(
                children: [
                  CustomInputField(
                      label: 'Poste', controller: experience['poste']!),
                  CustomInputField(
                      label: 'Entreprise',
                      controller: experience['entreprise']!),
                  const SizedBox(height: 10),
                ],
              ),
            TextButton(
              onPressed: _addExperience,
              child: const Text('Ajouter une expérience'),
            ),
            const SizedBox(height: 20),
            CustomInputField(
                label: 'Compétences (séparées par ,)',
                controller: competencesController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadPhoto,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Choisir et uploader une photo',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCV,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Enregistrer',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
