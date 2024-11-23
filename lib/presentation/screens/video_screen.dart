import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms_app/business_logic/videos/videos_bloc.dart';
import 'package:lms_app/data/models/videos.dart';
import 'package:lms_app/globals/extensions.dart';
import 'package:lms_app/globals/text_styles.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VideoScreen extends StatefulWidget {
  final String modName;
  final int modId;

  const VideoScreen({super.key, required this.modName, required this.modId});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _youtubePlayerController;
  late InAppWebViewController _inAppWebViewController;

  @override
  void initState() {
    super.initState();
    context.read<VideosBloc>().add(FetchVideos(moduleId: widget.modId));
  }

  Widget _buildVideoCard(String title, String description, Widget videoPlayer) {
    return Padding(
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
          Flexible(
            child: videoPlayer,
          ),
        ],
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
          CircularProgressIndicator(color: Color.fromARGB(255, 243, 152, 33)),
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
          colors: [
            Color.fromARGB(255, 227, 231, 235),
            Color.fromARGB(255, 178, 183, 185)
          ],
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
            title: Text(
              widget.modName,
              style: h2.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.surface,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios,
                  color: context.colorScheme.surface),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 72, 36, 87),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<VideosBloc, VideosState>(
                  builder: (context, state) {
                    if (state is VideoLoading) {
                      return Center(child: _buildLoadingState());
                    } else if (state is VideoError) {
                      return _buildErrorState("Error fetching videos");
                    } else if (state is VideoFetched) {
                      final Video? video = state.videos
                          .where(
                            (video) => video.id == widget.modId,
                          )
                          .firstOrNull;

                      print("Fetched Videos: ${state.videos}");

                      if (video == null) {
                        return _buildErrorState(
                            "Video not found for the selected module.");
                      }

                      if (video.videoUrl.isEmpty || video.videoType.isEmpty) {
                        return _buildErrorState("Video data is incomplete.");
                      }

                      if (video.videoType == "YouTube") {
                        final videoId =
                            YoutubePlayer.convertUrlToId(video.videoUrl);
                        if (videoId == null || videoId.isEmpty) {
                          return _buildErrorState("Invalid YouTube video URL.");
                        }

                        _youtubePlayerController = YoutubePlayerController(
                          initialVideoId: videoId,
                          flags: const YoutubePlayerFlags(
                            autoPlay: true,
                            mute: false,
                          ),
                        );

                        return Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 1,
                            width: double.infinity,
                            child: _buildVideoCard(
                              video.title,
                              video.description,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: YoutubePlayer(
                                  controller: _youtubePlayerController,
                                  showVideoProgressIndicator: true,
                                  onReady: () {},
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      if (video.videoType == "Vimeo") {
                        final videoId =
                            Uri.parse(video.videoUrl).pathSegments.last;

                        if (videoId.isEmpty) {
                          return _buildErrorState("Invalid Vimeo video URL.");
                        }

                        return Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height /2.25,
                            width: double.infinity,
                            child: _buildVideoCard(
                              video.title,
                              video.description,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: InAppWebView(
                                  initialUrlRequest: URLRequest(
                                      url: WebUri(
                                          "https://player.vimeo.com/video/$videoId")),
                                  onWebViewCreated: (controller) {
                                    _inAppWebViewController = controller;
                                  },
                                  onLoadStop: (controller, url) {
                                    print("Vimeo video loaded successfully");
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return _buildErrorState("Unsupported video type.");
                    } else {
                      return _buildErrorState("No videos found");
                    }
                  },
                ),
              ],
            ),
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
