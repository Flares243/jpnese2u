part of 'sentence_selection_cubit.dart';

extension BuildContextSentenceSelectionCubit on BuildContext {
  SentenceSelectionCubit get sentenceSelectionCubit =>
      read<SentenceSelectionCubit>();
}
