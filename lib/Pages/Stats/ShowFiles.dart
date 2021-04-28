import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class ShowFiles extends StatelessWidget {
  @required
  final files;

  ShowFiles({this.files});

  bool checkIfSameDates(files, index) {
    DateTime currDate = files[index].lastModifiedSync();
    DateTime prevDate = files[index - 1].lastModifiedSync();
    print(currDate);

    return currDate.year == prevDate.year &&
        currDate.month == prevDate.month &&
        currDate.day == prevDate.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('PDF Files'),
      ),
      body: SafeArea(
        child: files.length <= 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/No-Entry.png',
                      height: 250.0,
                    ),
                    Text(
                      "No PDFs Added",
                      style: GoogleFonts.getFont(
                        'Lato',
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: files?.length ?? 0,
                itemBuilder: (context, index) {
                  return index == 0
                      ? _pdfCardWithDate(files[index])
                      : checkIfSameDates(files, index)
                          ? _pdfCard(files[index])
                          : _pdfCardWithDate(files[index]);
                },
              ),
      ),
    );
  }

  Widget _pdfCardWithDate(file) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Divider(
              thickness: 2,
            )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: Text(
                DateFormat.yMMMMd().format(file.lastModifiedSync()),
                style: GoogleFonts.getFont('Oxygen',
                    fontSize: 13, color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Expanded(
                child: Divider(
              thickness: 2,
            )),
          ],
        ),
        _pdfCard(file),
      ],
    );
  }

  Widget _pdfCard(file) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Card(
          // padding: EdgeInsets.all(8),
          child: GestureDetector(
        onTap: () async {
          final _ = await OpenFile.open(file.path);
        },
        child: ListTile(
          title: Text(file.path.split('/').last),
          leading: Icon(Icons.picture_as_pdf_outlined),
        ),
      )),
    );
  }
}
