part of 'view.dart';

class _DepsProvider extends StatelessWidget {
  const _DepsProvider({
    required this.capturedData,
    required this.windowController,
    required this.builder,
  });

  final CapturedData capturedData;
  final WindowController windowController;
  final WidgetBuilder builder;

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
            return const Scaffold(body: LoadingWidget());
          }

          return BlocProvider.value(
            value: vm,
            child: Builder(builder: builder),
          );
        },
      ),
    );
  }
}
