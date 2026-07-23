import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stretch_wrap/stretch_wrap.dart';

import 'package:jpnese2u/theme/app_color.dart';
import 'package:jpnese2u/theme/app_font.dart';
import 'package:jpnese2u/theme/app_text_style.dart';
import 'package:jpnese2u/ui/capture_translate/model.dart';
import 'package:jpnese2u/ui/capture_translate/sentence_panel/sentence_selection_cubit.dart';
import 'package:jpnese2u/ui/common/copy_region/copy_region.dart';
import 'package:jpnese2u/ui/common/copy_region/model.dart';
import 'package:jpnese2u/ui/common/drag_to_select.dart';
import 'package:jpnese2u/util/constant/hinshi.dart';
import 'package:jpnese2u/util/extensions/string_ext.dart';
import 'package:jpnese2u/util/functions.dart';

class _DepsProvider extends StatelessWidget {
  const _DepsProvider({
    required this.sentence,
    required this.child,
  });

  final CaptureSentenceData sentence;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => sentence,
      child: BlocProvider(
        create: (_) => SentenceSelectionCubit(sentence),
        child: child,
      ),
    );
  }
}

class SentenceInfoPanel extends StatelessWidget {
  const SentenceInfoPanel({super.key, required this.sentence});

  final CaptureSentenceData sentence;

  @override
  Widget build(BuildContext context) {
    return _DepsProvider(
      sentence: sentence,
      child: Container(
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
                    style: AppTextStyle.headline.copyWith(
                      color: AppColor.xFF1B1B22,
                      fontFamily: AppFonts.bizUDPGothic.name,
                    ),
                  ),
                ),
                CopyButton(
                  content: CopyText(
                    encodePrettyJson(sentence.toJson()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(
              color: AppColor.xFFE4E1EB,
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 16),
            _SentenceFilterSegment(),
            const SizedBox(height: 20),
            _CardsBlock(),
          ],
        ),
      ),
    );
  }
}

class _SentenceFilterSegment extends StatelessWidget {
  const _SentenceFilterSegment();

  @override
  Widget build(BuildContext context) {
    final cubit = context.sentenceSelectionCubit;
    final sentence = context.read<CaptureSentenceData>();
    final tokensByHinshi = sentence.selectableTokens.hinshiMapping;

    return BlocSelector<
      SentenceSelectionCubit,
      SentenceSelectionState,
      Set<int>
    >(
      selector: (state) => state.selection,
      builder: (context, selection) {
        final allSelected = cubit.isAllSelected();
        final noneSelected = cubit.isNoneSelected();

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (tokensByHinshi.isNotEmpty)
              ...tokensByHinshi.entries.map((entry) {
                final hinshi = entry.key;
                final tokens = entry.value;

                final style = hinshi.posStyle;
                final isSelected = selection.isTokensSelected(
                  tokens.map((e) => e.id),
                );

                return _FilterSegmentChip(
                  text: hinshi.abbreviation,
                  isSelected: isSelected,
                  style: style,
                  onSelected: (value) {
                    if (value) {
                      cubit.selectByHinshi(hinshi);
                    } else {
                      cubit.deselectByHinshi(hinshi);
                    }
                  },
                );
              }),
            _FilterSegmentChip(
              text: 'ALL',
              isSelected: allSelected,
              style: Hinshi.unknown.posStyle,
              onSelected: (value) {
                if (value) {
                  cubit.selectAll();
                } else {
                  cubit.deselectAll();
                }
              },
            ),
            _FilterSegmentChip(
              text: 'NONE',
              isSelected: noneSelected,
              style: Hinshi.unknown.posStyle,
              onSelected: (value) {
                if (value) {
                  cubit.deselectAll();
                } else {
                  cubit.selectAll();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _FilterSegmentChip extends StatelessWidget {
  const _FilterSegmentChip({
    required this.text,
    required this.isSelected,
    required this.style,
    this.onSelected,
  });

  final String text;
  final bool isSelected;
  final PosStyle style;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(text),
      labelStyle: AppTextStyle.tokenBadge.copyWith(
        color: style.headerColor,
        fontWeight: .w500,
      ),
      selected: isSelected,
      onSelected: onSelected,
      color: WidgetStateColor.resolveWith(
        (states) => style.bg,
      ),
      side: BorderSide(
        color: isSelected ? style.headerColor : style.borderColor,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: .circular(4),
      ),
      mouseCursor: SystemMouseCursors.click,
      showCheckmark: false,
      padding: .zero,
      labelPadding: .symmetric(horizontal: 8),
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
    );
  }
}

class _CardsBlock extends StatelessWidget {
  const _CardsBlock();

  @override
  Widget build(BuildContext context) {
    final cubit = context.sentenceSelectionCubit;
    final sentence = context.read<CaptureSentenceData>();

    return BlocSelector<
      SentenceSelectionCubit,
      SentenceSelectionState,
      Set<int>
    >(
      selector: (state) => state.selection,
      builder: (context, selection) => DragToSelectRegion(
        child: StretchWrap(
          spacing: 8,
          runSpacing: 8,
          crossRunAlignment: .stretch,
          children: sentence.tokens.map((token) {
            if (token.pos.isPunctuation) {
              return _PunctCard(token: token);
            }

            final isSelected = selection.contains(token.id);

            return Selectable(
              key: ValueKey(token.id),
              isSelected: isSelected,
              onSelectionChanged: (selected) {
                if (selected) {
                  cubit.selectToken(token.id);
                } else {
                  cubit.deselectToken(token.id);
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      cubit.deselectToken(token.id);
                    } else {
                      cubit.selectToken(token.id);
                    }
                  },
                  child: _TokenCard(
                    token: token,
                    isSelected: isSelected,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TokenCard extends StatelessWidget {
  const _TokenCard({
    required this.isSelected,
    required this.token,
  });

  final bool isSelected;
  final CaptureTokenData token;

  @override
  Widget build(BuildContext context) {
    final hinshi = Hinshi.fromJp(token.pos) ?? Hinshi.unknown;
    final style = hinshi.posStyle;
    final abbreviation = hinshi.abbreviation;

    return Container(
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: .circular(12),
        border: .all(
          color: isSelected ? style.headerColor : style.borderColor,
          width: isSelected ? 2 : 1,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      padding: const .symmetric(vertical: 8, horizontal: 12),
      child: Column(
        spacing: 4,
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Text(
            token.surface,
            style: AppTextStyle.tokenWord.copyWith(
              color: AppColor.xFF1B1B22,
              fontWeight: .bold,
              fontFamily: AppFonts.bizUDPGothic.name,
            ),
          ),
          Text(
            token.reading,
            style: AppTextStyle.tokenReading.copyWith(
              color: AppColor.xFF464553,
              fontFamily: AppFonts.bizUDPGothic.name,
            ),
          ),
          Text(
            abbreviation,
            style: AppTextStyle.tokenBadge.copyWith(
              color: style.headerColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _PunctCard extends StatelessWidget {
  const _PunctCard({required this.token});

  final CaptureTokenData token;

  @override
  Widget build(BuildContext context) {
    final hinshi = Hinshi.fromJp(token.pos) ?? Hinshi.unknown;
    final style = hinshi.posStyle;
    final abbreviation = hinshi.abbreviation;

    return Opacity(
      opacity: 0.7,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.xFFF0ECF6,
          borderRadius: .circular(12),
          border: .all(color: AppColor.x33C8C4D5),
        ),
        padding: const .symmetric(vertical: 8, horizontal: 12),
        child: Column(
          spacing: 4,
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text(
              token.surface,
              style: AppTextStyle.tokenWord.copyWith(
                color: AppColor.xFF1B1B22,
                fontWeight: .bold,
                fontFamily: AppFonts.bizUDPGothic.name,
              ),
            ),
            Text(
              token.reading,
              style: AppTextStyle.tokenReading.copyWith(
                color: AppColor.xFF464553,
                fontFamily: AppFonts.bizUDPGothic.name,
              ),
            ),
            Text(
              abbreviation,
              style: AppTextStyle.tokenBadge.copyWith(
                color: style.headerColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
