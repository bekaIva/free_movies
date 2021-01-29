import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advertising_id/flutter_advertising_id.dart';
import 'package:free_movies/GlobalSettings/global_settings_bloc.dart';
import 'package:free_movies/home/model/home_response.dart' as homeResponse;
import 'package:free_movies/home/model/home_response.dart';

enum ContentMode { tv, movie, all }

class TubiApi {
  Dio _dio = Dio();
  final GlobalSettingsBloc _settingsBloc;
  String get baseUrl => _settingsBloc.state.baseUrl;
  String get appId => _settingsBloc.state.apId;
  String get platform => _settingsBloc.state.platform;
  String get deviceId => (_deviceId?.length ?? 0) > 0
      ? _deviceId
      : '4c04399d-9a2e-4ff0-94e3-cf8481e1956b';
  String _deviceId;
  TubiApi([this._settingsBloc]) : assert(_settingsBloc != null) {
    FlutterAdvertisingId.advertisingId.then((value) {
      _deviceId = value;
    });
  }

  Future<homeResponse.Content> updateContent(String id) async {
    var params = {
      'content_id': id,
      'video_resources': ['hlsv6_widevine', 'hlsv3'],
      'platform': platform,
      'deviceId': deviceId,
      'app_id': appId
    };
    String url = '$baseUrl/cms/content';
    var response = await _dio.get(url, queryParameters: params);
    var content = homeResponse.Content.fromJson(response.data);
    return content;
  }

  Future<homeResponse.HomeResponse> loadHomeScreen(
      {bool includeEmptyQueue=true,
      int limit=40,
      expand=2,
      bool includeVideoInGrid=false,
      @required int groupStart,
      @required int groupSize,
      ContentMode contentMode}) async {
    var params = {
      'includeEmptyQueue': includeEmptyQueue,
      'limit': limit,
      'expand': expand,
      'includeVideoInGrid': includeVideoInGrid,
      'groupStart': groupStart,
      'groupSize': groupSize,
      if (contentMode != null)
        'contentMode': EnumToString.convertToString(contentMode),
      'platform': platform,
      'deviceId': deviceId,
      'app_id': appId
    };
    String url = '$baseUrl/matrix/homescreen';
    var response = await _dio.get(url,
        queryParameters: params,
        options: Options(headers: {'': 'application/json'}));
    return homeResponse.HomeResponse.fromJson(response.data);
  }

  //page 0
  //https://uapi.adrise.tv/matrix/containers/most_popular?limit=40&expand=1&includeVideoInGrid=false&contentMode=all&
  // platform=android&deviceId=4c04399d-9a2e-4ff0-94e3-cf8481e1956b&app_id=tubitv

  // page2
  // https://uapi.adrise.tv/matrix/containers/most_popular?limit=40&cursor=40&expand=1&includeVideoInGrid=false&contentMode=all&
  // // platform=android&deviceId=4c04399d-9a2e-4ff0-94e3-cf8481e1956b&app_id=tubitv

  //search
  //https://uapi.adrise.tv/cms/search?search=terminator%20genesis&platform=android&deviceId=4c04399d-9a2e-4ff0-94e3-cf8481e1956b&app_id=tubitv

  Future<List<Content>> search(String query)async
  {
    var params = {
      'search': query,
      'platform': platform,
      'deviceId': deviceId,
      'app_id': appId
    };
    String url = '$baseUrl/cms/search';
    var res = await _dio.get(url,queryParameters: params,options: Options(headers: {'': 'application/json'}));
   var retVal = (res.data as List).map((e) => Content.fromJson(e)).toList();
    return retVal;
  }

  Future<homeResponse.SingleContainerResponse> loadContainer({
    @required homeResponse.Container container,
    int limit = 40,
    int cursor,
    int expand = 1,
    includeVideoInGrid = false,
    contentMode = 'all',
  }) async {
    var params = {
      'limit': limit,
      if (cursor != null) 'cursor': cursor,
      'expand': expand,
      'includeVideoInGrid': includeVideoInGrid,
      'contentMode': contentMode,
      'platform': platform,
      'deviceId': deviceId,
      'app_id': appId
    };
    String url = '$baseUrl/matrix/containers/${container.id}';
    var response = await _dio.get(url,
        queryParameters: params,
        options: Options(headers: {'': 'application/json'}));
    return homeResponse.SingleContainerResponse.fromJson(response.data);
  }
}
