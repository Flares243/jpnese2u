import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpnese2u/config/dart_define.dart';
import 'package:jpnese2u/services/download_serv/service.dart';
import 'package:jpnese2u/services/permission_serv/interface.dart';
import 'package:jpnese2u/services/tokenize_serv/sudachi/addons.dart';
import 'package:jpnese2u/util/app_dirents.dart';
import 'package:jpnese2u/util/async_guard.dart';
import 'package:jpnese2u/util/constant/file_extension.dart';
import 'package:jpnese2u/util/extensions/async_snapshot_ext.dart';
import 'package:jpnese2u/util/ignored_exception.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sudachi_dart/sudachi_dart.dart';

part 'view_model.mapper.dart';

@MappableClass()
class SettingsState with SettingsStateMappable {
  final PermissionStatus screenRecordStatus;
  final AsyncSnapshot<String> dictionaryStatus;

  const SettingsState({
    required this.screenRecordStatus,
    required this.dictionaryStatus,
  });
}

class SettingsVM extends Cubit<SettingsState> {
  final AppDirents appDirents;
  final IPermissionServ permissionServ;
  final DownloaderServ downloaderServ;

  SettingsVM({
    required this.appDirents,
    required this.permissionServ,
    required this.downloaderServ,
  }) : super(
         const SettingsState(
           screenRecordStatus: .denied,
           dictionaryStatus: .nothing(),
         ),
       );

  Future<void> init() async {
    final screenRecordStatus = await permissionServ.checkScreenRecord();
    var newState = state.copyWith(
      screenRecordStatus: screenRecordStatus,
    );

    final dictionaryFile = appDirents.sudachiDictionaryFile;
    if (await dictionaryFile.exists()) {
      newState = newState.copyWith(
        dictionaryStatus: .withData(.done, dictionaryFile.path),
      );
    }

    emit(newState);
  }

  Future<void> requestScreenRecord() async {
    final status = await permissionServ.requestScreenRecord();
    emit(state.copyWith(screenRecordStatus: status));
  }

  Future<void> downloadDict() async {
    final result = await asyncGuard(
      () async {
        emit(state.copyWith(dictionaryStatus: .waiting()));

        final snapshot = await downloaderServ.downloadFile(
          url: DartDefine.sudachiDictFullUrl,
        );

        final file = snapshot.data;
        if (file == null) throw Exception('Failed to download dictionary file');

        final bytes = await file.readAsBytes();
        final archive = ZipDecoder().decodeBytes(bytes);
        final dictionaryFile = appDirents.sudachiDictionaryFile;

        for (final entry in archive) {
          if (entry.isFile && FileExt.dic.isMatch(entry.name)) {
            final fileBytes = entry.readBytes();
            if (fileBytes == null) continue;

            await dictionaryFile.writeAsBytes(fileBytes, flush: true);

            break;
          }
        }

        file.deleteSync();

        return dictionaryFile.path;
      },
    );

    result.fold(
      onData: (data) {
        emit(
          state.copyWith(
            dictionaryStatus: .withData(.done, data),
          ),
        );
      },
      orElse: () {
        emit(
          state.copyWith(
            dictionaryStatus: .nothing(),
          ),
        );
      },
    );
  }

  Future<void> importDict() async {
    final result = await asyncGuard(
      () async {
        emit(state.copyWith(dictionaryStatus: .waiting()));

        final selectedFile = await FilePicker.pickFiles(
          type: .custom,
          allowedExtensions: [FileExt.dic.value],
        );

        if (selectedFile == null) throw IgnoredException('No file selected');

        final filePath = selectedFile.files.single.path!;
        final isValid = await SudachiDictionary.validateFile(filePath);

        if (!isValid) throw Exception('Invalid dictionary file');

        final dictionaryFile = appDirents.sudachiDictionaryFile;

        await File(filePath).copy(dictionaryFile.path);

        return dictionaryFile.path;
      },
    );

    result.fold(
      onData: (data) {
        emit(
          state.copyWith(
            dictionaryStatus: .withData(.done, data),
          ),
        );
      },
      orElse: () {
        emit(
          state.copyWith(
            dictionaryStatus: .nothing(),
          ),
        );
      },
    );
  }
}
