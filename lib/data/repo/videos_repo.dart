import 'package:lms_app/data/models/videos.dart';
import 'package:lms_app/data/services/lms_services.dart';

class VideosRepo {
  final LmsServices _lmsServices = LmsServices();

  Future<List<Video>> fetchVideos(int moduleId)async{
    try {
      final data = await _lmsServices.fetchVideos(moduleId);
      return data.map((e)=> Video.fromJson(e)).toList();
    } catch (e) {
      throw 'Failed to fetch the subjects';
    }
  }
}

