part of 'modules_bloc.dart';

@immutable
sealed class ModulesEvent {}

class FetchModules extends ModulesEvent{
  final int subjectId;
  FetchModules({required this.subjectId});
}
