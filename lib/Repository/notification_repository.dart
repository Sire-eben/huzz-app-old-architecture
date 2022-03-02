import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/Repository/auth_respository.dart';

class NotificationRepository extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final controller = Get.find<AuthRepository>();

  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() async {
    super.onInit();
    controller.Mtoken.listen((p0) {
      print("getting push notification");
      setupInteractedMessage();
    });
    await requestForPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future requestForPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.instance.subscribeToTopic(controller.Mtoken.value);
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen((event) {
      print("new message gotten ${event.data}");

      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification!.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android?.smallIcon,
                // other properties...
              ),
            ));
      }
    });
  }

  void _handleMessage(RemoteMessage message) {
    print("message is gotten ${message.toString()}");
  }

  Future sendFCMTokenToServer() async {
    print("trying to get the fcm");
    // String token = await messaging.getToken();
    // print("user phone token $token");
    // var response = await http.post(
    //     Uri.parse(
    //         "http://foodgital2.herokuapp.com/notification/activate-user-notification"),
    //     body: jsonEncode(
    //         {"deviceToken": token, "userId": controller.vendorData.vendorId}),
    //     headers: {
    //       "Content-Type": "application/json",
    //       'Authorization': 'Bearer ${controller.token.value}'
    //     });
    // print("response of push notification ${response.body}");
  }
}
