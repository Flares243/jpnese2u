import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stretch_wrap/stretch_wrap.dart';

import 'package:jpnese2u/domains/screenshot.dart';
import 'package:jpnese2u/services/tokenize_serv/model.dart';
import 'package:jpnese2u/theme/app_color.dart';
import 'package:jpnese2u/theme/app_text_style.dart';
import 'package:jpnese2u/ui/common/drag_to_select.dart';
import 'package:jpnese2u/ui/common/hoverable_copy.dart';
import 'package:jpnese2u/ui/windows/screenshot/model.dart';
import 'package:jpnese2u/ui/windows/screenshot/selection_cubit.dart';
import 'package:jpnese2u/util/constant/hinshi.dart';
import 'package:jpnese2u/util/extensions/build_context_ext.dart';

part 'screenshot_window.private.dart';

class ScreenshotWindow extends StatelessWidget {
  const ScreenshotWindow({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.read<ScreenshotState>();
    final imageBytes = data.captureData.imageBytes;
    final sentences = _toSentences(data.tokens);

    return BlocProvider(
      create: (_) => ScreenshotSelectionCubit(
        sentences.map((s) => s.id).toList(),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.xfffcf8ff,
          colorScheme: const .light(
            surface: AppColor.xfffcf8ff,
            primary: AppColor.xff1f108e,
          ),
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const .all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: .start,
                  children: [
                    if (imageBytes != null)
                      _ScreenshotImage(imageBytes: imageBytes),
                    SelectableText(
                      data.text ?? '',
                      style: AppTextStyle.headline.copyWith(
                        color: AppColor.xff1b1b22,
                      ),
                    ),
                    for (var i = 0; i < sentences.length; i++)
                      _SentenceGroup(sentence: sentences[i]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<SentenceGroupInfo> _toSentences(List<RawToken> tokens) {
    final groups = <SentenceGroupInfo>[];
    var buffer = <RawToken>[];

    for (final t in tokens) {
      buffer.add(t);

      if (t.surface == '。') {
        if (buffer.isNotEmpty) {
          groups.add(_makeGroup(groups.length, buffer));
          buffer = [];
        }
      }
    }

    if (buffer.isNotEmpty) groups.add(_makeGroup(groups.length, buffer));

    return groups;
  }

  SentenceGroupInfo _makeGroup(int id, List<RawToken> raw) {
    return SentenceGroupInfo(
      id: id,
      text: raw.map((t) => t.surface).join(),
      tokens: raw.indexed
          .map(
            (e) => switch (e.$2) {
              UnidicToken token => UIToken.fromUnidic(e.$1, token),
              IpadicToken token => UIToken.fromIpadic(e.$1, token),
            },
          )
          .toList(),
    );
  }
}

class _ScreenshotImage extends StatelessWidget {
  const _ScreenshotImage({
    required this.imageBytes,
  });

  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WindowController.fromCurrentEngine(),
      builder: (context, snapshot) {
        final imageWidget = ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: Image.memory(
            imageBytes,
            fit: .contain,
            width: double.infinity,
          ),
        );

        if (snapshot.connectionState != .done) {
          return imageWidget;
        }

        final tempDir = context.appDirectories.temporaryDirectory.path;
        final windowId = snapshot.data!.windowId;

        return HoverableCopyRegion(
          content: CopyFile(
            path: '$tempDir/$windowId.png',
            bytes: imageBytes,
          ),
          child: imageWidget,
        );
      },
    );
  }
}

class _SentenceGroup extends StatelessWidget {
  const _SentenceGroup({required this.sentence});

  final SentenceGroupInfo sentence;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: .circular(12),
        border: .all(color: AppColor.x1ac8c4d5),
        boxShadow: kElevationToShadow[1],
      ),
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<ScreenshotSelectionCubit, ScreenshotSelectionState>(
        builder: (context, selection) {
          final allSelected = selection.isAllSelected(
            sentence.id,
            sentence.selectableTokens.length,
          );

          return Column(
            crossAxisAlignment: .start,
            children: [
              SelectableText(
                sentence.text,
                style: AppTextStyle.headline.copyWith(
                  color: AppColor.xff1b1b22,
                ),
              ),
              SizedBox(height: 8),
              Row(
                spacing: 4,
                children: [
                  Text(
                    'Tap, Drag to select.',
                    style: AppTextStyle.tokenMeaning.copyWith(
                      color: AppColor.xff464553,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context
                        .read<ScreenshotSelectionCubit>()
                        .toggleSelectAll(
                          sentence.id,
                          sentence.selectableTokens,
                        ),
                    child: Text(allSelected ? 'Deselect all' : 'Select all'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(
                color: AppColor.xffe4e1eb,
                height: 1,
                thickness: 1,
              ),
              const SizedBox(height: 20),
              DragToSelectRegion(
                child: StretchWrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossRunAlignment: .stretch,
                  children: [
                    for (final token in sentence.tokens)
                      if (token.pos == Hinshi.auxSymbol.jp)
                        _PunctCard(token: token)
                      else
                        Selectable(
                          onSelectionChanged: (selected) {
                            if (selected) {
                              context
                                  .read<ScreenshotSelectionCubit>()
                                  .selectToken(sentence.id, token.id);
                            }
                          },
                          child: _TokenCard(
                            token: token,
                            groupId: sentence.id,
                            isSelected: selection.isSelected(
                              sentence.id,
                              token.id,
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
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
    final hinshi = Hinshi.fromJp(token.pos);
    final style = _posStyles[hinshi] ?? _posStyles[Hinshi.auxiliary]!;
    final abbreviation = hinshi?.abbreviation ?? token.pos;

    return GestureDetector(
      onTap: () => context.read<ScreenshotSelectionCubit>().toggleToken(
        groupId,
        token.id,
      ),
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
              ),
            ),
            Text(
              token.reading,
              style: AppTextStyle.tokenReading.copyWith(
                color: AppColor.xff464553,
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

class _PunctCard extends StatelessWidget {
  const _PunctCard({required this.token});

  final UIToken token;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.xfff0ecf6,
          borderRadius: .circular(8),
          border: .all(color: AppColor.x33c8c4d5),
        ),
        padding: const .symmetric(horizontal: 10, vertical: 10),
        child: Text(
          token.surface,
          style: AppTextStyle.tokenWord.copyWith(
            color: AppColor.xff1b1b22,
          ),
        ),
      ),
    );
  }
}
