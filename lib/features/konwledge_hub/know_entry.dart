import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dream_baby/features/konwledge_hub/affirmation.dart';
import 'package:dream_baby/features/konwledge_hub/pdf_reader.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/auth_services.dart';

class KnowEntry extends StatefulWidget {
  const KnowEntry({super.key});

  @override
  State<KnowEntry> createState() => _KnowEntryState();
}

class _KnowEntryState extends State<KnowEntry> {
  String ?week;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
            size: 20,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Knowledge Hub',
          style: GoogleFonts.poppins(
            color: AppColors.mainColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  height: height * 0.13,
                  width: width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppImages.kn1), fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () async {
                  var token = await AuthService.getToken();
                  var url = Uri.parse(
                      'http://dreambaby.pro/api/baby_data?week=1&day=1');
                  var headers = {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer $token',
                    'Cookie':
                        'XSRF-TOKEN=your-token; laravel_session=your-session'
                  };

                  try {
                    var response = await http.get(url, headers: headers);

                    if (response.statusCode == 200) {
                      var contentType = response.headers['content-type'];
                      if (contentType != null &&
                          contentType.contains('application/json')) {
                        var data = json.decode(response.body);

                        setState(() {
                          week = data[0]['week']?.toString() ?? '0';
                        });
                      } else {
                        throw Exception('Unexpected response format');
                      }
                    } else {
                      throw Exception(
                          'Failed to fetch baby data: ${response.reasonPhrase}');
                    }
                  } catch (e) {
                    print('Error fetching baby data: $e');
                    throw Exception('Error fetching baby data: $e');
                  }

                  String pdfPath = await _loadPdfFromAssets();

                  // Navigate to the PDFViewerScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewerScreen(pdfPath: pdfPath ,week:  week),
                    ),
                  );
                },
                child: Container(
                  height: height * 0.13,
                  width: width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppImages.kn2),
                        fit: BoxFit.cover,
                        alignment: Alignment.center),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: height * 0.13,
                  width: width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppImages.kn3), fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: height * 0.13,
                  width: width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppImages.kn4), fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () async {
                  String pdfPath1 = await _affirmationloadPdfFromAssets();

                  // Navigate to the PDFViewerScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AffirmationScreen(pdfPath1: pdfPath1),
                    ),
                  );
                },
                child: Container(
                  height: height * 0.13,
                  width: width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppImages.kn5), fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: height * 0.13,
                  width: width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppImages.kn6), fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _loadPdfFromAssets() async {
    final ByteData data = await rootBundle.load(
        'assets/pdf/TheNineMonthJourney.pdf'); // Replace with your PDF asset path
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/sample.pdf');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    return tempFile.path;
  }

  Future<String> _affirmationloadPdfFromAssets() async {
    final ByteData data = await rootBundle.load(
        'assets/pdf/Affirmations.pdf'); // Replace with your PDF asset path
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/sample.pdf');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    return tempFile.path;
  }
}
