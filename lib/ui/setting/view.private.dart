part of 'view.dart';

class _DepsProvider extends StatelessWidget {
  const _DepsProvider({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final settingsCubit = SettingVM(
      appDirents: AppDirent.getInstance,
      permissionServ: IPermissionServ.getInstance,
      downloaderServ: DownloaderServ.getInstance,
      userSessionService: UserSessionService.getInstance,
    );

    return FutureBuilder(
      future: settingsCubit.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != .done) {
          return const Scaffold(body: LoadingWidget());
        }

        return BlocProvider<SettingVM>.value(
          value: settingsCubit,
          child: Builder(builder: builder),
        );
      },
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final bool status;

  @override
  Widget build(BuildContext context) {
    return status
        ? const Icon(Icons.check_circle, color: Colors.green)
        : const Icon(
            Icons.warning_amber_outlined,
            color: Colors.red,
          );
  }
}
