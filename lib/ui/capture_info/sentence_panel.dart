import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stretch_wrap/stretch_wrap.dart';

import 'package:jpnese2u/theme/app_color.dart';
import 'package:jpnese2u/theme/app_font.dart';
import 'package:jpnese2u/theme/app_text_style.dart';
import 'package:jpnese2u/ui/capture_info/model.dart';
import 'package:jpnese2u/ui/capture_info/sentence_selection_cubit.dart';
import 'package:jpnese2u/ui/common/copy_region/copy_region.dart';
import 'package:jpnese2u/ui/common/copy_region/model.dart';
import 'package:jpnese2u/ui/common/drag_to_select.dart';
import 'package:jpnese2u/util/constant/hinshi.dart';
import 'package:jpnese2u/util/extensions/string_ext.dart';
import 'package:jpnese2u/util/functions.dart';

class SentencePanel extends StatelessWidget {
  const SentencePanel({
    super.key,
    required this.sentence,
    required this.selectionCubit,
  });

  final SentenceInfo sentence;
  final SentenceSelectionCubit selectionCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => selectionCubit,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: .circular(12),
          border: .all(color: AppColor.x1ac8c4d5),
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
                      color: AppColor.xff1b1b22,
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
              color: AppColor.xffe4e1eb,
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 16),
            _SentenceFilterSegment(sentence: sentence),
            const SizedBox(height: 20),
            BlocBuilder<SentenceSelectionCubit, SentenceSelectionState>(
              builder: (context, selection) => DragToSelectRegion(
                child: StretchWrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossRunAlignment: .stretch,
                  children: sentence.tokens.map((token) {
                    if (token.pos.isPunctuation) {
                      return _PunctCard(token: token);
                    }

                    return Selectable(
                      key: ValueKey(token.id),
                      onSelectionChanged: (selected) {
                        if (selected) {
                          context.sentenceSelectionCubit.selectToken(
                            sentence.id,
                            token.id,
                          );
                        } else {
                          context.sentenceSelectionCubit.deselectToken(
                            sentence.id,
                            token.id,
                          );
                        }
                      },
                      child: _TokenCard(
                        token: token,
                        groupId: sentence.id,
                        isSelected: selection.isTokenSelected(
                          sentence.id,
                          token.id,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SentenceFilterSegment extends StatelessWidget {
  const _SentenceFilterSegment({required this.sentence});

  final SentenceInfo sentence;

  @override
  Widget build(BuildContext context) {
    final tokensByHinshi = sentence.tokensByHinshi;

    return BlocBuilder<SentenceSelectionCubit, SentenceSelectionState>(
      builder: (context, selection) {
        final allSelected = selection.isSentenceSelected(
          sentence.id,
          sentence.selectableTokens.length,
        );

        final noneSelected = selection.sentences[sentence.id]?.isEmpty ?? false;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (tokensByHinshi.isNotEmpty) ...[
              ...tokensByHinshi.entries.map((entry) {
                final hinshi = entry.key;
                final tokens = entry.value;

                final style = hinshi.posStyle;
                final isSelected =
                    selection.sentences[sentence.id]?.containsAll(
                      tokens.map((t) => t.id),
                    ) ??
                    false;

                return _FilterSegmentChip(
                  text: hinshi.abbreviation,
                  isSelected: isSelected,
                  style: style,
                  onSelected: (value) {
                    if (value) {
                      context.sentenceSelectionCubit.selectByHinshi(
                        sentence.id,
                        sentence.selectableTokens,
                        hinshi,
                      );
                    } else {
                      context.sentenceSelectionCubit.deselectByHinshi(
                        sentence.id,
                        sentence.selectableTokens,
                        hinshi,
                      );
                    }
                  },
                );
              }),
            ],
            _FilterSegmentChip(
              text: 'ALL',
              isSelected: allSelected,
              style: Hinshi.unknown.posStyle,
              onSelected: (value) {
                if (value) {
                  context.sentenceSelectionCubit.selectAll(
                    sentence.id,
                    sentence.selectableTokens,
                  );
                }
              },
            ),
            _FilterSegmentChip(
              text: 'NONE',
              isSelected: noneSelected,
              style: Hinshi.unknown.posStyle,
              onSelected: (value) {
                if (value) {
                  context.sentenceSelectionCubit.deselectAll(sentence.id);
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

class _TokenCard extends StatelessWidget {
  const _TokenCard({
    required this.groupId,
    required this.token,
    required this.isSelected,
  });

  final int groupId;
  final UIToken token;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final hinshi = Hinshi.fromJp(token.pos) ?? Hinshi.unknown;
    final style = hinshi.posStyle;
    final abbreviation = hinshi.abbreviation;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (isSelected) {
            context.sentenceSelectionCubit.deselectToken(groupId, token.id);
          } else {
            context.sentenceSelectionCubit.selectToken(groupId, token.id);
          }
        },
        child: Container(
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
                  color: AppColor.xff1b1b22,
                  fontWeight: .bold,
                  fontFamily: AppFonts.bizUDPGothic.name,
                ),
              ),
              Text(
                token.reading,
                style: AppTextStyle.tokenReading.copyWith(
                  color: AppColor.xff464553,
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
      ),
    );
  }
}

class _PunctCard extends StatelessWidget {
  const _PunctCard({required this.token});

  final UIToken token;

  @override
  Widget build(BuildContext context) {
    final hinshi = Hinshi.fromJp(token.pos) ?? Hinshi.unknown;
    final style = hinshi.posStyle;
    final abbreviation = hinshi.abbreviation;

    return Opacity(
      opacity: 0.7,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.xfff0ecf6,
          borderRadius: .circular(12),
          border: .all(color: AppColor.x33c8c4d5),
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
                color: AppColor.xff1b1b22,
                fontWeight: .bold,
                fontFamily: AppFonts.bizUDPGothic.name,
              ),
            ),
            Text(
              token.reading,
              style: AppTextStyle.tokenReading.copyWith(
                color: AppColor.xff464553,
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
