import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  final String pdfPath; // Path to your PDF file

  TermsAndConditionsScreen({required this.pdfPath});

  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool pdfReady = false;
  PDFViewController? _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
          style: TextStyle(
              color: AppColors.mainColor, fontWeight: FontWeight.w600),
        ),
      ),
      body: PDFView(
        fitPolicy: FitPolicy.BOTH,
        fitEachPage: true,
        filePath: widget.pdfPath,
        autoSpacing: true,
        pageFling: false,
        onRender: (_pages) {
          setState(() {
            pdfReady = true;
          });
        },
        onViewCreated: (PDFViewController vc) {
          _pdfViewController = vc;
        },
      ),
    );
  }
}
