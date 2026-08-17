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

          return BlocProvider<CaptureTranslateVM>.value(
            value: vm,
            child: Builder(builder: builder),
          );
        },
      ),
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
