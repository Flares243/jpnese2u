import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jpnese2u/ui/windows/capture_info/model.dart';

part 'sentence_selection_cubit.g.dart';

@CopyWith()
class SentenceSelectionState {
  const SentenceSelectionState({required this.selectionIds});

  final Map<int, Set<int>> selectionIds;

  bool isSelected(int groupId, int tokenId) =>
      selectionIds[groupId]?.contains(tokenId) ?? false;

  bool isAllSelected(int groupId, int groupSize) =>
      (selectionIds[groupId]?.length ?? 0) == groupSize;
}

class SentenceSelectionCubit extends Cubit<SentenceSelectionState> {
  SentenceSelectionCubit(List<int> groupIds)
    : super(
        SentenceSelectionState(
          selectionIds: {for (final id in groupIds) id: {}},
        ),
      );

  void toggleToken(int groupId, int tokenId) {
    final current = Set<int>.of(state.selectionIds[groupId] ?? {});

    if (!current.remove(tokenId)) current.add(tokenId);

    emit(
      state.copyWith(
        selectionIds: {
          ...state.selectionIds,
          groupId: current,
        },
      ),
    );
  }

  void selectToken(int groupId, int tokenId) {
    final current = Set<int>.of(state.selectionIds[groupId] ?? {});

    if (current.contains(tokenId)) return;

    current.add(tokenId);

    emit(
      state.copyWith(
        selectionIds: {...state.selectionIds, groupId: current},
      ),
    );
  }

  void selectAll(int groupId, List<UIToken> tokens) {
    final allIds = {for (final t in tokens) t.id};

    emit(
      state.copyWith(
        selectionIds: {
          ...state.selectionIds,
          groupId: allIds,
        },
      ),
    );
  }

  void deselectAll(int groupId) {
    emit(
      state.copyWith(
        selectionIds: {
          ...state.selectionIds,
          groupId: {},
        },
      ),
    );
  }
}
