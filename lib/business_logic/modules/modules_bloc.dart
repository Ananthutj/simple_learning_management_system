import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'modules_event.dart';
part 'modules_state.dart';

class ModulesBloc extends Bloc<ModulesEvent, ModulesState> {
  ModulesBloc() : super(ModulesInitial()) {
    on<ModulesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
