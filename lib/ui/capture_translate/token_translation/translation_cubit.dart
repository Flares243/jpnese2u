import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpnese2u/ui/capture_translate/model.dart';

typedef TokenTranslationState = Map<int, AsyncSnapshot<String>>;

class TokenTranslationCubit extends Cubit<TokenTranslationState> {
  TokenTranslationCubit(this._cache) : super({});

  final TokenTranslationCache _cache;
  final Renshuu

  void initialTranslation(List<CaptureTokenData> tokens) {

  }
}
