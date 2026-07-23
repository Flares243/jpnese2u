import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpnese2u/ui/common/loading_widget.dart';
import 'package:screen_capturer/screen_capturer.dart';

import 'package:jpnese2u/services/ocr_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/service.dart';
import 'package:jpnese2u/theme/app_color.dart';
import 'package:jpnese2u/theme/app_font.dart';
import 'package:jpnese2u/theme/app_text_style.dart';
import 'package:jpnese2u/ui/capture_translate/sentence_panel/sentence_panel.dart';
import 'package:jpnese2u/ui/capture_translate/view_model.dart';
import 'package:jpnese2u/ui/common/copy_region/copy_region.dart';
import 'package:jpnese2u/ui/common/copy_region/model.dart';
import 'package:jpnese2u/util/app_directories.dart';
import 'package:jpnese2u/util/extensions/build_context_ext.dart';

class _DepsProvider extends StatelessWidget {
  const _DepsProvider({
    required this.child,
    required this.capturedData,
  });

  final Widget child;
  final CapturedData capturedData;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CapturedData>(
          create: (_) => capturedData,
        ),
        RepositoryProvider<AppDirectories>(
          create: (_) => AppDirectories(),
        ),
        RepositoryProvider<IOCRService>(
          create: (_) => IOCRService(),
        ),
        RepositoryProvider<ITokenizeService>(
          create: (context) => TokenizeService(
            appDirectories: context.appDirectories,
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => CaptureTranslateVM(
          context.iOCRServ,
          context.iTokenizeServ,
        ),
        child: Builder(
          builder: (context) {
            Future<void> initialize() async {
              final appDirectories = context.appDirectories;
              final tokenizerServ = context.iTokenizeServ;
              final vm = context.read<CaptureTranslateVM>();

              await appDirectories.init();
              await tokenizerServ.init(.unidic);
              await vm.init(capturedData);
            }

            return FutureBuilder(
              future: initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != .done) {
                  return LoadingWidget();
                }

                return child;
              },
            );
          },
        ),
      ),
    );
  }
}

class CaptureTranslateScreen extends StatelessWidget {
  const CaptureTranslateScreen({
    super.key,
    required this.capturedData,
  });

  final CapturedData capturedData;

  @override
  Widget build(BuildContext context) {
    final imageBytes = capturedData.imageBytes;

    return _DepsProvider(
      capturedData: capturedData,
      child: Scaffold(
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
                      return LoadingWidget();
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
                        for (var i = 0; i < sentences.length; i++)
                          SentenceInfoPanel(sentence: sentences[i]),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CaptureImage extends StatelessWidget {
  const _CaptureImage({required this.imageBytes});

  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    final tempDir = context.appDirectories.temporaryDirectory.path;
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
