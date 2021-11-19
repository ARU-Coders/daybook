import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

Future<File> generatePDF(DocumentSnapshot doc) async {
  final pdf = pw.Document();
  final fontData = await rootBundle.load('assets/fonts/OpenSans-Regular.ttf');
  final ttf = pw.Font.ttf(fontData);
  List<dynamic> imageUrls = doc["images"];
  List images = [];
  for (int i = 0; i < imageUrls.length; i++) {
    print("Fetching Image ${i + 1}/${imageUrls.length}...");
    var response = await http.get(Uri.parse(imageUrls[i]));
    var data = response.bodyBytes;
    images.add(pw.MemoryImage(data));
  }
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
          pw.Text(doc['title'], style: pw.TextStyle(fontSize: 20, font: ttf)),
          pw.Text(doc['address'], style: pw.TextStyle(fontSize: 14, font: ttf)),
          pw.Text(
            DateFormat.yMMMMd().format(DateTime.parse(doc['dateCreated'])),
            style: pw.TextStyle(fontSize: 14, font: ttf),
          ),
          pw.SizedBox(height: 20),
          pw.Text(doc['content'].toString(),
              style: pw.TextStyle(fontSize: 12, font: ttf)),
          pw.SizedBox(height: 20),
          pw.Wrap(
            spacing: 3,
            runSpacing: 1,
            children: List.generate(doc['tags'].length, (index) {
              return pw.Column(
                children: <pw.Widget>[
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(5),
                      color: PdfColors.amber,
                    ),
                    margin: pw.EdgeInsets.all(1.0),
                    padding: pw.EdgeInsets.all(4.0),
                    child: pw.Text("${doc['tags'][index]}",
                        style: pw.TextStyle(fontSize: 8)),
                  ),
                ],
              );
            }),
          ),
          pw.SizedBox(height: 20),
          images.length > 0
              ? pw.Wrap(
                  spacing: 3,
                  runSpacing: 1,
                  children: List.generate(images.length, (index) {
                    return pw.Column(
                      children: <pw.Widget>[
                        pw.Container(
                            margin: pw.EdgeInsets.all(1.0),
                            padding: pw.EdgeInsets.all(4.0),
                            child: pw.Image(images[index], height: 120)),
                      ],
                    );
                  }),
                )
              : pw.SizedBox(height: 10)
        ]),
      ],
    ),
  );

  final output2 = (await getExternalStorageDirectory()).path;
  String pdfName = doc['title'] + "_" + doc['dateCreated'].toString();
  File file = File('$output2/$pdfName.pdf');
  final doesExist = await file.exists();

  if (!doesExist) {
    file = await file.create();
  } else {
    pdfName = doc['title'] + "_" + DateTime.now().toString();
  }
  print("PdfName = $pdfName");
  await file.writeAsBytes(await pdf.save());
  return file;
}
