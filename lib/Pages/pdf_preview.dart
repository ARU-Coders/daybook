import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
// import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String path;

  PdfPreviewScreen({@required this.path});

  @override
  Widget build(BuildContext context) {
    return
        // SafeArea(
        //     child: Column(children: [
        // Text("Ye dekho pdf"),
        // //
        // Container(
        //   height: 300.0,
        //   child: PdfView(
        //     path: path,
        //   ),
        // ),
        PDFViewerScaffold(
      path: path,
    )
        // ,
        // ]))
        ;
  }
}
