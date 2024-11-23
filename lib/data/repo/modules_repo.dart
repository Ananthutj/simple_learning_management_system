import 'package:lms_app/data/models/modules.dart';
import 'package:lms_app/data/services/lms_services.dart';

class ModulesRepo {
  final LmsServices _lmsServices = LmsServices();

  Future<List<Modules>> fetchModules(int subjectId)async{
    try {
      final data = await _lmsServices.fetchModules(subjectId);
      return data.map((e)=> Modules.fromJson(e)).toList();
    } catch (e) {
      throw 'Failed to fetch the modules';
    }
  }
}

