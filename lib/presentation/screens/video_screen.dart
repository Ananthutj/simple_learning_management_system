import 'package:flutter/material.dart';
import 'package:lms_app/business_logic/videos/videos_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms_app/data/models/videos.dart';
import 'package:lms_app/globals/extensions.dart';
import 'package:lms_app/globals/text_styles.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class VideoScreen extends StatefulWidget {
  final String modName;
  final int modId;

  const VideoScreen({super.key, required this.modName, required this.modId});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    context.read<VideosBloc>().add(FetchVideos(moduleId: widget.modId));
  }

  Widget _buildVideoCard(String title, String description, Widget videoPlayer) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: s4.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: h6.copyWith(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            videoPlayer,
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 16),
          Text(message, style: s4.copyWith(color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color.fromARGB(255, 243, 152, 33),),
          SizedBox(height: 16),
          Text("Loading video..."),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 54, 61, 70), Colors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(widget.modName,style: h6.copyWith(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: context.colorScheme.surface,
              ),),
              leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,color: context.colorScheme.surface,)),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 72, 36, 87),
            elevation: 0,
          ),
          body: BlocBuilder<VideosBloc, VideosState>(
            builder: (context, state) {
              if (state is VideoLoading) {
                return _buildLoadingState();
              } else if (state is VideoError) {
                return _buildErrorState("Error fetching videos");
              } else if (state is VideoFetched) {
                final Video? video = state.videos.where(
                  (video) => video.id == widget.modId,
                ).firstOrNull;

                if (video == null) {
                  return _buildErrorState("Video not found");
                }

                if (video.videoUrl.isNotEmpty) {
                  if (video.videoType == "YouTube") {
                    final videoId = YoutubePlayer.convertUrlToId(video.videoUrl);
                    if (videoId != null && videoId.isNotEmpty) {
                      _youtubePlayerController = YoutubePlayerController(
                        initialVideoId: videoId,
                        flags: const YoutubePlayerFlags(
                          autoPlay: true,
                          mute: false,
                        ),
                      );

                      return _buildVideoCard(
                        video.title,
                        video.description,
                        YoutubePlayer(
                          controller: _youtubePlayerController,
                          showVideoProgressIndicator: true,
                          onReady: () {},
                        ),
                      );
                    } else {
                      return _buildErrorState("Invalid YouTube video URL");
                    }
                  } else if (video.videoType == "Vimeo") {
                    return _buildVideoCard(
                      video.title,
                      video.description,
                      SizedBox(
                        height: 300,
                        child: VimeoVideoPlayer(
                          url: video.videoUrl,
                          autoPlay: true,
                        ),
                      ),
                    );
                  } else {
                    return _buildErrorState("Unsupported video type");
                  }
                } else {
                  return _buildErrorState("Video URL is empty");
                }
              } else {
                return _buildErrorState("No videos found");
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    super.dispose();
  }
}
