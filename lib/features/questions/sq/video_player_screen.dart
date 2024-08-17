import 'package:chewie/chewie.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? youtubeLink;
  final bool isYoutube;
  const VideoPlayerScreen({
    super.key,
    this.youtubeLink,
    this.isYoutube = false,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? videoPlayerController;
  YoutubePlayerController? youtubePlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(
        'https://www.w3schools.com/html/mov_bbb.mp4')
      ..initialize().then((_) {
        setState(() {});
      }).then((value) {
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          autoPlay: false,
          looping: true,
        );
      });
    if (widget.youtubeLink?.isNotEmpty ?? false) {
      String? videoId;
      if (!(widget.youtubeLink?.contains("iframe")??false)) {
        videoId = YoutubePlayer.convertUrlToId(widget.youtubeLink ?? "");
      } else {
        videoId = extractYouTubeVideoId(widget.youtubeLink ?? "");
      }
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId ?? "",
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          loop: true,
        ),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    youtubePlayerController?.dispose();
    chewieController?.dispose();
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
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: AppColors.backgroundColor,
      //   leading: InkWell(
      //     onTap: () {
      //       Navigator.of(context).pop();
      //     },
      //     child: const Icon(
      //       Icons.arrow_back,
      //       color: AppColors.blackColor,
      //       size: 24,
      //     ),
      //   ),
      //   centerTitle: true,
      //   title: Text(
      //     "",
      //     style: GoogleFonts.poppins(
      //       color: AppColors.blackColor,
      //       fontSize: 20,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!widget.isYoutube)
                (videoPlayerController?.value.isInitialized ?? false)
                    ? AspectRatio(
                        aspectRatio:
                            videoPlayerController?.value.aspectRatio ?? 0.0,
                        child: Chewie(
                          controller: chewieController!,
                        ),
                      )
                    : const Center(child: CircularProgressIndicator())
              else
                isPortrait
                    ? _buildYoutubePlayer()
                    : SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: _buildYoutubePlayer(),
                        ),
                      ),
            ],
          )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                if (!isPortrait) {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                }
                Navigator.of(context).pop();
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.whiteColor,
                  size: 24,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  YoutubePlayer _buildYoutubePlayer() {
    return YoutubePlayer(
      controller: youtubePlayerController ??
          YoutubePlayerController(
            initialVideoId: extractYouTubeVideoId(widget.youtubeLink ?? ""),
          ),
      showVideoProgressIndicator: true,
      progressIndicatorColor: AppColors.mainColor,
      bottomActions: [
        RemainingDuration(
          controller: youtubePlayerController,
        ),
        CurrentPosition(
          controller: youtubePlayerController,
        ),
        PlaybackSpeedButton(
          controller: youtubePlayerController,
        ),
        ProgressBar(
          isExpanded: true,
          controller: youtubePlayerController,
        ),
        FullScreenButton(
          color: AppColors.mainColor,
          controller: youtubePlayerController,
        )
      ],
    );
  }
}
