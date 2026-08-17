import 'package:jpnese2u/ui/capture_translate/model.dart';

abstract class RawToken {
  final int tokenId;
  final String surface;

  const RawToken({
    required this.tokenId,
    required this.surface,
  });

  CaptureTokenData toCaptureTokenData();

  @override
  toString() => 'RawToken(tokenId: $tokenId, surface: $surface)';
}
