part of 'view.dart';

class _DepsProvider extends StatelessWidget {
  const _DepsProvider({
    required this.sentence,
    required this.rawTokens,
    required this.builder,
  });

  final CaptureSentenceData sentence;
  final List<RawToken> rawTokens;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final selectionCubit = SentenceSelectionCubit(sentence);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CaptureSentenceData>.value(value: sentence),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SentenceSelectionCubit>.value(value: selectionCubit),
          BlocProvider<TokenDefinitionCubit>.value(
            value: TokenDefinitionCubit(
              sentenceData: sentence,
              rawTokens: rawTokens,
              selectionCubit: selectionCubit,
              tokenDefService: ITokenDefinitionServ.getInstance,
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
      labelStyle: AppTextStyle.f11h14.copyWith(
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
        spacing: 6,
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Text(
            token.surface,
            style: AppTextStyle.f20h30.copyWith(
              color: AppColor.xFF1B1B22,
              fontWeight: .w600,
              fontFamily: AppFonts.bizUDPGothic,
            ),
          ),
          Text(
            token.reading,
            style: AppTextStyle.f18h27.copyWith(
              color: AppColor.xFF464553,
              fontFamily: AppFonts.bizUDPGothic,
              letterSpacing: .7,
            ),
          ),
          Text(
            abbreviation,
            style: AppTextStyle.f11h14.copyWith(
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
          spacing: 6,
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text(
              token.surface,
              style: AppTextStyle.f20h30.copyWith(
                color: AppColor.xFF1B1B22,
                fontWeight: .w600,
                fontFamily: AppFonts.bizUDPGothic,
              ),
            ),
            Text(
              abbreviation,
              style: AppTextStyle.f11h14.copyWith(
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
  const _DefinitionCard({required this.data, required this.hinshi});

  final TokenDefinitionData data;
  final Hinshi hinshi;

  @override
  Widget build(BuildContext context) {
    final style = hinshi.posStyle;
    final heading = data.kanji.onNull('').isEmpty
        ? data.hiragana
        : '${data.kanji} / ${data.hiragana}';

    return Container(
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: .circular(12),
        border: .all(color: style.borderColor),
      ),
      padding: const .all(14),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              spacing: 2,
              crossAxisAlignment: .start,
              children: [
                Expanded(
                  child: SelectableText(
                    heading ?? '',
                    style: AppTextStyle.f20h30.copyWith(
                      color: AppColor.xFF1B1B22,
                      fontWeight: .w600,
                      fontFamily: AppFonts.bizUDPGothic,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const .symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: hinshi.posStyle.bg,
                    borderRadius: .circular(4),
                    border: .all(color: hinshi.posStyle.borderColor),
                  ),
                  child: Text(
                    hinshi.abbreviation,
                    style: AppTextStyle.f11h14.copyWith(
                      color: hinshi.posStyle.headerColor,
                    ),
                  ),
                ),
              ],
            ),
            if (data.definitions.onNull([]).isNotEmpty) ...[
              const SizedBox(height: 12),
              ...data.definitions!.map(
                (e) => SelectableText(
                  '- $e',
                  style: AppTextStyle.f14h21.copyWith(
                    color: AppColor.xFF1B1B22,
                  ),
                ),
              ),
            ],
            if (data.alternates.onNull([]).isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Also written as:'),
              const SizedBox(height: 4),
              Padding(
                padding: const .only(bottom: 2),
                child: SelectableText(
                  data.alternates!.map((e) => e.term).join(' / '),
                  style: AppTextStyle.f14h21,
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
  const _DefinitionLoadingCard({required this.style});

  final PosStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: .circular(12),
        border: .all(color: style.borderColor),
      ),
      alignment: .center,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: style.headerColor,
      ),
    );
  }
}

class _DefinitionErrorCard extends StatelessWidget {
  const _DefinitionErrorCard({required this.style});

  final PosStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: .circular(12),
        border: .all(color: style.borderColor),
      ),
      padding: const .all(14),
      alignment: .center,
      child: Column(
        mainAxisSize: .min,
        spacing: 6,
        children: [
          Icon(Icons.error_outline, color: style.headerColor, size: 20),
          Text(
            'An error occurred.',
            style: AppTextStyle.f14h21.copyWith(
              color: style.headerColor,
            ),
          ),
        ],
      ),
    );
  }
}
