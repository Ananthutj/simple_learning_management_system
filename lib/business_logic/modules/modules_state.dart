part of 'modules_bloc.dart';

@immutable
sealed class ModulesState {}

final class ModulesLoading extends ModulesState {}

class ModulesFetched extends ModulesState{
  final List<Modules> modules;
  ModulesFetched({required this.modules});
}

class ModulesError extends ModulesState{
  final String errorMessage;
  ModulesError({required this.errorMessage});
}
