import 'package:bloc/bloc.dart';
import 'package:lms_app/data/models/subjects.dart';
import 'package:lms_app/data/repo/subjects_repo.dart';
import 'package:meta/meta.dart';

part 'subjects_event.dart';
part 'subjects_state.dart';

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  final SubjectsRepo subjectsRepo;
  SubjectsBloc(this.subjectsRepo) : super(SubjectsLoading()) {
    on<FetchSubjects>(_manageFetchSubjects);
  }
  Future<void> _manageFetchSubjects(
      FetchSubjects event, Emitter<SubjectsState> emit) async {
    emit(SubjectsLoading());
    try {
      final subjects = await subjectsRepo.fetchSubjects();
      emit(SubjectsFetched(subjects: subjects));
    } catch (e) {
      emit(SubjectsError(errorMessage: e.toString()));
    }
  }
}
