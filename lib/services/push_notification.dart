import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utilities/global_variables.dart';

class PushNotification {
  static Future<void> sendNotificationNow(
      {required String deviceRegistrationToken,
      required String title,
      required String body}) async {
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map bodyNotification = {'body': body, 'title': title};

    Map dataMap = {};

    Map officialNotificationFormat = {
      'notification': bodyNotification,
      'data': dataMap,
      'priority': 'high',
      'to': deviceRegistrationToken,
    };

    var responseNotification = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }
}
