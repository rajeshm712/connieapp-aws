import 'package:connie/src/providers/callingProvider.dart';
import 'package:connie/src/providers/charmBarInfoProvider.dart';
import 'package:connie/src/providers/controlButtonsProvider.dart';
import 'package:connie/src/providers/googleMapScreenProvider.dart';
import 'package:connie/src/providers/homeScreenProvider.dart';
import 'package:connie/src/providers/infoButtonProvider.dart';
import 'package:connie/src/providers/loginProvider.dart';
import 'package:connie/src/providers/speakingUiInfoProvider.dart';
import 'package:connie/src/providers/typeSpeakProvider.dart';
import 'package:connie/src/providers/volumeControlerProvider.dart';
import 'package:connie/src/providers/youtubeInfoProvider.dart';
import 'package:connie/src/ui/home_screen.dart';
import 'package:connie/src/ui/login_screen.dart';
import 'package:connie/src/utils/AppPref.dart';
import 'package:connie/src/utils/PrefModel.dart';
import 'package:connie/src/utils/PushNotificationsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AppPref.getInstance();
  PushNotificationsManager.initializeNotification();
  PushNotificationsManager.intialiseNotificationChannel(
      "maas_channel", "ConappMaas", "ConApp Description");
  PushNotificationsManager.registerFirebaseForNotification();
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler() async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: LoginProvider()),
          ChangeNotifierProvider.value(value: InfoButtonProvider()),
          ChangeNotifierProvider.value(value: CharmBarInfoProvider()),
          ChangeNotifierProvider.value(value: HomeScreenProvider()),
          ChangeNotifierProvider.value(value: ControlButtonsProvider()),
          ChangeNotifierProvider.value(value: SpeakingUiInfoProvider()),
          ChangeNotifierProvider.value(value: YoutubeInfoProvider()),
          ChangeNotifierProvider.value(value: TypeSpeakProvider()),
          ChangeNotifierProvider.value(value: CallingProvider()),
          ChangeNotifierProvider.value(value: GoogleMapScreenProvider()),
          ChangeNotifierProvider.value(value: VolumeControlerProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          locale: Locale('en'),
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Railway',
          ),
          home: checkUser(context),
        ));
  }

  Widget checkUser(BuildContext context) {
    PrefModel prefModel = AppPref.getPref();
    if (prefModel != null &&
        prefModel.isLogin != null &&
        prefModel.isLogin) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }

}
