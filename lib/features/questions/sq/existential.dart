import 'dart:convert';

import 'package:dream_baby/models/options_model.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../models/questions_model.dart';
import '../../../services/auth_services.dart';

class ExistentialScreen extends StatefulWidget {
  final String from;
  const ExistentialScreen({super.key, required this.from});

  @override
  State<ExistentialScreen> createState() => _ExistentialScreenState();
}

class _ExistentialScreenState extends State<ExistentialScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarTransparent = true;
  bool isQuestionExpanded = false;
  late VideoPlayerController _controller;
  int? selectedOptionIndex;
  bool isLoading = false;
  QuestionsModel? questionsModel;
  PageController controller = PageController();
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    getQuestions();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 0) {
        setState(() {
          _isAppBarTransparent = false;
        });
      } else {
        setState(() {
          _isAppBarTransparent = true;
        });
      }
    });

    _controller = VideoPlayerController.network(
        'https://www.w3schools.com/html/mov_bbb.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _selectOption(int index) async {
    setState(() {
      selectedOptionIndex = index;
    });
    Vibration.vibrate(
      pattern: [500],
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double devicewidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            _isAppBarTransparent ? Colors.transparent : AppColors.whiteColor,
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
            size: 24,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Brain Development Activity',
          style: GoogleFonts.poppins(
            color: AppColors.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.from == "Existential"
                      ? AppImages.sq
                      : widget.from == "Kinesthetic"
                          ? "assets/images/KINESTHETIC.webp"
                          : widget.from == "Interpersonal"
                              ? "assets/images/INTERPERSONAL.webp"
                              : widget.from == "Intrapersonal"
                                  ? "assets/images/INTRAPERSONAL.webp"
                                  : widget.from == "Naturalistic"
                                      ? "assets/images/NATURALISTIC.webp"
                                      : widget.from == "Logical"
                                          ? "assets/images/LOGICAL.webp"
                                          : widget.from == "Linguistic"
                                              ? "assets/images/LINHUISTIC.webp"
                                              : widget.from == "Spatial Visual"
                                                  ? "assets/images/SPATIALVISUAL.webp"
                                                  : widget.from == "Musical"
                                                      ? "assets/images/MUSICAL.webp"
                                                      : AppImages.sq),
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.6),
                    BlendMode.srcATop,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: (questionsModel?.questions?.data.isEmpty ?? true)
                  ? Column(
                      children: [
                        const SizedBox(height: 120),
                        Container(
                          height: deviceheight * 0.173,
                          width: devicewidth,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(widget.from == "Existential"
                                  ? AppImages.existential
                                  : widget.from == "Kinesthetic"
                                      ? "assets/images/kinestetic.png"
                                      : widget.from == "Interpersonal"
                                          ? "assets/images/interpersonal.png"
                                          : widget.from == "Intrapersonal"
                                              ? "assets/images/intrapersonal.png"
                                              : widget.from == "Naturalistic"
                                                  ? "assets/images/naturalistic.png"
                                                  : widget.from == "Logical"
                                                      ? "assets/images/logical.png"
                                                      : widget.from ==
                                                              "Linguistic"
                                                          ? "assets/images/linguistic.png"
                                                          : widget.from ==
                                                                  "Spatial Visual"
                                                              ? "assets/images/spatialvisual.png"
                                                              : widget.from ==
                                                                      "Musical"
                                                                  ? "assets/images/musical.png"
                                                                  : AppImages
                                                                      .existential),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text("Opps, No Activity Found"),
                        )
                      ],
                    )
                  : PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: questionsModel?.questions?.data.length ?? 0,
                      controller: controller,
                      onPageChanged: (page) {
                        setState(() {
                          _selectedIndex = page;
                          selectedOptionIndex = null;
                        });
                      },
                      itemBuilder: (context, position) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 120),
                              Container(
                                height: deviceheight * 0.173,
                                width: devicewidth,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(widget.from ==
                                            "Existential"
                                        ? AppImages.existential
                                        : widget.from == "Kinesthetic"
                                            ? "assets/images/kinestetic.png"
                                            : widget.from == "Interpersonal"
                                                ? "assets/images/interpersonal.png"
                                                : widget.from == "Intrapersonal"
                                                    ? "assets/images/intrapersonal.png"
                                                    : widget.from ==
                                                            "Naturalistic"
                                                        ? "assets/images/naturalistic.png"
                                                        : widget.from ==
                                                                "Logical"
                                                            ? "assets/images/logical.png"
                                                            : widget.from ==
                                                                    "Linguistic"
                                                                ? "assets/images/linguistic.png"
                                                                : widget.from ==
                                                                        "Spatial Visual"
                                                                    ? "assets/images/spatialvisual.png"
                                                                    : widget.from ==
                                                                            "Musical"
                                                                        ? "assets/images/musical.png"
                                                                        : AppImages
                                                                            .existential),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildPageView(
                                  questionsModel?.questions?.data[position],
                                  devicewidth,
                                  questionsModel
                                          ?.questions?.data[position].options
                                          .where((e) => e.image.isNotEmpty)
                                          .toList() ??
                                      []),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        elevation:
                                            const WidgetStatePropertyAll(0),
                                        backgroundColor: WidgetStatePropertyAll(
                                            const Color(0xFFC4C8D0)
                                                .withOpacity(0.5)),
                                      ),
                                      onPressed: () {
                                        skipQuestions(questionsModel?.questions
                                                ?.data[_selectedIndex].id
                                                .toString() ??
                                            "");
                                        if (questionsModel
                                                ?.questions?.data.length ==
                                            (_selectedIndex + 1)) {
                                          Navigator.of(context).pop();
                                        } else {
                                          controller.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.linear);
                                        }
                                      },
                                      child: const Text(
                                        'Skip',
                                        style: TextStyle(
                                            color: Color(0xFF200F31),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        elevation:
                                            const WidgetStatePropertyAll(0),
                                        backgroundColor: WidgetStatePropertyAll(
                                            const Color(0xFFC4C8D0)
                                                .withOpacity(0.5)),
                                      ),
                                      onPressed: () {
                                        flagQuestions(questionsModel?.questions
                                                ?.data[_selectedIndex].id
                                                .toString() ??
                                            "");
                                        if (questionsModel
                                                ?.questions?.data.length ==
                                            (_selectedIndex + 1)) {
                                          Navigator.of(context).pop();
                                        } else {
                                          controller.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.linear);
                                        }
                                      },
                                      child: const Text(
                                        'Flag',
                                        style: TextStyle(
                                            color: Color(0xFF200F31),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                    elevation: WidgetStatePropertyAll(0),
                                    backgroundColor: WidgetStatePropertyAll(
                                        Color(0xFFE71C65)),
                                  ),
                                  onPressed: () {
                                    submitQuestions(
                                        questionsModel?.questions
                                                ?.data[_selectedIndex].id
                                                .toString() ??
                                            "",
                                        questionsModel
                                                ?.questions
                                                ?.data[_selectedIndex]
                                                .options[
                                                    selectedOptionIndex ?? 0]
                                                .text ??
                                            "");
                                    if (questionsModel
                                            ?.questions?.data.length ==
                                        (_selectedIndex + 1)) {
                                      Navigator.of(context).pop();
                                    } else {
                                      controller.nextPage(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.linear);
                                    }
                                  },
                                  child: const Text(
                                    'SUBMIT',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    elevation: const WidgetStatePropertyAll(0),
                                    backgroundColor: WidgetStatePropertyAll(
                                        const Color(0xFFC4C8D0)
                                            .withOpacity(0.5)),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Answer key',
                                    style: TextStyle(
                                        color: Color(0xFF200F31),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      }),
            ),
    );
  }

  Widget _buildPageView(
      Datum? data, double devicewidth, List<OptionsModel> options) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                data?.isPurposeExpanded = !(data.isPurposeExpanded ?? false);
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data?.quotient ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ),
                Icon(
                  data?.isPurposeExpanded ?? false
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.blackColor,
                ),
              ],
            ),
          ),
          if (data?.isPurposeExpanded ?? false)
            Column(
              children: [
                // Question text and description..
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    data?.questionText ?? "",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  data?.questionDescription ?? "",
                  maxLines: isQuestionExpanded ? null : 4,
                  overflow: isQuestionExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor,
                  ),
                ),
                (data?.questionDescription.isEmpty ?? true)
                    ? Container()
                    : InkWell(
                        onTap: () {
                          setState(() {
                            isQuestionExpanded = !isQuestionExpanded;
                          });
                        },
                        child: Text(
                          isQuestionExpanded ? 'Read less' : 'Read more',
                          style: const TextStyle(
                            color: Color(0xffE71C65),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                (data?.mainImage.isEmpty ?? true)
                    ? Container()
                    : Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          image: DecorationImage(
                            image: NetworkImage(
                                ("http://dreambaby.pro/storage/${data?.mainImage ?? ""}")),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          (data?.mainVideo?.isEmpty ?? true)
              ? Container()
              : SizedBox(
                  height: 200,
                  width: devicewidth,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                          : const Center(child: CircularProgressIndicator()),
                      IconButton(
                        iconSize: 64,
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                      ),
                    ],
                  ),
                ),
          (data?.youtubeLink.isEmpty ?? true)
              ? Container()
              : SizedBox(
                  height: 200,
                  child: YouTubeWebView(
                    view: data?.youtubeLink ?? "",
                  ),
                ),
          const SizedBox(height: 20),
          data?.options.isEmpty ?? true
              ? Container()
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Answer Options:',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
          for (int i = 0; i < (data?.options.length ?? 0); i++)
            GestureDetector(
              onTap: () => _selectOption(i),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: selectedOptionIndex == i
                        ? Colors.blue
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${i + 1}. ${data?.options[i].text}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selectedOptionIndex == i
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          options.isEmpty
              ? Container()
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _selectOption(index),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selectedOptionIndex == index
                              ? Colors.blue
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(options[index].image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${index + 1}. ${options[index].text}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: selectedOptionIndex == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> getQuestions() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      var token = await AuthService.getToken();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request =
          http.Request('GET', Uri.parse('http://dreambaby.pro/api/questions'));
      request.body = json.encode({
        "quotient": widget.from == "Kinesthetic"
            ? "Physical"
            : widget.from == "Interpersonal"
                ? "Emotional"
                : widget.from == "Intrapersonal"
                    ? "Emotional"
                    : widget.from == "Naturalistic"
                        ? "Emotional"
                        : widget.from == "Logical"
                            ? "Intellectual"
                            : widget.from == "Linguistic"
                                ? "Intellectual"
                                : widget.from == "Spatial Visual"
                                    ? "Intellectual"
                                    : widget.from == "Musical"
                                        ? "Intellectual"
                                        : "Spirutal",
        "intelligence_type": "",
        "question_type": "",
        "week": 1,
        "day": 1
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();

        questionsModel = questionsModelFromJson(responseData);

        print(questionsModel);
      } else {
        print(response.reasonPhrase);
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> flagQuestions(String questionId) async {
    try {
      // if (mounted) {
      //   setState(() {
      //     isLoading = true;
      //   });
      // }
      var token = await AuthService.getToken();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://dreambaby.pro/api/flag-question'));
      request.fields.addAll({'question_id': questionId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(questionsModel);
      } else {
        print(response.reasonPhrase);
      }
      // if (mounted) {
      //   setState(() {
      //     isLoading = false;
      //   });
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

      // if (mounted) {
      //   setState(() {
      //     isLoading = false;
      //   });
      // }
    }
  }

  Future<void> skipQuestions(String questionId) async {
    try {
      // if (mounted) {
      //   setState(() {
      //     isLoading = true;
      //   });
      // }
      var token = await AuthService.getToken();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://dreambaby.pro/api/skip-question'));
      request.fields.addAll({'question_id': questionId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(questionsModel);
      } else {
        print(response.reasonPhrase);
      }
      // if (mounted) {
      //   setState(() {
      //     isLoading = false;
      //   });
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

      // if (mounted) {
      //   setState(() {
      //     isLoading = false;
      //   });
      // }
    }
  }

  Future<void> submitQuestions(String questionId, String answer) async {
    try {
      // if (mounted) {
      //   setState(() {
      //     isLoading = true;
      //   });
      // }
      var token = await AuthService.getToken();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://dreambaby.pro/api/user_answer'));
      request.fields.addAll({
        'question_id': questionId,
        "answer": answer,
        "is_flagged": '0',
        "is_skipped": '0'
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(questionsModel);
      } else {
        print(response.reasonPhrase);
      }
      // if (mounted) {
      //   setState(() {
      //     isLoading = false;
      //   });
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

      // if (mounted) {
      //   setState(() {
      //     isLoading = false;
      //   });
      // }
    }
  }
}

class YouTubeWebView extends StatefulWidget {
  final String view;
  const YouTubeWebView({super.key, required this.view});

  @override
  _YouTubeWebViewState createState() => _YouTubeWebViewState();
}

class _YouTubeWebViewState extends State<YouTubeWebView> {
  late final WebViewController _controller;

//   @override
//   void initState() {
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }

//     final WebViewController pgcontroller =
//         WebViewController.fromPlatformCreationParams(params);
//     // #enddocregion platform_features

//     pgcontroller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             debugPrint('WebView is loading (progress : $progress%)');
//           },
//           onPageStarted: (String url) {
//             debugPrint('Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             debugPrint('Page finished loading: $url');
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint('''
// Page resource error:
//   code: ${error.errorCode}
//   description: ${error.description}
//   errorType: ${error.errorType}
//   isForMainFrame: ${error.isForMainFrame}
//           ''');
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               debugPrint('blocking navigation to ${request.url}');
//               return NavigationDecision.prevent;
//             }
//             debugPrint('allowing navigation to ${request.url}');
//             return NavigationDecision.navigate;
//           },
//           onHttpError: (HttpResponseError error) {
//             debugPrint('Error occurred on page: ${error.response?.statusCode}');
//           },
//           onUrlChange: (UrlChange change) {
//             debugPrint('url change to ${change.url}');
//           },
//           onHttpAuthRequest: (HttpAuthRequest request) {},
//         ),
//       )
//       ..addJavaScriptChannel(
//         'Toaster',
//         onMessageReceived: (JavaScriptMessage message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         },
//       )
//       ..loadHtmlString(widget.view);

//     // #docregion platform_features
//     if (pgcontroller.platform is AndroidWebViewController) {
//       AndroidWebViewController.enableDebugging(true);
//       (pgcontroller.platform as AndroidWebViewController)
//           .setMediaPlaybackRequiresUserGesture(false);
//     }
//     _controller = pgcontroller;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('YouTube Video'),
//       ),
//       body: WebViewWidget(
//         controller: _controller,
//       ),
//     );
//   }

  String extractYouTubeVideoId(String iframe) {
    // Regular expression to find the src attribute and extract the video ID
    final idRegExp =
        RegExp(r'src="https:\/\/www\.youtube\.com\/embed\/([^"?]+)');
    final match = idRegExp.firstMatch(iframe);

    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? '';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: extractYouTubeVideoId(widget.view),
      ),
    );
  }
}
