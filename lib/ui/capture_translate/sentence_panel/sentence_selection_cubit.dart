import 'package:flutter/widgets.dart';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jpnese2u/ui/capture_translate/model.dart';
import 'package:jpnese2u/util/constant/hinshi.dart';
import 'package:jpnese2u/util/constant/type.dart';

part 'sentence_selection_cubit.g.dart';
part 'sentence_selection_cubit.extension.dart';

@CopyWith()
class SentenceSelectionState {
  final Set<int> selection;
  final Map<int, String> translation;

  SentenceSelectionState({
    required this.selection,
    required this.translation,
  });
}

class SentenceSelectionCubit extends Cubit<SentenceSelectionState> {
  final CaptureSentenceData _sentence;

  SentenceSelectionCubit(this._sentence)
    : super(
        SentenceSelectionState(
          selection: {},
          translation: {},
        ),
      );

  bool isAllSelected() {
    return state.selection.containsAll(
      _sentence.selectableTokens.map((t) => t.id),
    );
  }

  void selectAll() {
    emit(
      state.copyWith.selection(
        _sentence.selectableTokens.map((t) => t.id).toSet(),
      ),
    );
  }

  bool isNoneSelected() {
    return state.selection.isEmpty;
  }

  void deselectAll() {
    emit(state.copyWith.selection({}));
  }

  void selectToken(int tokenId) {
    final current = Set<int>.from(state.selection);

    if (current.contains(tokenId)) return;
    current.add(tokenId);

    emit(state.copyWith.selection(current));
  }

  void deselectToken(int tokenId) {
    final current = Set<int>.from(state.selection);

    if (!current.contains(tokenId)) return;
    current.remove(tokenId);

    emit(state.copyWith.selection(current));
  }

  void selectByHinshi(Hinshi hinshi) {
    final current = Set<int>.of(state.selection);

    for (final t in _sentence.selectableTokens) {
      if (Hinshi.fromJp(t.pos) == hinshi) current.add(t.id);
    }

    emit(state.copyWith.selection(current));
  }

  void deselectByHinshi(Hinshi hinshi) {
    final current = Set<int>.of(state.selection);

    for (final t in _sentence.selectableTokens) {
      if (Hinshi.fromJp(t.pos) == hinshi) current.remove(t.id);
    }

    emit(state.copyWith.selection(current));
  }

  void setState(SetStateCallback<SentenceSelectionState> callback) {
    emit(callback(state));
  }
}
