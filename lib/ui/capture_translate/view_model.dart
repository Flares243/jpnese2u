import 'package:flutter/widgets.dart';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpnese2u/util/extension/string_ext.dart';
import 'package:screen_capturer/screen_capturer.dart';

import 'package:jpnese2u/service/ocr_serv/interface.dart';
import 'package:jpnese2u/service/tokenize_serv/interface.dart';
import 'package:jpnese2u/service/tokenize_serv/model.dart';
import 'package:jpnese2u/ui/capture_translate/model.dart';
import 'package:jpnese2u/util/extension/raw_tokens_ext.dart';

part 'view_model.g.dart';

@CopyWith()
class CaptureTranslateState {
  const CaptureTranslateState({
    required this.info,
  });

  final AsyncSnapshot<CaptureInfo> info;
}

class CaptureTranslateVM extends Cubit<CaptureTranslateState> {
  final IOCRService _ocrServ;
  final ITokenizeServ _tokenizeServ;

  CaptureTranslateVM({
    required this._ocrServ,
    required this._tokenizeServ,
  }) : super(const CaptureTranslateState(info: .waiting()));

  Future<void> init(CapturedData capturedData) async {
    String? text;
    List<RawToken> tokens = [];

    final imageBytes = capturedData.imageBytes;

    if (imageBytes != null) {
      text = await _ocrServ.textFromBytes(imageBytes);
    }

    if (text != null) {
      tokens = await _tokenizeServ.tokenize(text.removeNewLines());
    }

    final sentences = tokens.toSentences();

    emit(
      state.copyWith(
        info: .withData(
          .done,
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
