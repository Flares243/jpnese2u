import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:jpnese2u/main.dart';

import 'package:jpnese2u/util/app_dirent.dart';
import 'package:jpnese2u/util/async_guard.dart';

import 'package:path/path.dart' as path;

class DownloaderServ {
  static DownloaderServ get getInstance => getIt<DownloaderServ>();

  final Dio dio;
  final AppDirent appDirents;

  DownloaderServ({
    required this.appDirents,
    Dio? dio,
  }) : dio = dio ?? Dio();

  Future<AsyncSnapshot<File>> downloadFile({
    required String url,
    String? saveDirPath,
    String? fileName,
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    return asyncGuard(
      () async {
        final temporaryDir = appDirents.temporaryDir;

        final directoryPath = saveDirPath ?? temporaryDir.path;
        final name =
            fileName ?? url.split('/').lastOrNull?.split('?').firstOrNull;
        final fullFilePath = path.join(directoryPath, name);

        final response = await dio.download(
          url,
          fullFilePath,
          onReceiveProgress: onProgress,
          cancelToken: cancelToken,
          options: Options(
            responseType: .bytes,
            followRedirects: true,
          ),
        );

        if (response.statusCode == StatusCode.OK) {
          return File(fullFilePath);
        }

        throw HttpException('Failed with status code: ${response.statusCode}');
      },
    );
  }

  void dispose() {
    dio.close();
  }
}
