import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jpnese2u/ui/capture_translate/model.dart';
import 'package:jpnese2u/util/constant/hinshi.dart';
import 'package:jpnese2u/util/constant/type.dart';

part 'sentence_selection_cubit.extension.dart';

typedef SentenceSelectionState = Set<int>;

class SentenceSelectionCubit extends Cubit<SentenceSelectionState> {
  final CaptureSentenceData _sentence;

  SentenceSelectionCubit(this._sentence) : super({});

  bool isAllSelected() {
    return state.containsAll(
      _sentence.selectableTokens.map((t) => t.id),
    );
  }

  void selectAll() {
    emit(_sentence.selectableTokens.map((t) => t.id).toSet());
  }

  bool isNoneSelected() {
    return state.isEmpty;
  }

  void deselectAll() {
    emit({});
  }

  void selectToken(int tokenId) {
    final current = Set<int>.from(state);

    if (current.contains(tokenId)) return;
    current.add(tokenId);

    emit(current);
  }

  void deselectToken(int tokenId) {
    final current = Set<int>.from(state);

    if (!current.contains(tokenId)) return;
    current.remove(tokenId);

    emit(current);
  }

  void selectByHinshi(Hinshi hinshi) {
    final current = Set<int>.of(state);

    for (final t in _sentence.selectableTokens) {
      if (Hinshi.fromJp(t.pos) == hinshi) current.add(t.id);
    }

    emit(current);
  }

  void deselectByHinshi(Hinshi hinshi) {
    final current = Set<int>.of(state);

    for (final t in _sentence.selectableTokens) {
      if (Hinshi.fromJp(t.pos) == hinshi) current.remove(t.id);
    }

    emit(current);
  }

  void setState(SetStateCallback<SentenceSelectionState> callback) {
    emit(callback(state));
  }
}
