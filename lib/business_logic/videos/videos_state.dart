part of 'videos_bloc.dart';

@immutable
sealed class VideosState {}

final class VideosInitial extends VideosState {}

class VideoLoading extends VideosState {}

class VideoFetched extends VideosState {
  final List<Video> videos;

  VideoFetched({required this.videos});
}

class VideoError extends VideosState {
  final String message;

  VideoError({required this.message});
}