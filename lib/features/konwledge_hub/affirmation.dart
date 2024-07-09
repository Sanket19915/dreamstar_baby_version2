import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AffirmationScreen extends StatefulWidget {
  final String pdfPath1;

  AffirmationScreen({required this.pdfPath1});

  @override
  _AffirmationScreenState createState() => _AffirmationScreenState();
}

class _AffirmationScreenState extends State<AffirmationScreen> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  late PDFViewController _pdfViewController;

  TextEditingController _pageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        excludeHeaderSemantics: true,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: PDFView(
              fitEachPage: true,
              fitPolicy: FitPolicy.BOTH,
              filePath: widget.pdfPath1,
              autoSpacing: false,
              enableSwipe: false,
              pageSnap: false,
              swipeHorizontal: true,
              onRender: (_pages) {
                setState(() {
                  _totalPages = _pages!;
                  pdfReady = true;
                });
              },
              onViewCreated: (PDFViewController vc) {
                _pdfViewController = vc;
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  _currentPage = page!;
                });
              },
            ),
          ),
          if (!pdfReady) Center(child: CircularProgressIndicator())
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[200],
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                if (_currentPage > 0) {
                  _currentPage -= 1;
                  _pdfViewController.setPage(_currentPage);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(.7),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            Text('Page ${_currentPage + 1} / $_totalPages'),
            GestureDetector(
              onTap: () {
                if (_currentPage < _totalPages - 1) {
                  _currentPage += 1;
                  _pdfViewController.setPage(_currentPage);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(.7),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: Container(
      //   width: 130,
      //   decoration: BoxDecoration(
      //       borderRadius: BorderRadius.all(Radius.circular(12)),
      //       border: Border.all(color: Colors.red)),
      //   child: TextField(
      //     controller: _pageController,
      //     keyboardType: TextInputType.number,
      //     textAlign: TextAlign.center,
      //     decoration: InputDecoration(
      //       hintText: 'Go to Week',
      //       hintStyle: TextStyle(
      //           color: AppColors.mainColor,
      //           fontWeight: FontWeight.w700,
      //           fontSize: 16),
      //       contentPadding: EdgeInsets.symmetric(horizontal: 5),
      //       border: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(10),
      //       ),
      //     ),
      //     onSubmitted: (value) {
      //       int page = int.tryParse(value) ?? 0;
      //       if (page > 0 && page <= _totalPages) {
      //         _currentPage = page - 1;
      //         _pdfViewController.setPage(_currentPage);
      //       } else {
      //         // Handle invalid page number input
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           SnackBar(
      //             content: Text('Invalid page number'),
      //             duration: Duration(seconds: 2),
      //           ),
      //         );
      //       }
      //       _pageController.clear();
      //     },
      //   ),
      // ),
    );
  }
}
