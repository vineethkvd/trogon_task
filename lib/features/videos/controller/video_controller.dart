import 'package:flutter/foundation.dart';
import '../model/video_model.dart';
import '../../../core/utils/shared/component/widgets/custom_toast.dart';
import '../repository/module_repository.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
class VideoController extends ChangeNotifier {
  final _api = ModuleRepository();
  bool isLoading = false;
  bool isPlayerReady = false;

  String currentTitle = '';
  String currentDescription = '';
  String currentVideoType = '';
  List<VideoModel> moduleList = [];
  late YoutubePlayerController ytController;
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  Future<void> fetchModules({required String moduleId}) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _api.moduleApi(moduleId: moduleId);
      if (response != null && response['status'] == 200) {
        final List<dynamic> responseData = response['data'];
        moduleList = responseData
            .map((json) => VideoModel.fromJson(json))
            .toList();

        if (moduleList.isNotEmpty) {
          initializePlayer(moduleList.first);
        }
      } else {
        CustomToast.showCustomToast(message: "Unexpected error occurred");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching modules: $e");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void initializePlayer(VideoModel video) {
    isPlayerReady = true;
    notifyListeners();

    currentTitle = video.title ?? '';
    currentDescription = video.description ?? '';
    currentVideoType = video.videoType ?? '';

    if (video.videoType == 'YouTube') {
      initializeYouTubePlayer(video.videoUrl ?? '');
    } else {
      initializeChewiePlayer(video.videoUrl ?? '');
    }
  }

  void initializeYouTubePlayer(String url) {
    final videoId = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=7AcwQ4JoPNg") ?? '';
    ytController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false, controlsVisibleAtStart: true),
    );

    isPlayerReady = true;
    notifyListeners();
  }

  Future<void> initializeChewiePlayer(String url) async {
    videoPlayerController = VideoPlayerController.network(url);
    try {
      await videoPlayerController.initialize();
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoInitialize: true,
        autoPlay: false,
        showControls: true,
        placeholder: Container(color: Colors.black),
      );

      isPlayerReady = true;
    } catch (e) {
      CustomToast.showCustomToast(message: "Error initializing video: $e");
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    ytController.dispose();
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }
}
