import 'package:chewie/chewie.dart';
import 'package:dream_baby/core/media/network_video_controller.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? youtubeLink;
  final String? videoUrl;
  final int? questionId;
  final bool isYoutube;

  const VideoPlayerScreen({
    super.key,
    this.youtubeLink,
    this.videoUrl,
    this.questionId,
    this.isYoutube = false,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;
  ChewieController? _chewieController;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.isYoutube) {
      _initYoutube();
    } else {
      _initNetworkVideo();
    }
  }

  Future<void> _initNetworkVideo() async {
    final controller = await NetworkVideoController.initialize(
      widget.videoUrl,
      questionId: widget.questionId,
      onError: (e) {
        if (mounted) setState(() => _error = 'Unable to load video');
      },
    );

    if (!mounted) return;
    if (controller == null) {
      setState(() => _error = 'Video unavailable');
      return;
    }

    _chewieController = ChewieController(
      videoPlayerController: controller,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.mainColor,
        handleColor: AppColors.primaryColor,
        bufferedColor: AppColors.cardColor,
        backgroundColor: AppColors.greyTextColor.withValues(alpha: 0.3),
      ),
      placeholder: const ColoredBox(
        color: Colors.black12,
        child: Center(child: CircularProgressIndicator()),
      ),
      errorBuilder: (_, message) => Center(
        child: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );

    setState(() => _videoController = controller);
  }

  void _initYoutube() {
    final link = widget.youtubeLink ?? '';
    if (link.isEmpty) {
      _error = 'Video unavailable';
      return;
    }

    String? videoId;
    if (!link.contains('iframe')) {
      videoId = YoutubePlayer.convertUrlToId(link);
    } else {
      videoId = _extractYouTubeVideoId(link);
    }

    if (videoId == null || videoId.isEmpty) {
      _error = 'Invalid YouTube link';
      return;
    }

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        enableCaption: true,
        controlsVisibleAtStart: true,
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  String _extractYouTubeVideoId(String iframe) {
    final patterns = [
      RegExp(r'src="https?:\/\/www\.youtube\.com\/embed\/([^"?]+)'),
      RegExp(r'youtu\.be\/([^"?&]+)'),
      RegExp(r'v=([^"&]+)'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(iframe);
      if (match != null && match.groupCount > 0) {
        return match.group(1) ?? '';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: _error != null
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    )
                  : widget.isYoutube
                      ? isPortrait
                          ? _buildYoutubePlayer()
                          : FittedBox(
                              fit: BoxFit.fitHeight,
                              child: _buildYoutubePlayer(),
                            )
                      : _chewieController != null
                          ? Chewie(controller: _chewieController!)
                          : const CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: IconButton(
              onPressed: () {
                if (!isPortrait) {
                  SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp],
                  );
                }
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYoutubePlayer() {
    return YoutubePlayer(
      controller: _youtubeController!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: AppColors.mainColor,
      bottomActions: [
        RemainingDuration(controller: _youtubeController),
        CurrentPosition(controller: _youtubeController),
        const ProgressBar(isExpanded: true),
        PlaybackSpeedButton(controller: _youtubeController),
        FullScreenButton(controller: _youtubeController),
      ],
    );
  }
}
