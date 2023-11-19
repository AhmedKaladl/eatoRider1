import 'dart:async';
import 'dart:io';
import 'package:efood_multivendor_driver/data/model/body/delivery_man_body.dart';
import 'package:efood_multivendor_driver/data/model/body/record_location_body.dart';
import 'package:efood_multivendor_driver/helper/custom_print.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

import 'package:efood_multivendor_driver/data/api/api_client.dart';
import 'package:efood_multivendor_driver/data/model/response/profile_model.dart';
import 'package:efood_multivendor_driver/util/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> login(String phone, String password) async {
    return await apiClient.postData(AppConstants.loginUri, {"phone": phone, "password": password});
  }

  Future<Response> getProfileInfo() async {
    return await apiClient.getData(AppConstants.profileUri + getUserToken());
  }

  Future<Response> recordLocation(RecordLocationBody recordLocationBody) {
    recordLocationBody.token = getUserToken();
    return apiClient.postData(AppConstants.recordLocationUri, recordLocationBody.toJson());
  }

  Future<http.StreamedResponse> updateProfile(ProfileModel userInfoModel, XFile? data, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.updateProfileUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(GetPlatform.isMobile && data != null) {
      File file = File(data.path);
      request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    }else if(GetPlatform.isWeb && data != null) {
      Uint8List list = await data.readAsBytes();
      var part = http.MultipartFile('image', data.readAsBytes().asStream(), list.length, filename: basename(data.path),
          contentType: MediaType('image', 'jpg'));
      request.files.add(part);
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put', 'f_name': userInfoModel.fName!, 'l_name': userInfoModel.lName!,
      'email': userInfoModel.email!, 'token': getUserToken()
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<Response> changePassword(ProfileModel userInfoModel, String password) async {
    return await apiClient.postData(AppConstants.updateProfileUri, {'_method': 'put', 'f_name': userInfoModel.fName,
      'l_name': userInfoModel.lName, 'email': userInfoModel.email, 'password': password, 'token': getUserToken()});
  }

  Future<Response> updateActiveStatus({int? shiftId}) async {
    Map<String, String> body = {};
    body['token'] = getUserToken();
    if(shiftId != null){
      body['shift_id'] = shiftId.toString();
    }
    return await apiClient.postData(AppConstants.activeStatusUri, body);
  }

  Future<Response> updateToken({String notificationDeviceToken = ''}) async {
    String? deviceToken;
    if(notificationDeviceToken.isEmpty){
      if (GetPlatform.isIOS) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
          alert: true, announcement: false, badge: true, carPlay: false,
          criticalAlert: false, provisional: false, sound: true,
        );
        if(settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = await _saveDeviceToken();
        }
      }else {
        deviceToken = await _saveDeviceToken();
      }
      if(!GetPlatform.isWeb) {
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
        FirebaseMessaging.instance.subscribeToTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);

      }
    }
    return await apiClient.postData(AppConstants.tokenUri, {"_method": "put", "token": getUserToken(), "fcm_token": notificationDeviceToken.isNotEmpty ? notificationDeviceToken : deviceToken});
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '';
    if(!GetPlatform.isWeb) {
      deviceToken = (await FirebaseMessaging.instance.getToken())!;
    }
    customPrint('--------Device Token---------- $deviceToken');
    return deviceToken;
  }

  Future<Response> forgetPassword(String? phone) async {
    return await apiClient.postData(AppConstants.forgerPasswordUri, {"phone": phone});
  }

  Future<Response> verifyToken(String? phone, String token) async {
    return await apiClient.postData(AppConstants.verifyTokenUri, {"phone": phone, "reset_token": token});
  }

  Future<Response> resetPassword(String? resetToken, String phone, String password, String confirmPassword) async {
    return await apiClient.postData(
      AppConstants.resetPasswordUri,
      {"_method": "put", "phone": phone, "reset_token": resetToken, "password": password, "confirm_password": confirmPassword},
    );
  }

  Future<bool> saveUserToken(String token, String topic) async {
    apiClient.token = token;
    apiClient.updateHeader(token, sharedPreferences.getString(AppConstants.languageCode));
    sharedPreferences.setString(AppConstants.zoneTopic, topic);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  Future<bool> clearSharedData() async {
    if(!GetPlatform.isWeb) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
      FirebaseMessaging.instance.unsubscribeFromTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);

      apiClient.postData(AppConstants.tokenUri, {"_method": "put", "token": getUserToken(), "fcm_token": '@'});
    }
    await sharedPreferences.remove(AppConstants.token);
    await sharedPreferences.setStringList(AppConstants.ignoreList, []);
    await sharedPreferences.remove(AppConstants.userAddress);
    apiClient.updateHeader(null, null);
    return true;
  }

  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);
      await sharedPreferences.setString(AppConstants.userCountryCode, countryCode);
    } catch (e) {
      rethrow;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.userCountryCode) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.notification) ?? true;
  }

  void setNotificationActive(bool isActive) {
    if(isActive) {
      updateToken();
    }else {
      if(!GetPlatform.isWeb) {
        updateToken(notificationDeviceToken: '@');
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        FirebaseMessaging.instance.unsubscribeFromTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);
      }
    }
    sharedPreferences.setBool(AppConstants.notification, isActive);
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    await sharedPreferences.remove(AppConstants.userCountryCode);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  Future<Response> deleteDriver() async {
    return await apiClient.deleteData(AppConstants.driverRemove + getUserToken());
  }

  Future<Response> getZoneList() async {
    return await apiClient.getData(AppConstants.zoneListUri);
  }

  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData('${AppConstants.zoneUri}?lat=$lat&lng=$lng');
  }

  Future<bool> saveUserAddress(String address) async {
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token),
      sharedPreferences.getString(AppConstants.languageCode),
    );
    return await sharedPreferences.setString(AppConstants.userAddress, address);
  }

  String? getUserAddress() {
    return sharedPreferences.getString(AppConstants.userAddress);
  }

  Future<Response> registerDeliveryMan(DeliveryManBody deliveryManBody, List<MultipartBody> multiParts) async {
    return apiClient.postMultipartData(AppConstants.dmRegisterUri, deliveryManBody.toJson(), multiParts);
  }

  Future<Response> getVehicleList() async {
    return await apiClient.getData(AppConstants.vehiclesUri);
  }

  Future<Response> getShiftList() {
    return apiClient.getData('${AppConstants.shiftUri}${getUserToken()}');
  }

}
