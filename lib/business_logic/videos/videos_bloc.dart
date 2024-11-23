import 'package:bloc/bloc.dart';
import 'package:lms_app/data/models/videos.dart';
import 'package:lms_app/data/repo/videos_repo.dart';
import 'package:meta/meta.dart';

part 'videos_event.dart';
part 'videos_state.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  final VideosRepo videosRepo;
  VideosBloc(this.videosRepo) : super(VideosInitial()) {
     on<FetchVideos>(_manageFetchVideos);
  }
  Future<void> _manageFetchVideos(
      FetchVideos event, Emitter<VideosState> emit) async {
    emit(VideoLoading());
    try {
      final videos = await videosRepo.fetchVideos(event.moduleId); 
      emit(VideoFetched(videos: videos));
    } catch (e) {
      emit(VideoError(message: e.toString()));
    }
  }
}
