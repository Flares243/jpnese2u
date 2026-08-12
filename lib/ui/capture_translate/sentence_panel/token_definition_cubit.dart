import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jpnese2u/service/token_definition_serv/interface.dart';
import 'package:jpnese2u/service/token_definition_serv/model.dart';
import 'package:jpnese2u/service/tokenize_serv/model.dart';
import 'package:jpnese2u/ui/capture_translate/model.dart';
import 'package:jpnese2u/ui/capture_translate/sentence_panel/sentence_selection_cubit.dart';
import 'package:jpnese2u/util/async_guard.dart';

typedef TokenDefinitionState = Map<int, AsyncSnapshot<TokenDefinitionData?>>;

class TokenDefinitionCubit extends Cubit<TokenDefinitionState> {
  final List<RawToken> _rawTokens;
  final CaptureSentenceData _sentenceData;
  final ITokenDefinitionServ _tokenDefService;

  late final StreamSubscription<SentenceSelectionState> _selectionSub;

  List<int> _orderedSelectedIds = const [];
  List<int> get orderedSelectedIds => _orderedSelectedIds;

  TokenDefinitionCubit({
    required this._rawTokens,
    required this._sentenceData,
    required SentenceSelectionCubit selectionCubit,
    required this._tokenDefService,
  }) : super({}) {
    _selectionSub = selectionCubit.stream.listen(_onSelectionChanged);
  }

  void _onSelectionChanged(SentenceSelectionState selection) {
    _orderedSelectedIds = _sentenceData.tokens
        .where((t) => selection.contains(t.id))
        .map((t) => t.id)
        .toList();

    final toFetch = selection.where((id) => !state.containsKey(id)).toList();

    final updated = TokenDefinitionState.from(state);

    for (final id in toFetch) {
      updated[id] = const AsyncSnapshot.waiting();
    }

    emit(updated);

    for (final id in toFetch) {
      _fetchDefinition(id);
    }
  }

  Future<void> _fetchDefinition(int tokenId) async {
    final token = _rawTokens.firstWhere((t) => t.tokenId == tokenId);

    final snapshot = await asyncGuard(
      () => _tokenDefService.getDefinitionForToken(token),
    );

    if (isClosed) return;

    final updated = TokenDefinitionState.from(state);
    updated[tokenId] = snapshot;

    emit(updated);
  }

  @override
  Future<void> close() {
    _selectionSub.cancel();
    return super.close();
  }
}
