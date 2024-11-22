part of 'subjects_bloc.dart';

@immutable
sealed class SubjectsEvent {}

class FetchSubjects extends SubjectsEvent{}
