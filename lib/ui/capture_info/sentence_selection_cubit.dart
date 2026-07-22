import 'package:flutter/widgets.dart';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jpnese2u/ui/capture_info/model.dart';
import 'package:jpnese2u/util/constant/hinshi.dart';

part 'sentence_selection_cubit.g.dart';
part 'sentence_selection_cubit.extension.dart';

@CopyWith()
class SentenceSelectionState {
  const SentenceSelectionState({required this.sentences});

  final Map<int, Set<int>> sentences;

  bool isTokenSelected(int sentenceId, int tokenId) =>
      sentences[sentenceId]?.contains(tokenId) ?? false;

  bool isSentenceSelected(int sentenceId, int targetLength) =>
      (sentences[sentenceId]?.length ?? 0) == targetLength;
}

class SentenceSelectionCubit extends Cubit<SentenceSelectionState> {
  SentenceSelectionCubit(List<int> groupIds)
    : super(
        SentenceSelectionState(
          sentences: {for (final id in groupIds) id: {}},
        ),
      );

  void selectToken(int sentenceId, int tokenId) {
    final current = Set<int>.of(state.sentences[sentenceId] ?? {});

    if (current.contains(tokenId)) return;

    current.add(tokenId);

    emit(
      state.copyWith(
        sentences: {...state.sentences, sentenceId: current},
      ),
    );
  }

  void deselectToken(int sentenceId, int tokenId) {
    final current = Set<int>.of(state.sentences[sentenceId] ?? {});

    if (!current.contains(tokenId)) return;

    current.remove(tokenId);

    emit(
      state.copyWith(
        sentences: {...state.sentences, sentenceId: current},
      ),
    );
  }

  void selectAll(int sentenceId, List<UIToken> tokens) {
    final allIds = {for (final t in tokens) t.id};

    emit(
      state.copyWith(
        sentences: {...state.sentences, sentenceId: allIds},
      ),
    );
  }

  void deselectAll(int sentenceId) {
    emit(
      state.copyWith(
        sentences: {...state.sentences, sentenceId: {}},
      ),
    );
  }

  void selectByHinshi(int sentenceId, List<UIToken> tokens, Hinshi hinshi) {
    final current = Set<int>.of(state.sentences[sentenceId] ?? {});

    for (final t in tokens) {
      if (Hinshi.fromJp(t.pos) == hinshi) current.add(t.id);
    }

    emit(
      state.copyWith(
        sentences: {...state.sentences, sentenceId: current},
      ),
    );
  }

  void deselectByHinshi(int sentenceId, List<UIToken> tokens, Hinshi hinshi) {
    final current = Set<int>.of(state.sentences[sentenceId] ?? {});

    for (final t in tokens) {
      if (Hinshi.fromJp(t.pos) == hinshi) current.remove(t.id);
    }

    emit(
      state.copyWith(
        sentences: {...state.sentences, sentenceId: current},
      ),
    );
  }
}
