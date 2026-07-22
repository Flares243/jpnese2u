import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jpnese2u/models/capture_info.dart';
import 'package:jpnese2u/services/tokenize_serv/model.dart';
import 'package:jpnese2u/theme/app_color.dart';
import 'package:jpnese2u/theme/app_font.dart';
import 'package:jpnese2u/theme/app_text_style.dart';
import 'package:jpnese2u/ui/capture_info/model.dart';
import 'package:jpnese2u/ui/capture_info/sentence_panel.dart';
import 'package:jpnese2u/ui/capture_info/sentence_selection_cubit.dart';
import 'package:jpnese2u/ui/common/copy_region/copy_region.dart';
import 'package:jpnese2u/ui/common/copy_region/model.dart';
import 'package:jpnese2u/util/extensions/build_context_ext.dart';

class CaptureInfoScreen extends StatelessWidget {
  const CaptureInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.read<CaptureInfo>();
    final imageBytes = data.data.imageBytes;
    final sentences = _toSentences(data.tokens);

    return BlocProvider(
      create: (_) => SentenceSelectionCubit(
        sentences.map((s) => s.id).toList(),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const .all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                spacing: 16,
                crossAxisAlignment: .start,
                children: [
                  if (imageBytes != null) _CaptureImage(imageBytes: imageBytes),
                  SelectableText(
                    data.text ?? '',
                    style: AppTextStyle.headline.copyWith(
                      color: AppColor.xff1b1b22,
                      fontFamily: AppFonts.bizUDPGothic.name,
                    ),
                  ),
                  for (var i = 0; i < sentences.length; i++)
                    SentencePanel(
                      sentence: sentences[i],
                      selectionCubit: context.sentenceSelectionCubit,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<SentenceInfo> _toSentences(List<RawToken> tokens) {
    final groups = <SentenceInfo>[];
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

  SentenceInfo _makeGroup(int id, List<RawToken> raw) {
    return SentenceInfo(
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

class _CaptureImage extends StatelessWidget {
  const _CaptureImage({required this.imageBytes});

  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WindowController.fromCurrentEngine(),
      builder: (context, snapshot) {
        final windowId = snapshot.data?.windowId;

        final imageWidget = ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: Image.memory(
            imageBytes,
            fit: .contain,
            width: double.infinity,
          ),
        );

        if (snapshot.connectionState != .done || windowId == null) {
          return imageWidget;
        }

        final tempDir = context.appDirectories.temporaryDirectory.path;

        return CopyRegion(
          content: CopyFile(
            path: '$tempDir/$windowId.png',
            bytes: imageBytes,
          ),
          copyButtonTooltip: "Copy image to clipboard",
          child: imageWidget,
        );
      },
    );
  }
}
