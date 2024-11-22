part of 'subjects_bloc.dart';

@immutable
sealed class SubjectsState {}

final class SubjectsLoading extends SubjectsState {}

class SubjectsFetched extends SubjectsState{
  final List<Subjects> subjects;
  SubjectsFetched({required this.subjects});
}

class SubjectsError extends SubjectsState{
  final String errorMessage;
  SubjectsError({required this.errorMessage});
}
