import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/storage/activity_progress_cache.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoController {
  NetworkVideoController._();

  static VideoPlayerController? create(String? videoPath) {
    final url = ApiConfig.storageUrl(videoPath);
    if (url.isEmpty) return null;

    return VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
        allowBackgroundPlayback: false,
      ),
      httpHeaders: const {
        'Accept': '*/*',
        'Connection': 'keep-alive',
      },
    );
  }

  static Future<VideoPlayerController?> initialize(
    String? videoPath, {
    int? questionId,
    void Function()? onReady,
    void Function(Object error)? onError,
  }) async {
    final controller = create(videoPath);
    if (controller == null) return null;

    try {
      await controller.initialize();

      if (questionId != null) {
        final saved = ActivityProgressCache.mediaProgressFor(questionId);
        if (saved > 0 && controller.value.duration.inMilliseconds > 0) {
          final position = Duration(
            milliseconds: (controller.value.duration.inMilliseconds * saved / 100)
                .round(),
          );
          await controller.seekTo(position);
        }

        controller.addListener(() {
          final duration = controller.value.duration.inMilliseconds;
          if (duration > 0 && controller.value.isPlaying) {
            final percent =
                controller.value.position.inMilliseconds / duration * 100;
            ActivityProgressCache.saveMediaProgress(questionId, percent);
          }
        });
      }

      onReady?.call();
      return controller;
    } catch (e) {
      await controller.dispose();
      onError?.call(e);
      return null;
    }
  }

  /// Warms the network connection for the next clip on cellular networks.
  static Future<void> prefetchVideo(String? videoPath) async {
    final controller = create(videoPath);
    if (controller == null) return;
    try {
      await controller.initialize();
    } catch (_) {
      // Prefetch is best-effort only.
    } finally {
      await controller.dispose();
    }
  }
}
