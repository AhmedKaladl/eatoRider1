import 'package:efood_multivendor_driver/data/api/api_client.dart';
import 'package:efood_multivendor_driver/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> getConfigData() async {
    Response response = await apiClient.getData(AppConstants.configUri);
    return response;
  }

  Future<bool> initSharedData() {
    if(!sharedPreferences.containsKey(AppConstants.theme)) {
      return sharedPreferences.setBool(AppConstants.theme, false);
    }
    if(!sharedPreferences.containsKey(AppConstants.countryCode)) {
      return sharedPreferences.setString(AppConstants.countryCode, AppConstants.languages[0].countryCode!);
    }
    if(!sharedPreferences.containsKey(AppConstants.languageCode)) {
      return sharedPreferences.setString(AppConstants.languageCode, AppConstants.languages[0].languageCode!);
    }
    if(!sharedPreferences.containsKey(AppConstants.notification)) {
      return sharedPreferences.setBool(AppConstants.notification, true);
    }
    if(!sharedPreferences.containsKey(AppConstants.notificationCount)) {
      sharedPreferences.setInt(AppConstants.notificationCount, 0);
    }
    if(!sharedPreferences.containsKey(AppConstants.ignoreList)) {
      sharedPreferences.setStringList(AppConstants.ignoreList, []);
    }
    if(!sharedPreferences.containsKey(AppConstants.langIntro)) {
      sharedPreferences.setBool(AppConstants.langIntro, true);
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }

  void setLanguageIntro(bool intro) {
    sharedPreferences.setBool(AppConstants.langIntro, intro);
  }

  bool showLanguageIntro() {
    return sharedPreferences.getBool(AppConstants.langIntro) ?? true;
  }
}