import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:chewie/chewie.dart';
import '../../../core/utils/config/styles/colors.dart';
import '../controller/video_controller.dart';

class VideoPage extends StatelessWidget {
  final String moduleId;

  const VideoPage({Key? key, required this.moduleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoController()..fetchModules(moduleId: moduleId),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: AppColor.appBarColor,
          title: const Text(
            "Video Lessons",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Consumer<VideoController>(
          builder: (context, videoController, child) {
            if (videoController.isLoading) {
              return _buildShimmerEffect();
            }

            if (videoController.moduleList.isEmpty) {
              return const Center(
                child: Text("No lessons available", style: TextStyle(color: Colors.grey, fontSize: 16)),
              );
            }

            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildVideoPlayer(videoController), // The video player section
                  Expanded(child: _buildLessonList(videoController)), // The suggestions list
                ],
              ),
            );
          },
        ),
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

  Widget _buildVideoPlayer(VideoController videoController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: videoController.isPlayerReady
              ? (videoController.currentVideoType == 'YouTube'
              ? YoutubePlayer(controller: videoController.ytController)
              : Chewie(controller: videoController.chewieController!))
              : _buildShimmerEffect(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            videoController.currentTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            videoController.currentDescription,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        const Divider(thickness: 1, color: Colors.grey),
      ],
    );
  }

  Widget _buildLessonList(VideoController videoController) {
    return ListView.builder(
      itemCount: videoController.moduleList.length,
      itemBuilder: (context, index) {
        final lesson = videoController.moduleList[index];
        return InkWell(
          onTap: () {
            if (lesson.videoUrl != null) {
              videoController.initializePlayer(lesson);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Video URL not available")),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Thumbnail image
                Container(
                  width: 80,
                  height: 60,
                  color: Colors.grey[300], // Placeholder background
                  child: const Icon(Icons.play_circle_fill, color: Colors.white),
                ),
                const SizedBox(width: 10),
                // Title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title ?? '',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lesson.description ?? '',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
