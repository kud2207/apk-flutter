import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/cv_model.dart';

Future<void> generateCVPdf(CvModel cv) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text("${cv.prenom} ${cv.nom}",
              style: const pw.TextStyle(fontSize: 24)),
          pw.Text(cv.email),
          pw.Text(cv.telephone),
          pw.SizedBox(height: 20),
          pw.Text("Formations:", style: const pw.TextStyle(fontSize: 18)),
          ...cv.formations.map((formation) =>
              pw.Text("- ${formation['diplome']} (${formation['annee']})")),
          pw.SizedBox(height: 10),
          pw.Text("Expériences:", style: const pw.TextStyle(fontSize: 18)),
          ...cv.experiences.map(
              (exp) => pw.Text("- ${exp['poste']} chez ${exp['entreprise']}")),
          pw.SizedBox(height: 10),
          pw.Text("Compétences:", style: const pw.TextStyle(fontSize: 18)),
          ...cv.competences.map((comp) => pw.Text("- $comp")),
        ],
      ),
    ),
  );

  await Printing.layoutPdf(onLayout: (format) => pdf.save());
}
