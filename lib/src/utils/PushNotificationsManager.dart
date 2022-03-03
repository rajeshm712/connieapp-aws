import 'dart:convert';

import 'package:connie/src/models/NotificationData.dart';
import 'package:connie/src/models/NotificationModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'AppPref.dart';
import 'PrefModel.dart';

class PushNotificationsManager {
  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  static void registerFirebaseForNotification() {
    print("onmeaaasgeReceived    intailixzationNotificationcahnnel");

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("ConnieNotitfForegrind");
        handleRecieveNotificationData(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunchConnie: $message");
        String appData = message['data']['app_data'].toString();
        whenNotificationReceviedBackGeound(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        PrefModel prefModel = AppPref.getPref();
        prefModel.backgroundnNotificationData = "onResume";
        AppPref.setPref(prefModel);
        openScreenOnLaunchAndOnResume(message);

        // String  data = ;
        //  onSelectNotification(data.toString());

        print("onmeaaasgeReceived    intailixzationNotificationcahnnelDone");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
      PrefModel prefModel = AppPref.getPref();
      prefModel.deviceToken = token;
      AppPref.setPref(prefModel);
    });
    _firebaseMessaging.subscribeToTopic("Connie");
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    PrefModel prefModel = AppPref.getPref();
    prefModel.backgroundnNotificationData = "myBackgroundMessageHandler";
    AppPref.setPref(prefModel);

    print(" myBackgroundMessageHandler  i AM CALLING: ");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      try {
        NotificationData model = whenNotificationReceviedBackGeound(message);
        displayNotification(model, json.encode(model));
        print('myBackgroundMessageHandler payload: ' + model.message);
      } catch (e) {
        print('myBackgroundMessageHandler exceptio: ' + e.toString());
      }
    }
    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
  }

  static Future displayNotification(NotificationData model, String data) async {
    print('notification displayNotification: ' + model.appData);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'maas_channel_id', 'maas', 'ConApp Description',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      0,
      model.title,
      model.message,
      platformChannelSpecifics,
      payload: data,
    );
  }

  static Future displayNotificationConnie(String title, String body) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'maas_channel_id', 'maas', 'ConApp Description',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  static Future<void> intialiseNotificationChannel(
      String id, String name, String description) async {
    print("onmeaaasgeReceived    intailixzationNotificationcahnnel");

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidNotificationChannel = AndroidNotificationChannel(
      id,
      name,
      description,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  static void initializeNotification() async {
    try {
      print("onmeaaasgeReceived    intailixzation");

      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      var initializationSettingsAndroid =
          AndroidInitializationSettings('mipmap/ic_launcher');
      var initializationSettingsIOS = IOSInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);
    } catch (e) {
      print("onmeaaasgeReceived    intailixzationFales");

      print(e.toString());
    }
  }

  static Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('onSelectNotification payload: ' + payload);
    }
    print('onSelectNotification payload: ' + payload);
    try {
      NotificationData model = NotificationData.fromJson(json.decode(payload));
      checkTypeOfNotification(model);
      print('onSelectNotification payload: ' + model.message);
    } catch (e) {
      print('onSelectNotification exceptio: ' + e.toString());
    }

    /*
    if (AppUtil.checkIsLogin()) {
      Navigator.push(
        navigatorKey.currentContext,
        MaterialPageRoute(
            builder: (context) => SMSScreen()),
      );
    }*/
  }

  static checkTypeOfNotification(NotificationData model) {
    // if(model.notificationType.contains(AppConstant.BOOKING_POD))
    // {
    //   BookingStatusResModel bookingStatusResModel = BookingStatusResModel.fromJson(json.decode(model.appData));
    //   AppLogger.printLog("sucess on checkTypeOfNotification----"+bookingStatusResModel.id.toString());
    //   //ViewUtil.openGoogleMapScreen(bookingStatusResModel,navigatorKey.currentContext);
    // }
  }

  static Future generateLocalNotification(NotificationModel model) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'basic_channel', 'Conapp', 'ConApp Description',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      0,
      model.title,
      model.message,
      platformChannelSpecifics,
      payload: model.data,
    );
  }

  static void handleRecieveNotificationData(Map<String, dynamic> message) {
    dynamic data = message['data'];
    String data_load = data.toString();

    int maxLogSize = 500;
    for (int i = 0; i <= data_load.length / maxLogSize; i++) {
      int start = i * maxLogSize;
      int end = (i + 1) * maxLogSize;
      end = end > data_load.length ? data_load.length : end;
      print("onMessage registerFirebaseForNotification  : " +
          i.toString() +
          "----" +
          data_load.substring(start, end));
    }

    dynamic notification = message['notification'];
    print("onMessage registerFirebaseForNotification notification : " +
        notification.toString());

    dynamic click_action = message['click_action'];
    print("onMessage registerFirebaseForNotification click_action : " +
        click_action.toString());
    NotificationData model = whenNotificationReceviedBackGeound(message);
    displayNotification(model, json.encode(model));
  }

  static void openScreenOnLaunchAndOnResume(Map<String, dynamic> message) {
    print("onresume onSelectNotification data--" + message['data']['app_data']);
    String title = message['data']['title'];
    String body = message['data']['message'];
    String appData = message['data']['app_data'];
  }

  static NotificationData whenNotificationReceviedBackGeound(
      Map<String, dynamic> message) {
    try {
      dynamic messagedata = message['data']['message'];
      dynamic title = message['data']['title'];
      dynamic timestamp = message['data']['timestamp'];
      dynamic notification_type = message['data']['notification_type'];
      dynamic silentNotification = message['data']['silent_notification'];
      dynamic app_data = message['data']['app_data'];

      NotificationData model = new NotificationData();
      model.message = messagedata;
      model.title = title;
      model.timestamp = timestamp;
      model.notificationType = notification_type;
      model.silentNotification = silentNotification;
      model.appData = app_data;
      PrefModel prefModel = AppPref.getPref();
      prefModel.backgroundnNotificationData = json.encode(model);
      prefModel.notificationMsg = messagedata;
      print('registerFirebaseForNotification: ' + messagedata);
      AppPref.setPref(prefModel);
      return model;
    } catch (e) {
      print('registerFirebaseForNotification exception: ' + e.toString());
    }
    return null;
  }
}
