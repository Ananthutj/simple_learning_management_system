import 'package:lms_app/data/models/subjects.dart';
import 'package:lms_app/data/services/lms_services.dart';

class SubjectsRepo {
  final LmsServices _lmsServices = LmsServices();

  Future<List<Subjects>> fetchSubjects() async {
    try {
      final data = await _lmsServices.fetchSubjects();
      return data.map((e) => Subjects.fromJson(e)).toList();
    } catch (e) {
      throw 'Failed to fetch the subjects';
    }
  }
}
