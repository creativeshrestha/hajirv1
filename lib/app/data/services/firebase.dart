import 'dart:convert';

import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

abstract class PushNotification {
  Future<String> get fireBaseToken;
  Future initialise();
  Future removeToken();
  void showNotification(
      {required String title,
      String? payLoad,
      String? message,
      required String body});
}

class FirebaseService extends GetxService {
  init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

Future _selectNotification(String? payload,
    {bool didNotificationLaunchApp = false}) async {
  if (didNotificationLaunchApp) {
    //if the app is started by clicking on the notification,
    //Wait for some time to ensure the app is initialized  well, then open notification
    await Future.delayed(const Duration(seconds: 1));
  }
  if (payload == null) return;
  try {
    final data = json.decode(payload);
    final type = (data['notification_type'] ?? data['type']) as String?;
    final id = data['product_id'] ?? '0';
    final image = data['banner'] as String?;
    final message = (data['message'] ?? data['body']) as String?;
    final title = data['title'] as String?;
    final redirect = data['redirect'] as String?;
    final utilType = data['Utility_type'] as String?;

    if (type != null) {
      /// Navigation logic goes here

      // navigate(key.currentContext!, NotificationItem(),
      //     data: data as Map<String, dynamic>);

      // Get.toNamed(Routes.NOTIFICATIONS, arguments: payload);
    }
  } catch (ex) {
    // debugPrint('ERROR pasring notification jSON Data');
    // debugPrint(ex.toString());
  }
}

const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
  showBadge: true,
);
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class PushNotificationManager implements PushNotification {
  String _token = "";

  ///if token is empty, generates new
  @override
  Future<String> get fireBaseToken async {
    if (_token.isNotEmpty) {
      return _token;
    }
    return _generateAndSetToken();
  }

  Future<String> _generateAndSetToken() async {
    try {
      _token = await _firebaseMessaging.getToken() ?? '';

      return _token;
    } catch (ex) {
      return '';
    }
  }

  @override
  Future initialise() async {
    /// local notification setup
    await _localNotificationSetup();

    /// firebase messaging setup
    await _pushNotificationSetup();
  }

  @override
  Future removeToken() async {
    await _firebaseMessaging.deleteToken();
    _token = '';
    // Get.find<GetService>().fcmToken = ('');
  }

  Future _localNotificationSetup() async {
    var permission = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    if (permission ?? false) {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings(
        'mipmap/launcher_icon',
      );

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel);

      await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
          // onDidReceiveBackgroundNotificationResponse: (details) =>
          //     _selectNotification(details.payload),
          onDidReceiveNotificationResponse: (details) async {
        if (details.payload?.contains('/') == true) {
          try {
            // await OpenFilex.open(details.payload);
          } catch (_) {
            return;
          }
        }
        _selectNotification(details.payload ?? "");
      });

// when opening the app from the notification you need to check with the plugin if a notification opened the app.
//So basically in the first screen, after initialising the FlutterLocalNotificationsPlugin,
//check didNotificationLaunchApp and if true call your onSelectNotification method:

      final notificationAppLaunchDetails =
          await _flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();
      if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
        _selectNotification(
            notificationAppLaunchDetails?.notificationResponse?.payload ?? '',
            didNotificationLaunchApp: true);
      }
    }
  }

  Future _pushNotificationSetup() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    setupFirebaseMessaging();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      setupFirebaseMessaging();
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      setupFirebaseMessaging();
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  setupFirebaseMessaging() async {
    try {
      _generateAndSetToken();
    } catch (ex) {
      // debugPrint(ex.toString());
      return;
    }

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen(handleForegroundIncomingNotification);
    FirebaseMessaging.onMessageOpenedApp
        .listen(handleBackgroundIncomingNotification);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundIncomingNotification);

    // Get any messages which caused the application to open from a terminated state.
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleBackgroundIncomingNotification(initialMessage);
    }
    try {
      var topic = Values.pushNotifTopicId;
      // if (getIt<ConfigReader>().isDebugApp) {
      topic = topic ?? '_dev';
      // }
      _firebaseMessaging.subscribeToTopic(topic);
    } catch (ex) {
      // debugPrint(ex.toString());
      return;
    }
  }

  @override
  void showNotification(
      {required String title,
      String? payLoad,
      String? message,
      required String body}) {
    _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              _androidChannel.id, _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: 'mipmap/launcher_icon',
              styleInformation: BigTextStyleInformation(body),
              channelShowBadge: true,
              importance: Importance.max,
              playSound: true),
        ),
        payload: payLoad);
  }
}

class Values {
  static var pushNotifTopicId;
}

Future<void> handleForegroundIncomingNotification(RemoteMessage message) async {
  // print('notification in foreground');
  final RemoteNotification? notification = message.notification;

  final AndroidNotification? android = message.notification?.android;

  // If `onMessage` is triggered with a notification, construct our own
  // local notification to show to users using the created channel.
  if (notification != null && android != null) {
    _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              _androidChannel.id, _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: android.smallIcon ?? 'mipmap/launcher_icon',
              styleInformation:
                  BigTextStyleInformation(notification.body ?? ''),
              channelShowBadge: true,
              importance: Importance.max,
              playSound: true),
        ),
        payload: json.encode(message.data));
  }
  // final homeInstance = Get.find<RpsHomeController>();
  // homeInstance.updateStatusById(
  //     int.parse(message.data['id']), message.data['status']);
}

Future<void> handleBackgroundIncomingNotification(RemoteMessage message) async {
  // debugPrint(message.toString());
  if (message.notification?.title != null &&
      message.notification?.android != null) {
    _flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              _androidChannel.id, _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: message.notification?.android?.smallIcon ??
                  'mipmap/launcher_icon',
              styleInformation:
                  BigTextStyleInformation(message.notification?.body ?? ''),
              channelShowBadge: true,
              importance: Importance.max,
              playSound: true),
        ),
        payload: json.encode(message.data));
  }

  _selectNotification(json.encode(message.data),
      didNotificationLaunchApp: true);
}
