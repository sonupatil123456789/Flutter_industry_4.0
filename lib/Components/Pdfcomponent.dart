// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';

// Future creatpdffile() async {
//   final pdf = pw.Document();

//   pdf.addPage(pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Text(
//           "Shreyas shashikant patil",
//         );
//       })); //

//   final output = await getTemporaryDirectory();
//   final file = File("${output.path}/example.pdf");
//   await file.writeAsBytes(await pdf.save());
// }
