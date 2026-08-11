import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpnese2u/service/ocr_serv/interface.dart';
import 'package:jpnese2u/service/tokenize_serv/interface.dart';
import 'package:jpnese2u/ui/common/loading_widget.dart';
import 'package:jpnese2u/util/app_dirent.dart';
import 'package:screen_capturer/screen_capturer.dart';

import 'package:jpnese2u/theme/app_color.dart';
import 'package:jpnese2u/theme/app_font.dart';
import 'package:jpnese2u/theme/app_text_style.dart';
import 'package:jpnese2u/ui/capture_translate/sentence_panel/view.dart';
import 'package:jpnese2u/ui/capture_translate/view_model.dart';
import 'package:jpnese2u/ui/common/copy_region/copy_region.dart';
import 'package:jpnese2u/ui/common/copy_region/model.dart';

part 'view.private.dart';

class CaptureTranslateScreen extends StatelessWidget {
  const CaptureTranslateScreen({
    super.key,
    required this.capturedData,
    required this.windowController,
  });

  final CapturedData capturedData;
  final WindowController windowController;

  @override
  Widget build(BuildContext context) {
    return _DepsProvider(
      capturedData: capturedData,
      windowController: windowController,
      builder: (context) {
        final imageBytes = capturedData.imageBytes;

        return Scaffold(
          body: SingleChildScrollView(
            padding: const .all(20),
            child: Center(
              child: Column(
                spacing: 16,
                crossAxisAlignment: .start,
                children: [
                  if (imageBytes != null) _CaptureImage(imageBytes: imageBytes),
                  BlocBuilder<CaptureTranslateVM, CaptureTranslateState>(
                    builder: (context, state) {
                      final infoSnapshot = state.info;

                      if (infoSnapshot.connectionState != .done) {
                        return const LoadingWidget();
                      }

                      final info = infoSnapshot.data;

                      if (info == null) {
                        return Center(
                          child: Text(
                            "Error occurred while processing the captured image.",
                            style: AppTextStyle.headline,
                          ),
                        );
                      }

                      final sentences = info.sentences;

                      return Column(
                        spacing: 12,
                        crossAxisAlignment: .start,
                        children: [
                          SelectableText(
                            info.text ?? '',
                            style: AppTextStyle.headline.copyWith(
                              color: AppColor.xFF1B1B22,
                              fontFamily: AppFonts.bizUDPGothic.name,
                            ),
                          ),
                          for (var i = 0; i < sentences.length; i++) ...[
                            SentencePanel(sentence: sentences[i]),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CaptureImage extends StatelessWidget {
  const _CaptureImage({required this.imageBytes});

  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    final tempDir = AppDirent.getInstance;
    final windowId = context.read<WindowController>().windowId;
    final path = "$tempDir/capture_translate_$windowId.png";

    return CopyRegion(
      content: CopyFile(
        path: path,
        bytes: imageBytes,
      ),
      copyButtonTooltip: "Copy image to clipboard",
      child: Image.memory(
        imageBytes,
        fit: .contain,
      ),
    );
  }
}
