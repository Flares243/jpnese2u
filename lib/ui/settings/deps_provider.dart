import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpnese2u/services/download_serv/service.dart';
import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/ui/common/loading_widget.dart';
import 'package:jpnese2u/ui/settings/view_model.dart';
import 'package:jpnese2u/util/app_dirents.dart';

class SettingsDepsProvider extends StatelessWidget {
  const SettingsDepsProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final settingsCubit = SettingsVM(
      appDirents: AppDirents.getInstance,
      permissionServ: IPermissionServ.getInstance,
      downloaderServ: DownloaderServ.getInstance,
    );

    return FutureBuilder(
      future: settingsCubit.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != .done) {
          return const Scaffold(body: LoadingWidget());
        }

        return BlocProvider<SettingsVM>.value(
          value: settingsCubit,
          child: child,
        );
      },
    );
  }
}
