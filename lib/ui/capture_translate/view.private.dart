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

          return MultiBlocProvider(
            providers: [
              BlocProvider<CaptureTranslateVM>.value(value: vm),
              BlocProvider<DefinitionDrawerCubit>(
                create: (_) => DefinitionDrawerCubit(),
              ),
            ],
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

class _DefinitionListDrawer extends StatelessWidget {
  const _DefinitionListDrawer();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return BlocBuilder<DefinitionDrawerCubit, DefinitionDrawerState>(
      builder: (context, state) {
        final count = state.definitions.length;

        return Drawer(
          width: screenWidth * 2 / 3,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: const .symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        '$count result${count == 1 ? '' : 's'}',
                        style: AppTextStyle.f14h21.copyWith(
                          color: AppColor.xFF464553,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        visualDensity: .compact,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (count > 0)
                  Expanded(
                    child: ListView.separated(
                      padding: const .all(12),
                      itemCount: count,
                      itemBuilder: (context, index) => DefinitionCard(
                        data: state.definitions[index],
                        hinshi: state.hinshi,
                      ),
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
