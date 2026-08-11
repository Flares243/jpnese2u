import 'package:dio/dio.dart';
import 'package:jpnese2u/api/renshuu_api/models/get_profile_res_entity.dart';
import 'package:retrofit/retrofit.dart';

import 'package:jpnese2u/api/renshuu_api/models/word_search_res_entity.dart';

part 'api.g.dart';

@RestApi()
abstract class RenshuuApi {
  factory RenshuuApi(Dio dio, {String? baseUrl}) = _RenshuuApi;

  @GET('profile')
  Future<GetProfileResEntity> getProfile({
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET('word/search/')
  Future<WordSearchResEntity> wordSearch({
    @Query('value') required String value,
    @Query('pg') required String pg,
    @CancelRequest() CancelToken? cancelToken,
  });
}
