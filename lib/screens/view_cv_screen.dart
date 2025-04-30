import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/cv_model.dart';
import '../utils/pdf_generator.dart';

class ViewCVScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  ViewCVScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon CV'),
        backgroundColor: Colors.green,
      ),
      body: uid == null
          ? const Center(
              child: Text('Utilisateur non connecté.'),
            )
          : FutureBuilder<CvModel>(
              future: _firestoreService.getCV(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('Aucun CV trouvé'));
                }

                final cv = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (cv.photoUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            cv.photoUrl,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error,
                                  size: 100, color: Colors.red);
                            },
                          ),
                        )
                      else
                        const CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.grey,
                          child:
                              Icon(Icons.person, size: 80, color: Colors.white),
                        ),
                      const SizedBox(height: 20),
                      Text('${cv.prenom} ${cv.nom}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(cv.email),
                      Text(cv.telephone),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => generateCVPdf(cv),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Exporter en PDF',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
