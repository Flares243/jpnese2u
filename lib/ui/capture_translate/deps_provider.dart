import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpnese2u/services/ocr_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/interface.dart';
import 'package:jpnese2u/ui/capture_translate/view_model.dart';
import 'package:jpnese2u/ui/common/loading_widget.dart';
import 'package:screen_capturer/screen_capturer.dart';

class CaptureTranslateDepsProvider extends StatelessWidget {
  const CaptureTranslateDepsProvider({
    required this.capturedData,
    required this.windowController,
    required this.child,
    super.key,
  });

  final CapturedData capturedData;
  final WindowController windowController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final vm = CaptureTranslateVM(
      ocrServ: IOCRService.getInstance,
      tokenizeServ: ITokenizeServ.getInstance,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CapturedData>.value(value: capturedData),
        RepositoryProvider<WindowController>.value(value: windowController),
      ],
      child: FutureBuilder(
        future: vm.init(capturedData),
        builder: (context, snapshot) {
          if (snapshot.connectionState != .done) {
            return Scaffold(body: LoadingWidget());
          }

          return BlocProvider.value(
            value: vm,
            child: child,
          );
        },
      ),
    );
  }
}
