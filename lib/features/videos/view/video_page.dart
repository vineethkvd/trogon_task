import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_more_text/read_more_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/utils/config/styles/colors.dart';
import '../../../core/utils/shared/component/widgets/custom_toast.dart';
import '../controller/video_controller.dart';
import '../model/video_model.dart';

class VideoPage extends StatefulWidget {
  final String moduleId;

  const VideoPage({Key? key, required this.moduleId}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  // late YoutubePlayerController _ytController;
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlayerReady = false;
  String selectedLessonTitle = '';
  String selectedLessonDescription = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadModules();
    });
  }

  Future<void> _loadModules() async {
    final videoController = Provider.of<VideoController>(context, listen: false);
    await videoController.fetchModules(moduleId: widget.moduleId);

    if (videoController.moduleList.isNotEmpty) {
      final firstLesson = videoController.moduleList.first;

      switch (firstLesson.videoType) {
        case "YouTube":
          // initializeYouTubePlayer(
          //   url: firstLesson.videoUrl ?? '',
          //   title: firstLesson.title ?? '',
          //   description: firstLesson.description ?? '',
          // );
          break;
        case "Vimeo":
        // Handle Vimeo case here if needed
          break;
        default:
          initializeChewiePlayer(
            url: firstLesson.videoUrl ?? '',
            title: firstLesson.title ?? '',
            description: firstLesson.description ?? '',
          );
          break;
      }
    }
  }

  void initializeYouTubePlayer({
    required String url,
    required String title,
    required String description,
  }) {
    // final videoId = YoutubePlayer.convertUrlToId(url) ?? '';
    // _ytController = YoutubePlayerController(
    //   initialVideoId: videoId,
    //   flags: const YoutubePlayerFlags(
    //     autoPlay: false,
    //     controlsVisibleAtStart: true,
    //   ),
    // );
    //
    // setState(() {
    //   _isPlayerReady = true;
    //   selectedLessonTitle = title;
    //   selectedLessonDescription = description;
    // });
  }

  Future<void> initializeChewiePlayer({
    required String url,
    required String title,
    required String description,
  }) async {
    _videoPlayerController = VideoPlayerController. networkUrl (Uri.parse(url));

    try {
      await _videoPlayerController.initialize();
    } catch (error) {
      CustomToast.showCustomToast(message: "Error loading video: $error");
      return;
    }

    setState(() {
      _isPlayerReady = true;
      selectedLessonTitle = title;
      selectedLessonDescription = description;
    });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: false,
      showControls: true,
      placeholder: Container(color: Colors.black),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    // _ytController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoController = Provider.of<VideoController>(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: AppColor.appBarColor,
        centerTitle: true,
        title: const Text(
          "Lessons",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: videoController.isLoading
          ? _buildShimmerEffect()
          : videoController.moduleList.isEmpty
          ? const Center(
        child: Text(
          "No lessons available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : Column(
        children: [
          if (_isPlayerReady) buildVideoPlayer(width),
          Expanded(child: buildLessonList(videoController.moduleList)),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 200,
        color: Colors.white,
      ),
    );
  }

  Widget buildVideoPlayer(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          height: 200,
          child: _isPlayerReady
              ? (_chewieController != null
              ? Chewie(controller: _chewieController!):SizedBox.shrink())
              // : YoutubePlayer(controller: _ytController))
              : _buildShimmerEffect(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            selectedLessonTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            selectedLessonDescription,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget buildLessonList(List<VideoModel> lessons) {
    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return InkWell(
          onTap: () {
            if (lesson.videoUrl != null) {
              if (lesson.videoType == 'YouTube') {
                initializeYouTubePlayer(
                  url: lesson.videoUrl!,
                  title: lesson.title ?? '',
                  description: lesson.description ?? '',
                );
              } else {
                initializeChewiePlayer(
                  url: lesson.videoUrl!,
                  title: lesson.title ?? '',
                  description: lesson.description ?? '',
                );
              }
            } else {
              CustomToast.showCustomToast(message: "Video URL not available");
            }
          },
          child: _buildLessonCard(lesson),
        );
      },
    );
  }

  Widget _buildLessonCard(VideoModel lesson) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: '', // Use actual image URL here
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Container(color: Colors.grey),
                      errorWidget: (context, url, error) =>
                          Container(color: Colors.grey),
                    ),
                  ),
                  const Center(
                    child: Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title ?? '',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                ReadMoreText(
                  lesson.description ?? '',
                  numLines: 1,
                  readMoreText: 'Read more',
                  readLessText: 'Read less',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
