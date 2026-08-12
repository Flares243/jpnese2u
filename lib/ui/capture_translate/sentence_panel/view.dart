import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpnese2u/service/tokenize_serv/model.dart';

import 'package:jpnese2u/theme/app_color.dart';
import 'package:jpnese2u/theme/app_font.dart';
import 'package:jpnese2u/theme/app_text_style.dart';
import 'package:jpnese2u/ui/capture_translate/model.dart';
import 'package:jpnese2u/service/token_definition_serv/interface.dart';
import 'package:jpnese2u/service/token_definition_serv/model.dart';
import 'package:jpnese2u/ui/capture_translate/sentence_panel/sentence_selection_cubit.dart';
import 'package:jpnese2u/ui/capture_translate/sentence_panel/token_definition_cubit.dart';
import 'package:jpnese2u/ui/common/copy_region/copy_region.dart';
import 'package:jpnese2u/ui/common/copy_region/model.dart';
import 'package:jpnese2u/ui/common/drag_to_select.dart';
import 'package:jpnese2u/util/constant/hinshi.dart';
import 'package:jpnese2u/util/extension/async_snapshot_ext.dart';
import 'package:jpnese2u/util/extension/generic_ext.dart';
import 'package:jpnese2u/util/extension/string_ext.dart';
import 'package:jpnese2u/util/function/common.dart';

part 'view.private.dart';

class SentencePanel extends StatelessWidget {
  const SentencePanel({
    super.key,
    required this.sentence,
    required this.rawTokens,
  });

  final CaptureSentenceData sentence;
  final List<RawToken> rawTokens;

  @override
  Widget build(BuildContext context) {
    return _DepsProvider(
      sentence: sentence,
      rawTokens: rawTokens,
      builder: (context) {
        final sentence = context.read<CaptureSentenceData>();

        return Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: .circular(12),
            border: .all(color: AppColor.x1AC8C4D5),
            boxShadow: kElevationToShadow[1],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      sentence.text,
                      style: AppTextStyle.f24h32.copyWith(
                        color: AppColor.xFF1B1B22,
                        fontFamily: AppFonts.bizUDPGothic,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: "Copy JSON data.",
                    child: CopyButton(
                      content: CopyText(
                        encodePrettyJson(sentence.toJson()),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: AppColor.xFFE4E1EB, height: 32),
              const _HinshiFilterSegment(),
              const SizedBox(height: 20),
              const _TokenChipsSegment(),
              const _DefinitionsSegment(),
            ],
          ),
        );
      },
    );
  }
}

class _DefinitionsSegment extends StatelessWidget {
  const _DefinitionsSegment();

  @override
  Widget build(BuildContext context) {
    final definitionCubit = context.read<TokenDefinitionCubit>();
    final sentence = context.read<CaptureSentenceData>();

    return BlocBuilder<TokenDefinitionCubit, TokenDefinitionState>(
      builder: (context, defState) {
        final orderedIds = definitionCubit.orderedSelectedIds;
        final hasCard = defState.values.any((e) => e.connectionState != .none);

        if (orderedIds.isEmpty || !hasCard) return const SizedBox.shrink();

        return Column(
          mainAxisSize: .min,
          children: [
            const Divider(color: AppColor.xFFE4E1EB, height: 32),
            SizedBox(
              height: 300.0,
              child: ListView(
                scrollDirection: .horizontal,
                children: orderedIds
                    .map((id) {
                      final snapshot = defState[id].onNull(const .nothing());
                      final token = sentence.tokens.firstWhere(
                        (t) => t.id == id,
                      );
                      final hinshi = Hinshi.fromJp(token.pos) ?? .unknown;
                      final posStyle = hinshi.posStyle;

                      final cardWidget = snapshot.foldOrNull(
                        onData: (data) => _DefinitionCard(
                          data: data!,
                          hinshi: hinshi,
                        ),
                        onWaiting: () =>
                            _DefinitionLoadingCard(style: posStyle),
                        onError: (_, _) =>
                            _DefinitionErrorCard(style: posStyle),
                      );

                      if (cardWidget != null) {
                        return Padding(
                          padding: const .symmetric(horizontal: 4),
                          child: SizedBox(
                            width: 280.0,
                            child: cardWidget,
                          ),
                        );
                      }
                    })
                    .nonNulls
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
