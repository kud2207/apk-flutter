class CvModel {
  final String prenom;
  final String nom;
  final String email;
  final String telephone;
  final List<Map<String, dynamic>> formations;
  final List<Map<String, dynamic>> experiences;
  final List<String> competences;
  final String photoUrl;

  CvModel({
    required this.prenom,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.formations,
    required this.experiences,
    required this.competences,
    required this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'prenom': prenom,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'formations': formations,
      'experiences': experiences,
      'competences': competences,
      'photoUrl': photoUrl,
    };
  }

  factory CvModel.fromMap(Map<String, dynamic> map) {
    return CvModel(
      prenom: map['prenom'] ?? '',
      nom: map['nom'] ?? '',
      email: map['email'] ?? '',
      telephone: map['telephone'] ?? '',
      formations: List<Map<String, dynamic>>.from(map['formations'] ?? []),
      experiences: List<Map<String, dynamic>>.from(map['experiences'] ?? []),
      competences: List<String>.from(map['competences'] ?? []),
      photoUrl: map['photoUrl'] ?? '',
    );
  }
}