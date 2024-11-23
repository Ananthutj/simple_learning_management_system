part of 'videos_bloc.dart';

@immutable
sealed class VideosEvent {}

class FetchVideos extends VideosEvent {
  final int moduleId;

  FetchVideos({required this.moduleId});
}