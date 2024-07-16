import 'dart:io';

import 'package:dream_baby/features/konwledge_hub/pdf_reader.dart';
import 'package:dream_baby/models/knowledge_entry_model.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../services/auth_services.dart';

class KnowEntry extends StatefulWidget {
  const KnowEntry({super.key});

  @override
  State<KnowEntry> createState() => _KnowEntryState();
}

class _KnowEntryState extends State<KnowEntry> {
  String? week;
  List<KnowledgeEntryModel> knowEntry = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKnowledge();
  }

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
        child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: isLoading
                  ? Container(
                      height: height,
                      child: Center(
                        child: SpinKitCircle(
                          color: AppColors.primaryColor,
                          size: 50.0,
                        ),
                      ),
                    )
                  : Column(
                      children: List.generate(
                        knowEntry.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: InkWell(
                              onTap: () async {
                                // if (knowEntry[index].filePath?.contains(".pdf") ??
                                //     false) {
                                //   var token = await AuthService.getToken();
                                //   var url = Uri.parse(
                                //       'http://dreambaby.pro/api/baby_data?week=1&day=1');
                                //   var headers = {
                                //     'Content-Type': 'application/json',
                                //     'Authorization': 'Bearer $token',
                                //     'Cookie':
                                //         'XSRF-TOKEN=your-token; laravel_session=your-session'
                                //   };

                                //   try {
                                //     var response =
                                //         await http.get(url, headers: headers);

                                //     if (response.statusCode == 200) {
                                //       var contentType =
                                //           response.headers['content-type'];
                                //       if (contentType != null &&
                                //           contentType
                                //               .contains('application/json')) {
                                //         var data = json.decode(response.body);

                                //         setState(() {
                                //           week = data[0]['week']?.toString() ?? '0';
                                //         });
                                //       } else {
                                //          setState(() {
                                //           isLoading = false;
                                //         });
                                //         throw Exception(
                                //             'Unexpected response format');
                                //       }
                                //     } else {
                                //         setState(() {
                                //         isLoading = false;
                                //       });
                                //       throw Exception(
                                //           'Failed to fetch baby data: ${response.reasonPhrase}');
                                //     }
                                //   } catch (e) {
                                //       setState(() {
                                //       isLoading = false;
                                //     });
                                //     print('Error fetching baby data: $e');
                                //     throw Exception('Error fetching baby data: $e');
                                //   }
                                if (knowEntry[index]
                                        .filePath
                                        ?.contains(".pdf") ??
                                    false) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  String pdfPath = await _loadPdfFromNetwork(
                                      knowEntry[index].filePath);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PDFViewerScreen(
                                          pdfPath: pdfPath, week: week),
                                    ),
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                }

                                // }
                              },
                              child: Container(
                                height: height * 0.13,
                                width: width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "http://dreambaby.pro/storage/${knowEntry[index].backgroundImage}"),
                                      fit: BoxFit.cover),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )),
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

  Future<String> _loadPdfFromNetwork([String? filePath]) async {
    if (filePath?.isEmpty ?? true) {
      Fluttertoast.showToast(msg: 'File is Empty');
    }
    try {
      var data =
          await http.get(Uri.parse("http://dreambaby.pro/storage/$filePath"));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/sample.pdf");
      print(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile.path;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  Future<String> _affirmationloadPdfFromAssets() async {
    final ByteData data = await rootBundle.load(
        'assets/pdf/Affirmations.pdf'); // Replace with your PDF asset path
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/sample.pdf');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    return tempFile.path;
  }

  Future<void> getKnowledge() async {
    try {
      setState(() {
        isLoading = true;
      });
      var token = await AuthService.getToken();
      var url = Uri.parse('http://dreambaby.pro/api/static_data');
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        knowEntry = knowledgeEntryModelFromJson(response.body);
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
}
