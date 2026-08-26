import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpnese2u/service/token_definition_serv/model.dart';
import 'package:jpnese2u/util/constant/hinshi.dart';

class DefinitionDrawerState {
  final List<TokenDefinitionData> definitions;
  final Hinshi hinshi;

  const DefinitionDrawerState({
    this.definitions = const [],
    this.hinshi = Hinshi.unknown,
  });
}

class DefinitionDrawerCubit extends Cubit<DefinitionDrawerState> {
  DefinitionDrawerCubit() : super(const DefinitionDrawerState());

  void show({
    required List<TokenDefinitionData> definitions,
    required Hinshi hinshi,
  }) {
    emit(
      DefinitionDrawerState(
        definitions: definitions,
        hinshi: hinshi,
      ),
    );
  }

  void clear() {
    emit(const DefinitionDrawerState());
  }
}
