import 'dart:io';

import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/network/api_client.dart';
import 'package:dream_baby/features/konwledge_hub/pdf_reader.dart';
import 'package:dream_baby/models/knowledge_entry_model.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/auth_services.dart';

class KnowEntry extends StatefulWidget {
  const KnowEntry({super.key});

  @override
  State<KnowEntry> createState() => _KnowEntryState();
}

class _KnowEntryState extends State<KnowEntry> {
  String? week;
  List<KnowledgeEntryModel> knowEntry = [];
  bool isLoading = true;
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
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.blackColor,
            size: 22,
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
      body: isLoading
          ? const Center(
              child: SpinKitCircle(
                color: AppColors.primaryColor,
                size: 50,
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: AppColors.mainColor),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => showHtmlDialog(context),
                          child: Text(
                            'Important Notes for all these Sections',
                            style: GoogleFonts.poppins(
                              color: AppColors.mainColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    LayoutBuilder(
                      builder: (layoutContext, constraints) {
                        final isTablet = constraints.maxWidth > 450;
                        return Column(
                          children: List.generate(
                            knowEntry.length,
                            (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: InkWell(
                                  onTap: () async {
                                    try {
                                      if (knowEntry[index]
                                              .filePath
                                              ?.contains('.pdf') ??
                                          false) {
                                        setState(() => isLoading = true);
                                        final pdfPath =
                                            await _loadPdfFromNetwork(
                                          knowEntry[index].filePath,
                                        );
                                        if (!mounted) return;
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                PDFViewerScreen(
                                              pdfPath: pdfPath,
                                              week: week,
                                            ),
                                          ),
                                        );
                                        if (mounted) {
                                          setState(() => isLoading = false);
                                        }
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        setState(() => isLoading = false);
                                      }
                                      Fluttertoast.showToast(msg: e.toString());
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      ApiConfig.storageUrl(
                                        knowEntry[index].backgroundImage,
                                      ),
                                      height: isTablet ? 250 : height * 0.13,
                                      width: width,
                                      fit: BoxFit.cover,
                                      errorBuilder: (errContext, error, stackTrace) {
                                        return Container(
                                          height: isTablet ? 250 : height * 0.13,
                                          width: width,
                                          color: Colors.grey.shade300,
                                          child: const Center(
                                            child: Icon(Icons.image_not_supported, color: Colors.grey),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void showHtmlDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("References",
                            style: GoogleFonts.poppins(
                                color: AppColors.mainColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                      Html(
                          data: '''
            <p>
              Information and content in this app is based on the bestselling book by Dr. Sonal Jayaswal and scientific research sources cited below:
            </p>

            <p>
              We strongly recommend that our users seek a doctor's advice in addition to using this app and before making any medical decisions.
            </p>

            <h3>References:</h3>
            <ol>
              <li>
                Ustun et al. (2022). 
                <a href="https://doi.org/10.1177/09567976221105460">Link</a>
              </li>
              <li>
                Varendi et al. (1994). 
                <a href="https://doi.org/10.1016/s0140-6736(94)91645-4">Link</a>
              </li>
              <li>
                Ackerman S. 
                <a href="https://www.ncbi.nlm.nih.gov/books/NBK234146/">Link</a>
              </li>
              <li>
                <a href="https://www.happiestbaby.com/blogs/pregnancy/baby-see-and-hear-inside-the-womb">Happiest Baby Article</a>
              </li>
              <li>
                Fleming, A. (2014). 
                <a href="https://www.theguardian.com/lifeandstyle/wordofmouth/2014/apr/08/child-food-preferences-womb-pregnancy-foetus-taste-flavours">Guardian Article</a>
              </li>
              <li>
                <a href="https://www.amazon.in/dp/9361561375">Garbh Sanskar Book</a>
              </li>
            </ol>
          ''',
                          onAnchorTap: (url, attributes, element) async {
                            if (url != null &&
                                await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url),
                                  mode: LaunchMode.externalApplication);
                            }
                          }),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close",
                                style: TextStyle(color: AppColors.mainColor))),
                      )
                    ],
                  )),
            ));
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
          await http.get(Uri.parse(ApiConfig.storageUrl(filePath)));
      if (data.statusCode != 200) {
        throw Exception("Failed to load PDF (HTTP ${data.statusCode})");
      }
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      String? newFileName = filePath?.split("/").last;
      File file = File("${dir.path}/$newFileName");
      print(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile.path;
    } catch (e) {
      throw Exception("Error opening url file: $e");
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
    if (!await AuthService.hasSession()) return;

    try {
      setState(() => isLoading = true);
      final body = await ApiClient.get(ApiConfig.staticData, authenticated: true);
      final rawList = body['data'] is List
          ? body['data'] as List
          : (body.values.whereType<List>().isNotEmpty
              ? body.values.whereType<List>().first
              : <dynamic>[]);
      knowEntry = rawList
          .map((item) =>
              KnowledgeEntryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
