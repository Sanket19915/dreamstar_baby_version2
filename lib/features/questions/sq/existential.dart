import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:vibration/vibration.dart';

class ExistentialScreen extends StatefulWidget {
  const ExistentialScreen({super.key});

  @override
  State<ExistentialScreen> createState() => _ExistentialScreenState();
}

class _ExistentialScreenState extends State<ExistentialScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarTransparent = true;
  bool isPurposeExpanded = false;
  bool isQuestionExpanded = false;
  late VideoPlayerController _controller;
  int? selectedOptionIndex;

  @override
  void initState() {
    super.initState();
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

    List<String> options1 = ["Red", "Orange", "Yellow", "Pink"];

    List<Map<String, String>> options = [
      {"text": "Red", "image": "https://picsum.photos/id/1011/200/300"},
      {"text": "Orange", "image": "https://picsum.photos/id/1012/200/300"},
      {"text": "Yellow", "image": "https://picsum.photos/id/1013/200/300"},
      {"text": "Pink", "image": "https://picsum.photos/id/1014/200/300"},
    ];

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
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage(AppImages.sq),
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.6),
                BlendMode.srcATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 120),
              Container(
                height: deviceheight * 0.173,
                width: devicewidth,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.existential),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
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
                          isPurposeExpanded = !isPurposeExpanded;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Purpose',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                          ),
                          Icon(
                            isPurposeExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColors.blackColor,
                          ),
                        ],
                      ),
                    ),
                    if (isPurposeExpanded)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'This activity is aimed at giving gratitude to all the people, things or situations, however big or small, thus enhancing positivity and grace in our lives, thereby making you and your baby in the womb, ‘People Smart’.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),
                    Text(
                      "For this purpose, create a Gratitude Jar wherein you can regularly deposit notes expressing your gratefulness and appreciation for life’s blessings. There are few things in life that we learn after a long time, and others, very instantly. Be grateful for your brain and body to enable you to master some important things in life. Write few words for it and put it in the Gratitude Jar.",
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
                    InkWell(
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
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        image: DecorationImage(
                          image: NetworkImage('https://picsum.photos/200/300'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
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
                              : const Center(
                                  child: CircularProgressIndicator()),
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
                    const SizedBox(height: 20),
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
                    for (int i = 0; i < options1.length; i++)
                      GestureDetector(
                        onTap: () => _selectOption(i),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: selectedOptionIndex == i
                                  ? Colors.blue
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${i + 1}. ${options1[i]}',
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
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                        image: NetworkImage(
                                            options[index]["image"]!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${index + 1}. ${options[index]["text"]}',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
