import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpnese2u/ui/settings/view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubic = context.read<SettingsVM>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          BlocSelector<SettingsVM, SettingsState, PermissionStatus>(
            selector: (state) => state.screenRecordStatus,
            builder: (context, state) {
              final granted = state.isGranted;

              return InkWell(
                onTap: () {
                  if (!granted) {
                    cubic.requestScreenRecord();
                  }
                },
                child: Padding(
                  padding: const .symmetric(vertical: 12, horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(child: Text('Screen Record Permission')),
                      _StatusIcon(status: granted),
                    ],
                  ),
                ),
              );
            },
          ),
          BlocSelector<SettingsVM, SettingsState, AsyncSnapshot<String>>(
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
                      Expanded(child: Text('Sudachi Dictionary')),
                      if (state.connectionState == .waiting)
                        CupertinoActivityIndicator()
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
                              ? () => cubic.downloadDict()
                              : null,
                          icon: const Icon(Icons.download),
                          label: const Text('Download'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: state.connectionState != .waiting
                              ? () => cubic.importDict()
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
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final bool status;

  @override
  Widget build(BuildContext context) {
    return status
        ? Icon(Icons.check_circle, color: Colors.green)
        : Icon(
            Icons.warning_amber_outlined,
            color: Colors.red,
          );
  }
}
