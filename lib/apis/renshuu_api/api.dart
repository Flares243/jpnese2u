import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:jpnese2u/apis/renshuu_api/models/word_search_res_entity.dart';

part 'api.g.dart';

@RestApi()
abstract class RenshuuApi {
  factory RenshuuApi(Dio dio, {String? baseUrl}) = _RenshuuApi;

  @GET('/word/search')
  Future<WordSearchResEntity> wordSearch({
    @Query('value') required String value,
    @Query('pg') required String pg,
    @CancelRequest() CancelToken? cancelToken,
  });
}
