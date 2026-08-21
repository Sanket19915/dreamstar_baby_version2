import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';

class PDFViewerScreen extends StatefulWidget {
  final String pdfPath;
  final String? week;

  const PDFViewerScreen({super.key, required this.pdfPath, this.week});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  late PDFViewController _pdfViewController;
  final TextEditingController _pageController = TextEditingController();

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
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned.fill(
                  child: PDFView(
                    pageFling: true,
                    fitEachPage: false,
                    fitPolicy: FitPolicy.WIDTH,
                    filePath: widget.pdfPath,
                    autoSpacing: false,
                    enableSwipe: true,
                    pageSnap: true,
                    swipeHorizontal: true,
                    onRender: (pages) {
                      setState(() {
                        _totalPages = pages!;
                        pdfReady = true;
                        _pdfViewController.setPage(int.parse(widget.week ?? "1") - 1);
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
                    onLinkHandler: (String? uri) {
                      if (uri != null) {
                        _launchURL(uri);
                      }
                    },
                  ),
                ),
                if (!pdfReady) const Center(child: CircularProgressIndicator())
              ],
            );
          },
        ),
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
                  color: AppColors.mainColor.withValues(alpha: .7),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
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
                  color: AppColors.mainColor.withValues(alpha: .7),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.pdfPath.contains("TheNineMonthJourney_compressed")
          ? Container(
              width: 130,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)), border: Border.all(color: Colors.red)),
              child: TextField(
                controller: _pageController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Go to Week',
                  hintStyle: const TextStyle(color: AppColors.mainColor, fontWeight: FontWeight.w700, fontSize: 16),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onSubmitted: (value) {
                  int page = int.tryParse(value) ?? 0;
                  if (page > 0 && page <= _totalPages) {
                    _currentPage = page - 1;
                    _pdfViewController.setPage(_currentPage);
                  } else {
                    // Handle invalid page number input
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid page number'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                  _pageController.clear();
                },
              ),
            )
          : null,
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
