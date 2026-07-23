import 'package:flutter/widgets.dart';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_capturer/screen_capturer.dart';

import 'package:jpnese2u/services/ocr_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/model.dart';
import 'package:jpnese2u/ui/capture_translate/model.dart';
import 'package:jpnese2u/util/extensions/raw_tokens_ext.dart';

part 'view_model.g.dart';

@CopyWith()
class CaptureTranslateState {
  const CaptureTranslateState({
    required this.info,
  });

  final AsyncSnapshot<CaptureInfo> info;
}

class CaptureTranslateVM extends Cubit<CaptureTranslateState> {
  CaptureTranslateVM(this._ocrServ, this._tokenizeServ)
    : super(
        CaptureTranslateState(info: AsyncSnapshot.waiting()),
      );

  final IOCRService _ocrServ;
  final ITokenizeService _tokenizeServ;

  Future<void> init(CapturedData capturedData) async {
    String? text;
    List<RawToken> tokens = [];

    final imageBytes = capturedData.imageBytes;

    if (imageBytes != null) {
      text = await _ocrServ.textFromBytes(imageBytes);
    }

    if (text != null) {
      tokens = await _tokenizeServ.tokenize(text);
      if (tokens.isNotEmpty) tokens.removeLast();
    }

    final sentences = tokens.toSentences();

    emit(
      state.copyWith(
        info: AsyncSnapshot.withData(
          ConnectionState.done,
          CaptureInfo(
            text: text,
            tokens: tokens,
            sentences: sentences,
          ),
        ),
      ),
    );
  }
}

extension BuildContextCaptureTranslateVM on BuildContext {
  CaptureTranslateVM get captureTranslateVM => read<CaptureTranslateVM>();
}
