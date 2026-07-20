import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jpnese2u/ui/windows/screenshot/model.dart';

part 'selection_cubit.g.dart';

@CopyWith()
class ScreenshotSelectionState {
  const ScreenshotSelectionState({required this.selectionIds});

  final Map<int, Set<int>> selectionIds;

  bool isSelected(int groupId, int tokenId) =>
      selectionIds[groupId]?.contains(tokenId) ?? false;

  bool isAllSelected(int groupId, int groupSize) =>
      (selectionIds[groupId]?.length ?? 0) == groupSize;
}

class ScreenshotSelectionCubit extends Cubit<ScreenshotSelectionState> {
  ScreenshotSelectionCubit(List<int> groupIds)
    : super(
        ScreenshotSelectionState(
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

  void toggleSelectAll(int groupId, List<UIToken> tokens) {
    final allIds = {for (final t in tokens) t.id};
    final isAll = (state.selectionIds[groupId]?.length ?? 0) == allIds.length;

    emit(
      state.copyWith(
        selectionIds: {
          ...state.selectionIds,
          groupId: isAll ? {} : allIds,
        },
      ),
    );
  }
}
