part 'package:free_movies/GlobalSettings/models/update.dart';

class GlobalSetting {
  final String baseUrl;
  final String apId;
  final String platform;
  final bool adsEnabled;
  final bool watchEnabled;
  final Update update;
  GlobalSetting(
      {this.update,
      this.adsEnabled,
      this.watchEnabled,
      this.baseUrl,
      this.platform,
      this.apId});
  GlobalSetting.fromJson(Map<String, dynamic> json)
      : adsEnabled = json['adsEnabled'],
        watchEnabled = json['watchEnabled'],
        baseUrl = json['baseUrl'],
        apId = json['apId'],
        platform = json['platform'],
        update = Update.fromJson(json['update']??{});

  GlobalSetting.initial()
      : adsEnabled = false,
        watchEnabled = false,
        baseUrl = 'https://uapi.adrise.tv',
        platform = 'android',
        apId = 'tubitv',
        update = null;
}
