import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cv_model.dart';

class FirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveCV(String uid, CvModel cv) async {
    await users.doc(uid).set(cv.toMap());
  }

  Future<CvModel> getCV(String uid) async {
    DocumentSnapshot doc = await users.doc(uid).get();
    return CvModel.fromMap(doc.data() as Map<String, dynamic>);
  }
}

// import '../models/cv_model.dart';

// class FirestoreService {
//   Future<void> saveCV(String uid, CvModel cv) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//   }

//   Future<CvModel> getCV(String uid) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     return CvModel(
//       prenom: "Jean",
//       nom: "Dupont",
//       email: "jean.dupont@email.com",
//       telephone: "+237 600 00 00 00",
//       formations: [
//         {'diplome': 'Master Informatique', 'annee': '2022'}
//       ],
//       experiences: [
//         {'poste': 'Développeur Mobile', 'entreprise': 'StartupX'}
//       ],
//       competences: ['Flutter', 'Firebase', 'UI/UX'],
//       photoUrl: '',
//     );
//   }
// }
