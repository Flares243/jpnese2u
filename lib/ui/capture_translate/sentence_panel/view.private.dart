part of 'view.dart';

class _DepsProvider extends StatelessWidget {
  const _DepsProvider({
    required this.sentence,
    required this.builder,
  });

  final CaptureSentenceData sentence;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final selectionCubit = SentenceSelectionCubit(sentence);

    return RepositoryProvider<CaptureSentenceData>(
      create: (_) => sentence,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SentenceSelectionCubit>.value(
            value: selectionCubit,
          ),
          BlocProvider<TokenDefinitionCubit>.value(
            value: TokenDefinitionCubit(
              sentenceData: sentence,
              selectionCubit: selectionCubit,
              service: ITokenDefinitionServ.getInstance,
            ),
          ),
        ],
        child: Builder(builder: builder),
      ),
    );
  }
}

class _HinshiFilterSegment extends StatelessWidget {
  const _HinshiFilterSegment();

  @override
  Widget build(BuildContext context) {
    final sentence = context.read<CaptureSentenceData>();
    final selectionCubit = context.read<SentenceSelectionCubit>();
    final tokensByHinshi = sentence.selectableTokens.hinshiMapping;

    return BlocBuilder<SentenceSelectionCubit, SentenceSelectionState>(
      builder: (context, selection) {
        final allSelected = selectionCubit.isAllSelected();
        final noneSelected = selectionCubit.isNoneSelected();

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
                  onSelected: (selected) {
                    if (selected) {
                      selectionCubit.selectByHinshi(hinshi);
                    } else {
                      selectionCubit.deselectByHinshi(hinshi);
                    }
                  },
                );
              }),
            _FilterSegmentChip(
              text: 'ALL',
              isSelected: allSelected,
              style: Hinshi.unknown.posStyle,
              onSelected: (selected) {
                if (selected) {
                  selectionCubit.selectAll();
                } else {
                  selectionCubit.deselectAll();
                }
              },
            ),
            _FilterSegmentChip(
              text: 'NONE',
              isSelected: noneSelected,
              style: Hinshi.unknown.posStyle,
              onSelected: (selected) {
                if (selected) {
                  selectionCubit.deselectAll();
                } else {
                  selectionCubit.selectAll();
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
      color: .resolveWith((states) => style.bg),
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
      labelPadding: const .symmetric(horizontal: 8),
      visualDensity: .compact,
    );
  }
}

class _TokenChipsSegment extends StatelessWidget {
  const _TokenChipsSegment();

  @override
  Widget build(BuildContext context) {
    final sentence = context.read<CaptureSentenceData>();
    final selectionCubit = context.read<SentenceSelectionCubit>();

    return BlocBuilder<SentenceSelectionCubit, SentenceSelectionState>(
      builder: (context, selection) => DragToSelectRegion(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sentence.tokens.map((token) {
            if (token.pos.isPunctuation) {
              return _PunctChip(token: token);
            }

            final isSelected = selection.contains(token.id);

            return Selectable(
              key: ValueKey(token.id),
              isSelected: isSelected,
              onSelectionChanged: (selected) {
                if (selected) {
                  selectionCubit.selectToken(token.id);
                } else {
                  selectionCubit.deselectToken(token.id);
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      selectionCubit.deselectToken(token.id);
                    } else {
                      selectionCubit.selectToken(token.id);
                    }
                  },
                  child: _TokenChip(
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

class _TokenChip extends StatelessWidget {
  const _TokenChip({
    required this.isSelected,
    required this.token,
  });

  final bool isSelected;
  final CaptureTokenData token;

  @override
  Widget build(BuildContext context) {
    final hinshi = Hinshi.fromJp(token.pos) ?? .unknown;
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
              letterSpacing: .7,
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

class _PunctChip extends StatelessWidget {
  const _PunctChip({required this.token});

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

class _DefinitionCard extends StatelessWidget {
  const _DefinitionCard({required this.data});

  final TokenDefinitionData data;

  @override
  Widget build(BuildContext context) {
    final heading = data.kanjiForm == data.hiraganaForm
        ? data.kanjiForm
        : '${data.kanjiForm} / ${data.hiraganaForm}';

    return Container(
      decoration: BoxDecoration(
        color: AppColor.xFFF8FAFC,
        borderRadius: .circular(12),
        border: .all(color: AppColor.xFFE4E1EB),
      ),
      padding: const .all(14),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    heading ?? '',
                    style: AppTextStyle.tokenWord.copyWith(
                      color: AppColor.xFF1B1B22,
                      fontWeight: .bold,
                      fontFamily: AppFonts.bizUDPGothic.name,
                    ),
                    maxLines: 2,
                    overflow: .ellipsis,
                  ),
                ),
              ],
            ),
            if (data.typeOfSpeech.onNull('').isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                '(${data.typeOfSpeech})',
                style: AppTextStyle.tokenReading.copyWith(
                  color: AppColor.xFF464553,
                ),
              ),
            ],
            if (data.pitch.onNull([]).isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: data.pitch!
                    .map(
                      (p) => Container(
                        padding: const .symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColor.xFFEEF2FF,
                          borderRadius: .circular(4),
                          border: .all(color: AppColor.xFFB0BEFF),
                        ),
                        child: Text(
                          p,
                          style: AppTextStyle.tokenBadge.copyWith(
                            color: AppColor.xFF312E81,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (data.definitions.onNull([]).isNotEmpty) ...[
              const Divider(height: 16),
              ...data.definitions!
                  .take(4)
                  .indexed
                  .map(
                    (entry) => Padding(
                      padding: const .only(bottom: 4),
                      child: Text(
                        '${entry.$1 + 1}.  ${entry.$2}',
                        style: AppTextStyle.tokenMeaning.copyWith(
                          color: AppColor.xFF1B1B22,
                        ),
                      ),
                    ),
                  ),
              if (data.definitions!.length > 4)
                Text(
                  '…',
                  style: AppTextStyle.tokenMeaning.copyWith(
                    color: AppColor.xFF464553,
                  ),
                ),
            ],

            if (data.alternates.onNull([]).isNotEmpty) ...[
              const Divider(height: 16),
              Text(
                'Compare with',
                style: AppTextStyle.tokenBadge.copyWith(
                  color: AppColor.xFF464553,
                  letterSpacing: .6,
                ),
              ),
              const SizedBox(height: 4),
              ...data.alternates!
                  .take(3)
                  .map(
                    (a) => Padding(
                      padding: const .only(bottom: 2),
                      child: Text(
                        a.term ?? '',
                        style: AppTextStyle.tokenReading.copyWith(
                          color: AppColor.xFF3B35A7,
                          fontFamily: AppFonts.bizUDPGothic.name,
                        ),
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DefinitionLoadingCard extends StatelessWidget {
  const _DefinitionLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.xFFF8FAFC,
        borderRadius: .circular(12),
        border: .all(color: AppColor.xFFE4E1EB),
      ),
      alignment: .center,
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

class _DefinitionErrorCard extends StatelessWidget {
  const _DefinitionErrorCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.xFFF8FAFC,
        borderRadius: .circular(12),
        border: .all(color: AppColor.xFFE4E1EB),
      ),
      padding: const .all(14),
      alignment: .center,
      child: Column(
        mainAxisSize: .min,
        spacing: 6,
        children: [
          const Icon(Icons.error_outline, color: AppColor.xFF464553, size: 20),
          Text(
            'Couldn\'t load',
            style: AppTextStyle.tokenBadge.copyWith(
              color: AppColor.xFF464553,
            ),
          ),
        ],
      ),
    );
  }
}

class _DefinitionEmptyCard extends StatelessWidget {
  const _DefinitionEmptyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.xFFF8FAFC,
        borderRadius: .circular(12),
        border: .all(color: AppColor.xFFE4E1EB),
      ),
      padding: const .all(14),
      alignment: .center,
      child: Column(
        mainAxisSize: .min,
        spacing: 6,
        children: [
          const Icon(Icons.search_off, color: AppColor.xFF464553, size: 20),
          Text(
            'No results',
            style: AppTextStyle.tokenBadge.copyWith(
              color: AppColor.xFF464553,
            ),
          ),
        ],
      ),
    );
  }
}
