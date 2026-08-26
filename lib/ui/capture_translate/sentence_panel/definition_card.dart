import 'package:flutter/material.dart';
import 'package:jpnese2u/service/token_definition_serv/model.dart';
import 'package:jpnese2u/theme/app_color.dart';
import 'package:jpnese2u/theme/app_font.dart';
import 'package:jpnese2u/theme/app_text_style.dart';
import 'package:jpnese2u/util/constant/hinshi.dart';
import 'package:jpnese2u/util/extension/generic_ext.dart';

class DefinitionCard extends StatelessWidget {
  const DefinitionCard({
    super.key,
    required this.data,
    required this.hinshi,
    this.onShowMorePressed,
  });

  final TokenDefinitionData data;
  final Hinshi hinshi;
  final VoidCallback? onShowMorePressed;

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
      padding: onShowMorePressed != null
          ? const .only(left: 14, top: 14, bottom: 14)
          : const .all(14),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: .start,
          children: [
            Expanded(
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
            ),
            if (onShowMorePressed != null)
              SizedBox(
                width: 40,
                height: .infinity,
                child: IconButton(
                  onPressed: onShowMorePressed,
                  icon: const Icon(Icons.keyboard_double_arrow_right),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
