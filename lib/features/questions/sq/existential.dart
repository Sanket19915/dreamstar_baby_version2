// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dream_baby/features/questions/sq/video_player_screen.dart';
import 'package:dream_baby/models/options_model.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../models/questions_model.dart';
import '../../../services/auth_services.dart';

class ExistentialScreen extends StatefulWidget {
  final String from;
  final int index;
  final Function() onExit;
  Map<String, bool> quotientStatuses;
  ExistentialScreen(
      {super.key,
      required this.from,
      required this.index,
      required this.onExit,
      required this.quotientStatuses});

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

  bool? isCorrect;
  bool isDisable = false;
  ValueNotifier answerNotifier = ValueNotifier(true);
  String todayQuestionStatus = "";
  List<String> quotients = [
    "Kinesthetic",
    "Logical",
    "Linguistic",
    "Spatial Visual",
    "Musical",
    "Intrapersonal",
    "Naturalistic",
    "Interpersonal",
    "Existential",
  ];
  @override
  void initState() {
    super.initState();
    getQuestions();
    fetchQuestions();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 0) {
        if (mounted) {
          setState(() {
            _isAppBarTransparent = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isAppBarTransparent = true;
          });
        }
      }
    });

    _controller = VideoPlayerController.network(
        'https://www.w3schools.com/html/mov_bbb.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
            _isAppBarTransparent ? AppColors.whiteColor : AppColors.whiteColor,
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
                  fit: BoxFit.fill,
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
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                              "Congratulations! All activities to be taken up today for this intelligence have been completed."),
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
                      itemBuilder: (ctx, position) {
                        return SingleChildScrollView(
                            child: SafeArea(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
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
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ValueListenableBuilder(
                                  valueListenable: answerNotifier,
                                  builder: (context, value, child) {
                                    return _buildPageView(
                                        questionsModel
                                            ?.questions?.data[position],
                                        devicewidth,
                                        questionsModel?.questions
                                                ?.data[position].options
                                                .where(
                                                    (e) => e.image.isNotEmpty)
                                                .toList() ??
                                            []);
                                  }),
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
                                      onPressed: () async {
                                        skipQuestions(questionsModel?.questions
                                                ?.data[_selectedIndex].id
                                                .toString() ??
                                            "");
                                        if (questionsModel
                                                ?.questions?.data.length ==
                                            (_selectedIndex + 1)) {
                                          int nextIndex = widget.index;

                                          await getTodaysQuestionStatus(
                                              context, nextIndex);
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
                                      onPressed: () async {
                                        flagQuestions(questionsModel?.questions
                                                ?.data[_selectedIndex].id
                                                .toString() ??
                                            "");
                                        if (questionsModel
                                                ?.questions?.data.length ==
                                            (_selectedIndex + 1)) {
                                          int nextIndex = widget.index;

                                          await getTodaysQuestionStatus(
                                              context, nextIndex);
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
                                  onPressed: () async {
                                    await submitQuestions(
                                        ctx: context,
                                        data: questionsModel
                                            ?.questions?.data[position],
                                        questionId: questionsModel?.questions
                                                ?.data[_selectedIndex].id
                                                .toString() ??
                                            "",
                                        answer: (questionsModel
                                                    ?.questions
                                                    ?.data[_selectedIndex]
                                                    .options
                                                    .isEmpty ??
                                                true)
                                            ? ""
                                            : questionsModel
                                                    ?.questions
                                                    ?.data[_selectedIndex]
                                                    .options[
                                                        selectedOptionIndex ??
                                                            0]
                                                    .text ??
                                                "");

                                    if (questionsModel
                                            ?.questions?.data.length ==
                                        (_selectedIndex + 1)) {
                                      int nextIndex = widget.index;

                                      await getTodaysQuestionStatus(
                                          context, nextIndex);
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
                              // (questionsModel?.questions?.data[position]
                              //             .answerKeyInput.isNotEmpty ??
                              //         false)
                              //     ? SizedBox(
                              //         width: double.infinity,
                              //         child: ElevatedButton(
                              //           style: ButtonStyle(
                              //             backgroundColor:
                              //                 WidgetStatePropertyAll(
                              //                     const Color(0xFFC4C8D0)
                              //                         .withOpacity(0.5)),
                              //             elevation:
                              //                 const WidgetStatePropertyAll(0),
                              //           ),
                              //           onPressed: () {
                              //             showDialog(
                              //               barrierDismissible: false,
                              //               context: context,
                              //               builder: (context) {
                              //                 return AlertDialog(
                              //                   title: Text(
                              //                     'Answer key : ${questionsModel?.questions?.data[position].answerKeyInput}',
                              //                     style: const TextStyle(
                              //                         color: Color(0xFF200F31),
                              //                         fontWeight:
                              //                             FontWeight.w500,
                              //                         fontSize: 16),
                              //                   ),
                              //                   actions: [
                              //                     ElevatedButton(
                              //                         onPressed: () {
                              //                           print("pop 2");
                              //                           Navigator.of(context)
                              //                               .pop();
                              //                         },
                              //                         child: const Text(
                              //                           'Okay',
                              //                           style: TextStyle(
                              //                               color: Color(
                              //                                   0xFF200F31),
                              //                               fontWeight:
                              //                                   FontWeight
                              //                                       .w500),
                              //                         ))
                              //                   ],
                              //                 );
                              //               },
                              //             );
                              //           },
                              //           child: const Text(
                              //             'Answer key',
                              //             style: TextStyle(
                              //                 color: Color(0xFF200F31),
                              //                 fontWeight: FontWeight.w500),
                              //           ),
                              //         ),
                              //       )
                              //     : const SizedBox(),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ));
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      //data?.quotient ?? "",
                      "Purpose",
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
                Container(
                  padding: EdgeInsets.only(
                      top: (data?.isPurposeExpanded ?? false) ? 10 : 0,
                      left: (data?.isPurposeExpanded ?? false) ? 10 : 0,
                      right: (data?.isPurposeExpanded ?? false) ? 10 : 0,
                      bottom: (data?.isPurposeExpanded ?? false) ? 5 : 0),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: ((data?.isPurposeExpanded ?? false) &&
                                  data?.questionDescription != "")
                              ? AppColors.greyTextColor
                              : Colors.transparent)),
                  child: Column(
                    children: [
                      if (data?.isPurposeExpanded ?? false)
                        Column(
                          children: [
                            // Question text and description..
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                data?.questionDescription ?? "",
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (data?.isPurposeExpanded == false)
            Container(
              height: 1,
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              // Question text and description..
              Text(
                //data?.quotient ?? "",
                "Acitivity:",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  data?.questionText ?? "",
                  textAlign: TextAlign.justify,
                  maxLines: isQuestionExpanded ? null : 5,
                  overflow: isQuestionExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              (data?.questionText.isEmpty ?? true)
                  ? Container()
                  : ((data?.questionText.length ?? 0) < 175)
                      ? Container()
                      : InkWell(
                          onTap: () {
                            setState(() {
                              isQuestionExpanded = !isQuestionExpanded;
                            });
                          },
                          child: Text(
                            textAlign: TextAlign.left,
                            isQuestionExpanded ? 'Read less' : 'Read more',
                            style: const TextStyle(
                              color: Color(0xffE71C65),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
              const SizedBox(height: 30),

              const SizedBox(height: 20),
              (data?.mainImage.isEmpty ?? true)
                  ? Container()
                  : Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        image: DecorationImage(
                          image: NetworkImage(
                              ("http://dreambaby.pro/storage/${data?.mainImage ?? ""}")),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
            ],
          ),
          (data?.mainVideo?.isEmpty ?? true)
              ? Container()
              : Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(0),
                      backgroundColor: WidgetStatePropertyAll(
                          const Color(0xFFC4C8D0).withOpacity(0.5)),
                    ),
                    onPressed: () {
                      _controller.dispose();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => VideoPlayerScreen(
                            youtubeLink: data?.youtubeLink ?? "",
                            isYoutube: (data?.youtubeLink.isEmpty ?? true)
                                ? false
                                : true,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Full Screen',
                      style: TextStyle(
                          color: Color(0xFF200F31),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
          const SizedBox(height: 5),
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
                  height: 250,
                  child: YouTubeWebView(
                    view: data?.youtubeLink ?? "",
                  ),
                ),
          const SizedBox(height: 20),
          if (data?.options.every(
                (element) =>
                    element.text.isNotEmpty || element.image.isNotEmpty,
              ) ??
              false)
            Align(
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
          ValueListenableBuilder(
            valueListenable: answerNotifier,
            builder: (ctx, value, child) {
              // Filter the options to get only those with images and no text
              var imageOnlyOptions = data?.options
                  .where((option) =>
                      option.image.isNotEmpty && option.text.isEmpty)
                  .toList();

              // If there are no options that match the criteria, return an empty container
              if (imageOnlyOptions == null || imageOnlyOptions.isEmpty) {
                return const SizedBox.shrink();
              }

              // Display the filtered options in a grid view
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5, // Adjust the aspect ratio as needed
                ),
                itemCount:
                    imageOnlyOptions.length, // Number of filtered options
                itemBuilder: (context, index) {
                  // Use the correct index from the filtered list
                  final option = imageOnlyOptions[index];

                  return GestureDetector(
                    onTap: () => isDisable ? null : _selectOption(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: selectedOptionIndex == index
                            ? ((selectedOptionIndex == index) &&
                                    (isCorrect != null) &&
                                    (isCorrect ?? false))
                                ? Colors.green
                                : ((selectedOptionIndex == index) &&
                                        ((isCorrect != null) &&
                                            !(isCorrect ?? false)))
                                    ? Colors.red
                                    : Colors.blue
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.network(
                        "http://dreambaby.pro/storage/${option.image}",
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          for (int i = 0; i < (data?.options.length ?? 0); i++)
            if ((data?.options[i].image.isEmpty ?? false) &&
                (data?.options[i].text.isNotEmpty ?? false))
              ValueListenableBuilder(
                  valueListenable: answerNotifier,
                  builder: (ctx, value, child) {
                    return GestureDetector(
                      onTap: () => isDisable ? null : _selectOption(i),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: selectedOptionIndex == i
                                ? ((selectedOptionIndex == i) &&
                                        (isCorrect != null) &&
                                        (isCorrect ?? false))
                                    ? Colors.green
                                    : ((selectedOptionIndex == i) &&
                                            ((isCorrect != null) &&
                                                !(isCorrect ?? false)))
                                        ? Colors.red
                                        : Colors.blue
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: (data?.options[i].image.isNotEmpty ?? false)
                              ? Image.network(
                                  "http://dreambaby.pro/storage/${data?.options[i].image}")
                              : Text(
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
                    );
                  }),
          options.every(
                  (element) => element.text.isEmpty || element.image.isEmpty)
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
                      onTap: () => isDisable ? null : _selectOption(index),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selectedOptionIndex == index
                              ? ((selectedOptionIndex == index) &&
                                      (isCorrect != null) &&
                                      (isCorrect ?? false))
                                  ? Colors.green
                                  : ((selectedOptionIndex == index) &&
                                          ((isCorrect != null) &&
                                              !(isCorrect ?? false)))
                                      ? Colors.red
                                      : Colors.blue
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
                                    image: NetworkImage(
                                        "http://dreambaby.pro/storage/${data?.options[index].image}"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(height: 8),
                            options[index].image.isNotEmpty &&
                                    options[index].text.isEmpty
                                ? Image.network(
                                    "http://dreambaby.pro/storage/${data?.options[index].image}",
                                    fit: BoxFit.contain,
                                  )
                                : Text(
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

  int totalQuestionsCount = 0; // Track total number of questions
  Future<void> fetchQuestions() async {
    try {
      if (mounted) {
        setState(() {
          isDisable = false;
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
        // "quotient": widget.from == "Kinesthetic"
        //     ? "Physical"
        //     : widget.from == "Interpersonal"
        //         ? "Emotional"
        //         : widget.from == "Intrapersonal"
        //             ? "Emotional"
        //             : widget.from == "Naturalistic"
        //                 ? "Emotional"
        //                 : widget.from == "Linguistic"
        //                     //: widget.from == "Logical"
        //                     ? "Intellectual"
        //                     : widget.from == "Spatial Visual"
        //                         //  : widget.from == ""
        //                         ? "Intellectual"
        //                         : widget.from == "Logical"
        //                             // : widget.from == "Logical"
        //                             ? "Intellectual"
        //                             : widget.from == "Musical"
        //                                 ? "Existential"
        //                                 : "Spiritual",
      });
      request.headers.addAll(headers);
      print("this is widget: ");
      print(widget.from);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        var data = jsonDecode(responseData);
        totalQuestionsCount = data['questions']['total'] ?? 0;
        print("this is total: $totalQuestionsCount");

        await Future.delayed(const Duration(milliseconds: 500));

        print("questions length ==$totalQuestionsCount");
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

  Future<void> getQuestions() async {
    try {
      isDisable = false;
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
                                        : "Spiritual",
        "intelligence_type": widget.from,
        "question_type": ""
      });
      request.headers.addAll(headers);
      print(widget.from);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();

        questionsModel = questionsModelFromJson(responseData);
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 500));
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
          'POST', Uri.parse('http://dreambaby.pro/api/user_answer'));
      request.fields.addAll(
          {'question_id': questionId, "is_flagged": '1', "is_skipped": '0'});
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
          'POST', Uri.parse('http://dreambaby.pro/api/user_answer'));
      request.fields.addAll(
          {'question_id': questionId, "is_flagged": '0', "is_skipped": '1'});
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

  Future<void> submitQuestions(
      {String? questionId,
      String? answer,
      Datum? data,
      BuildContext? ctx}) async {
    try {
      if ((data?.correctAnswer.isNotEmpty ?? false) &&
          ((selectedOptionIndex != null
                  ? (selectedOptionIndex ?? 0) + 1
                  : 0)) ==
              int.parse(data?.correctAnswer.first.toString() ?? "0")) {
        isCorrect = true;
        isDisable = true;
        answerNotifier.notifyListeners();

        await showDialog(
            barrierDismissible: false,
            context: ctx!,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Congratulations your answer is correct.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainColor),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        data?.answerKeyInput ?? "",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          print("pop 3");
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              );
            });
      } else {
        isCorrect = false;
        isDisable = true;
        answerNotifier.notifyListeners();
        if (data?.correctAnswer.isNotEmpty ?? false) {
          await showDialog(
              barrierDismissible: false,
              context: ctx!,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          ((data?.options.length ?? 0) <=
                                  int.parse(
                                      data?.correctAnswer.first.toString() ??
                                          "0"))
                              ? "Below is the Correct Answer"
                              : "Below is the Correct Answer",
                          // ? 'The Correct Answer is ${data?.options[(int.parse(data.correctAnswer.first.toString() ?? "0")) - 1].text}.'
                          // : 'The Correct Answer is ${data?.options[int.parse(data.correctAnswer.first.toString() ?? "0")].text}.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor),
                        ),
                        const SizedBox(height: 20),
                        (((data?.options.length ?? 0) <=
                                        int.parse(data?.correctAnswer.first
                                                .toString() ??
                                            "0"))
                                    ? (data
                                            ?.options[(int.parse(data
                                                        .correctAnswer.first
                                                        .toString() ??
                                                    "0")) -
                                                1]
                                            .image ??
                                        "")
                                    : (data
                                            ?.options[int.parse(data
                                                    .correctAnswer.first
                                                    .toString() ??
                                                "0")]
                                            .image ??
                                        ""))
                                .isNotEmpty
                            ? Image.network(
                                "http://dreambaby.pro/storage/${((data?.options.length ?? 0) <= int.parse(data?.correctAnswer.first.toString() ?? "0")) ? (data?.options[(int.parse(data.correctAnswer.first.toString() ?? "0")) - 1].image ?? "") : (data?.options[int.parse(data.correctAnswer.first.toString() ?? "0")].image ?? "")}",
                                height: 50,
                                width: 60,
                              )
                            : Text(
                                ((data?.options.length ?? 0) <=
                                        int.parse(data?.correctAnswer.first
                                                .toString() ??
                                            "0"))
                                    ? (data
                                            ?.options[(int.parse(data
                                                        .correctAnswer.first
                                                        .toString() ??
                                                    "0")) -
                                                1]
                                            .text ??
                                        "")
                                    : (data
                                            ?.options[int.parse(data
                                                    .correctAnswer.first
                                                    .toString() ??
                                                "0")]
                                            .text ??
                                        ""),
                                        
                                // data?.answerKeyInput ?? "",
                                textAlign: TextAlign.center,
                              ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            print("pop 3");
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      }

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
        'question_id': questionId ?? "",
        "answer": answer ?? "",
        "is_flagged": '0',
        "is_skipped": '0'
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        print(responseData);
        print(questionsModel);
      } else {
        print(response.reasonPhrase);
      }
      if (mounted) {
        setState(() {
          isLoading = false;
          isDisable = false;
        });
      }
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

  Future<void> getTodaysQuestionStatus(BuildContext ctx, int nextIndex) async {
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

      var request = http.Request(
          'GET', Uri.parse('http://dreambaby.pro/api/questions/status/today'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        print(responseData);

        int? skipped = jsonDecode(responseData)['skipped'] ?? 0;
        int? flagged = jsonDecode(responseData)['flagged'] ?? 0;
        int? submitted = jsonDecode(responseData)['submitted'] ?? 0;

        String todayQuestionStatus =
            "You have Submitted $submitted activity, Skipped $skipped activity and Flagged $flagged activity.";

        print(todayQuestionStatus);

        await fetchQuotientStatuses();

        // Find the next incomplete quotient index
        while (nextIndex < quotients.length - 1) {
          nextIndex++;
          if (widget.quotientStatuses[quotients[nextIndex]] == false) {
            break;
          }
        }

        // Check if we've reached the end of the list
        if (nextIndex == quotients.length - 1 &&
            widget.quotientStatuses[quotients[nextIndex]] == true) {
          // All quotients are complete, show final popup
          showFinalPopup(ctx, todayQuestionStatus, nextIndex);
        } else if (nextIndex < quotients.length &&
            widget.quotientStatuses[quotients[nextIndex]] == false &&
            widget.index != 8) {
          // There's another incomplete quotient, navigate to it

          navigateToNextQuotient(ctx, nextIndex);
        } else {
          // This shouldn't happen, but just in case
          showFinalPopup(ctx, todayQuestionStatus, nextIndex);
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showFinalPopup(
      BuildContext ctx, String todayQuestionStatus, int nextIndex) {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext ctx1) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  todayQuestionStatus,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainColor),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(AppColors.whiteColor)),
                        onPressed: () {
                          widget.onExit();
                          fetchQuotientStatuses();
                          Navigator.of(ctx1).pop();
                          Navigator.of(ctx).popUntil((route) => route.isFirst);
                        },
                        child: const Text(
                          'Exit',
                          style: TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(AppColors.mainColor)),
                        onPressed: () async {
                          Navigator.of(ctx1).pop();
                          await fetchQuotientStatuses();
                          await getQuestions();
                          int localIndex = -1;
                          // Find the next incomplete quotient index
                          while (localIndex < quotients.length - 1) {
                            localIndex++;
                            if (widget
                                    .quotientStatuses[quotients[localIndex]] ==
                                false) {
                              break;
                            }
                          }
                          if (localIndex < quotients.length &&
                              widget.quotientStatuses[quotients[localIndex]] ==
                                  false) {
                            navigateToNextQuotient(ctx, localIndex);
                          } else {
                            // If no more incomplete quotients, exit
                            widget.onExit();
                            Navigator.of(ctx)
                                .popUntil((route) => route.isFirst);
                          }
                        },
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void navigateToNextQuotient(BuildContext ctx, int nextIndex) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ExistentialScreen(
          from: quotients[nextIndex],
          quotientStatuses: widget.quotientStatuses,
          index: nextIndex,
          onExit: () async {
            widget.onExit();
            await fetchQuotientStatuses();
          },
        ),
      ),
    );
  }

  Future<void> fetchQuotientStatuses() async {
    var token = await AuthService.getToken();
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET', Uri.parse('http://dreambaby.pro/api/user-question-status'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);
      final statuses = data['statuses'] as Map<String, dynamic>;

      setState(() {
        widget.quotientStatuses =
            statuses.map((key, value) => MapEntry(key, value as bool));
      });
      print(widget.quotientStatuses);
    } else {
      print(response.reasonPhrase);
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
  YoutubePlayerController? youtubePlayerController;

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

  @override
  void initState() {
    String? videoId;
    if (!widget.view.contains("iframe")) {
      videoId = YoutubePlayer.convertUrlToId(widget.view);
    } else {
      videoId = extractYouTubeVideoId(widget.view);
    }
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        loop: true,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    youtubePlayerController?.dispose();
    super.dispose();
  }

  String extractYouTubeVideoId(String iframe) {
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
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(
                  const Color(0xFFC4C8D0).withOpacity(0.5)),
            ),
            onPressed: () {
              youtubePlayerController?.pause();
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (ctx) => VideoPlayerScreen(
                    youtubeLink: widget.view,
                    isYoutube: true,
                  ),
                ),
              )
                  .then(
                (value) {
                  youtubePlayerController?.play();
                },
              );
            },
            child: const Text(
              'Full Screen',
              style: TextStyle(
                  color: Color(0xFF200F31), fontWeight: FontWeight.w500),
            ),
          ),
        ),
        YoutubePlayerBuilder(
          player: YoutubePlayer(
            showVideoProgressIndicator: true,
            bottomActions: const [],
            controlsTimeOut: const Duration(hours: 1),
            controller: youtubePlayerController ??
                YoutubePlayerController(
                  initialVideoId: extractYouTubeVideoId(widget.view),
                ),
          ),
          builder: (
            context,
            player,
          ) {
            return Column(children: [
              // some widgets
              player,
              //some other widgets
            ]);
          },
        ),
      ],
    );
  }
}
