import 'package:bloc/bloc.dart';
import 'package:lms_app/data/models/modules.dart';
import 'package:lms_app/data/repo/modules_repo.dart';
import 'package:meta/meta.dart';

part 'modules_event.dart';
part 'modules_state.dart';

class ModulesBloc extends Bloc<ModulesEvent, ModulesState> {
  final ModulesRepo modulesRepo;
  ModulesBloc(this.modulesRepo) : super(ModulesLoading()) {
    on<FetchModules>(_manageFetchModules);
  }
  Future<void> _manageFetchModules(FetchModules event, Emitter<ModulesState> emit) async{
    emit(ModulesLoading());
    try {
      final modules = await modulesRepo.fetchModules(event.subjectId);
      emit(ModulesFetched(modules: modules));
    } catch (e) {
      emit(ModulesError(errorMessage: e.toString()));
    }
  }
}
