import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpnese2u/service/download_serv/service.dart';
import 'package:jpnese2u/service/permission_serv/interface.dart';
import 'package:jpnese2u/service/user_session/service.dart';
import 'package:jpnese2u/ui/common/async_button.dart';
import 'package:jpnese2u/ui/common/loading_widget.dart';
import 'package:jpnese2u/ui/setting/view_model.dart';
import 'package:jpnese2u/util/app_dirent.dart';
import 'package:jpnese2u/util/extension/async_snapshot_ext.dart';
import 'package:jpnese2u/util/extension/generic_ext.dart';
import 'package:permission_handler/permission_handler.dart';

part 'view.private.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _DepsProvider(
      builder: (context) {
        final vm = context.read<SettingVM>();

        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            children: [
              BlocSelector<SettingVM, SettingState, PermissionStatus>(
                selector: (state) => state.screenRecordStatus,
                builder: (context, state) {
                  final granted = state.isGranted;

                  return InkWell(
                    onTap: () {
                      if (!granted) {
                        vm.requestScreenRecord();
                      }
                    },
                    child: Padding(
                      padding: const .symmetric(vertical: 12, horizontal: 24),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text('Screen Record Permission'),
                          ),
                          _StatusIcon(status: granted),
                        ],
                      ),
                    ),
                  );
                },
              ),
              BlocSelector<SettingVM, SettingState, AsyncSnapshot<String>>(
                selector: (state) => state.dictionaryStatus,
                builder: (context, state) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text('Sudachi Dictionary')),
                          if (state.connectionState == .waiting)
                            const Text(
                              'Do not close this window!',
                              style: TextStyle(color: Colors.red),
                            )
                          else
                            _StatusIcon(status: state.hasData),
                        ],
                      ),
                      if (!state.hasData) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: state.connectionState != .waiting
                                  ? () => vm.downloadDict()
                                  : null,
                              icon: const Icon(Icons.download),
                              label: const Text('Download'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: state.connectionState != .waiting
                                  ? () => vm.importDict()
                                  : null,
                              icon: const Icon(Icons.file_open),
                              label: const Text('Import File'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const _RenshuuApiKeyInput(),
            ],
          ),
        );
      },
    );
  }
}

class _RenshuuApiKeyInput extends StatefulWidget {
  const _RenshuuApiKeyInput();

  @override
  State<_RenshuuApiKeyInput> createState() => __RenshuuApiKeyInputState();
}

class __RenshuuApiKeyInputState extends State<_RenshuuApiKeyInput> {
  bool _successful = false;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SettingVM>();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            obscureText: true,
          ),
        ),
        const SizedBox(width: 12),
        AsyncButton(
          onPressed: () async {
            final apiKey = _controller.text.trim();
            if (apiKey.isEmpty) return;

            final snapshot = await vm.setRenshuuApiKey(apiKey);

            snapshot.fold(
              onData: (data) {
                if (!mounted || !data) return;

                _controller.clear();
                _successful = true;
                setState(() {});
              },
              onError: (error, stackTrace) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('An error occurred:\n$error'),
                    ),
                  );
                }
              },
              orElse: () {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to save API key.'),
                    ),
                  );
                }
              },
            );
          },
          builder: (context, onPressed, child) => TextButton(
            onPressed: onPressed,
            child: child,
          ),
          child: Text(
            UserSessionService.getInstance.userSession.renshuuApiKey
                    .onNull('')
                    .isEmpty
                ? 'Save'
                : 'Update',
          ),
        ),
        if (_successful) ...[
          const SizedBox(width: 12),
          const Icon(Icons.check, color: Colors.green),
        ],
      ],
    );
  }
}
