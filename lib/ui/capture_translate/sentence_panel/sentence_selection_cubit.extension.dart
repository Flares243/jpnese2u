part of 'sentence_selection_cubit.dart';

extension BuildContextSentenceSelectionCubit on BuildContext {
  SentenceSelectionCubit get sentenceSelectionCubit =>
      read<SentenceSelectionCubit>();
}

extension SentenceSelectionStateExtension on SentenceSelectionState {
  bool isTokensSelected(Iterable<int> tokenIds) =>
      tokenIds.every((id) => contains(id));
}
