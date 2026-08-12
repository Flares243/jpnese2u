import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jpnese2u/config/dart_define.dart';
import 'package:jpnese2u/service/download_serv/service.dart';
import 'package:jpnese2u/service/permission_serv/interface.dart';
import 'package:jpnese2u/service/tokenize_serv/sudachi/addons.dart';
import 'package:jpnese2u/service/user_session/service.dart';
import 'package:jpnese2u/util/app_dirent.dart';
import 'package:jpnese2u/util/async_guard.dart';
import 'package:jpnese2u/util/constant/file_extension.dart';
import 'package:jpnese2u/util/extension/async_snapshot_ext.dart';
import 'package:jpnese2u/util/function/validate_renshuu_api_key.dart';
import 'package:jpnese2u/util/ignored_exception.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sudachi_dart/sudachi_dart.dart';

part 'view_model.mapper.dart';

@MappableClass()
class SettingState with SettingStateMappable {
  final PermissionStatus screenRecordStatus;
  final AsyncSnapshot<String> dictionaryStatus;

  const SettingState({
    required this.screenRecordStatus,
    required this.dictionaryStatus,
  });
}

class SettingVM extends Cubit<SettingState> {
  final AppDirent _appDirents;
  final IPermissionServ _permissionServ;
  final DownloaderServ _downloaderServ;
  final UserSessionService _userSessionService;

  SettingVM({
    required this._appDirents,
    required this._permissionServ,
    required this._downloaderServ,
    required this._userSessionService,
  }) : super(
         const SettingState(
           screenRecordStatus: .denied,
           dictionaryStatus: .nothing(),
         ),
       );

  Future<void> init() async {
    final screenRecordStatus = await _permissionServ.checkScreenRecord();
    var newState = state.copyWith(
      screenRecordStatus: screenRecordStatus,
    );

    final dictionaryFile = _appDirents.sudachiDictionaryFile;
    if (await dictionaryFile.exists()) {
      newState = newState.copyWith(
        dictionaryStatus: .withData(.done, dictionaryFile.path),
      );
    }

    emit(newState);
  }

  Future<void> requestScreenRecord() async {
    final status = await _permissionServ.requestScreenRecord();
    emit(state.copyWith(screenRecordStatus: status));
  }

  Future<void> downloadDict() async {
    final result = await asyncGuard(
      () async {
        emit(state.copyWith(dictionaryStatus: const .waiting()));

        final snapshot = await _downloaderServ.downloadFile(
          url: DartDefine.sudachiDictFullUrl,
        );

        final file = snapshot.data;
        if (file == null) throw Exception('Failed to download dictionary file');

        final bytes = await file.readAsBytes();
        final archive = ZipDecoder().decodeBytes(bytes);
        final dictionaryFile = _appDirents.sudachiDictionaryFile;

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

    if (isClosed) return;

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
            dictionaryStatus: const .nothing(),
          ),
        );
      },
    );
  }

  Future<void> importDict() async {
    final result = await asyncGuard(
      () async {
        emit(state.copyWith(dictionaryStatus: const .waiting()));

        final selectedFile = await FilePicker.pickFiles(
          type: .custom,
          allowedExtensions: [FileExt.dic.value],
        );

        if (selectedFile == null) throw IgnoredException('No file selected');

        final filePath = selectedFile.files.single.path!;
        final isValid = await SudachiDictionary.validateFile(filePath);

        if (!isValid) throw Exception('Invalid dictionary file');

        final dictionaryFile = _appDirents.sudachiDictionaryFile;

        await File(filePath).copy(dictionaryFile.path);

        return dictionaryFile.path;
      },
    );

    if (isClosed) return;

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
            dictionaryStatus: const .nothing(),
          ),
        );
      },
    );
  }

  Future<AsyncSnapshot<bool>> setRenshuuApiKey(String key) async {
    final snapshot = await asyncGuard(
      () async {
        final isValidKey = await validateRenshuuApiKey(key);

        if (!isValidKey) throw Exception('Invalid Renshuu API key');

        await _userSessionService.saveRenshuuApiKey(key);
        return true;
      },
    );

    if (isClosed) return const .nothing();

    return snapshot.fold(
      onData: (data) => .withData(.done, data),
      onError: (error, stackTrace) =>
          .withError(.done, error, stackTrace ?? .empty),
      orElse: () => const .nothing(),
    );
  }
}
