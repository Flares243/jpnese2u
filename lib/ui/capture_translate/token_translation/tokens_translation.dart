import 'package:flutter/material.dart';
import 'package:jpnese2u/theme/app_color.dart';
import 'package:jpnese2u/theme/app_font.dart';
import 'package:jpnese2u/theme/app_text_style.dart';
import 'package:jpnese2u/ui/capture_translate/model.dart';

class TokensTranslationView extends StatefulWidget {
  const TokensTranslationView({
    super.key,
    required this.tokens,
  });

  final List<CaptureTokenData> tokens;

  @override
  State<TokensTranslationView> createState() => _TokensTranslationViewState();
}

class _TokensTranslationViewState extends State<TokensTranslationView> {
  final _controller = ExpansibleController();
  bool _selectionChanged = false;

  @override
  void didUpdateWidget(covariant TokensTranslationView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.tokens != oldWidget.tokens && _selectionChanged == false) {
      _selectionChanged = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expansible(
      controller: _controller,
      headerBuilder: (context, animation) => GestureDetector(
        onTap: _controller.toggle,
        child: Row(
          spacing: 8,
          children: [
            Text(
              'Translate selections',
              style: AppTextStyle.headline.copyWith(
                color: AppColor.xFF1B1B22,
                fontFamily: AppFonts.bizUDPGothic.name,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: _selectionChanged ? () {} : null,
              icon: Icon(Icons.refresh_rounded),
            ),
            RotationTransition(
              turns: animation.drive(Tween(begin: 0.0, end: 0.5)),
              child: const Icon(Icons.expand_more_rounded),
            ),
          ],
        ),
      ),
      bodyBuilder: (context, animation) {
        return Column(
          mainAxisSize: .min,
          children: [
            Wrap(
              children: [],
            ),
          ],
        );
      },
    );
  }
}
