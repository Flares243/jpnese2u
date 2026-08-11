part of 'sentence_selection_cubit.dart';

extension SentenceSelectionStateExtension on SentenceSelectionState {
  bool isTokensSelected(Iterable<int> tokenIds) =>
      tokenIds.every((id) => contains(id));
}
