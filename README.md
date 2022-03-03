# FlutterConnieApp

A Flutter application for some conversational and Type interactions with Connie. 

# Compatibility
Android (Tab)

Android minSdkVersion 21

# Configration 

Flutter (Channel stable, 1.22.2, on Mac OS X 10.15.7 19H2, locale en-IN)

    • Flutter version 1.22.2 
    • Framework revision 84f3d28555 
    • Engine revision b8752bbfff
    • Dart version 2.10.2

 
[✓] Android toolchain - develop for Android devices (Android SDK version 30.0.2)

    • Android SDK 
    • Platform android-30, build-tools 30.0.2
    • Java binary 
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)
    • All Android licenses accepted.

[✓] Android Studio (version 4.0)

    • Android Studio 
    • Flutter plugin version 50.0.1
    • Dart plugin version 193.7547
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)
    
    
# Installation 
(**Note:** Make sure user have proper setup for flutter development [For more Details ](https://flutter.dev/docs/get-started/install))

1. Clone this repository import into **Android Studio** or **Visual Studio Code** 
'https://github.com/ICAV-C/ConnieApp.git'
2. Go to terminal and run the command *flutter pub get*
This command gets all the dependencies listed in the pubspec.yaml file in the current working directory, as well as their transitive dependencies.
3. Open a Emulator on Your machine or you can connect your physical device by USB cable for testing purpose.
4. Press *Run* button on your Editor.

That's it.

# Features

1. **Voice Conversation:** Once User click on the mic as show in the screen [here](https://xd.adobe.com/view/f0b6940a-b1aa-4c19-456c-4bbd9765acac-8687/). Connie will respond accordingly and for this functionality we have integrated GCSE (Google Custom Search Engine) which help us to get the result from Google.
2. **Type Screen:** We have two option either user can communicate with voice or by type, In Type Screen we are getting query from user and getting the result from GCS and Connie will speak accordingly.
3. **Google Map Screen:** In this screen user can see its own location on Googlr map.
4. **Calling Supervisor:** In this feature user can directly get the help from supervisor of Connie by just single click on the call button (This feature still under process not completed).
5. **CharmBar:** In the charmbar we have a functionality where we are showing Network either its Wifi/Mobile Network, Current Time, Date, Weather.

# Dependencies
```
  cupertino_icons: ^0.1.3
  speech_to_text: ^2.7.0
  flutter_tts: ^1.2.6
  gen_lang: ^0.1.3
  intl: ^0.16.1
  adobe_xd: ^1.0.0+1
  google_maps_flutter: ^1.0.2
  volume: ^1.0.1
  connectivity: ^0.4.9+2
  wifi: ^0.1.5
  weather: ^1.2.2
  weather_icons: ^2.0.2
  http: ^0.12.2
  location: ^3.0.2
  provider: ^4.3.1
  frideos: ^1.0.1
  url_launcher: ^5.5.2
  youtube_player_flutter: ^7.0.0+7
  webview_flutter: ^0.3.22+1
  flutter_webview_plugin: ^0.3.4
  auto_size_text: ^2.1.0
  dio: ^3.0.10
  flutter_spinkit: ^4.1.2+1 
  android_intent: ^0.3.7+6 
  ```
For getting details and latest version info of dependencies please [Visit Here](https://pub.dev/) and search the name of dependencies.

## Maintainers
This project is mantained by:
* [Sanjeev Kumar](https://github.com/sanjeevsangral)
* [Yadavendra Singh](https://github.com/YadavendraSingh)


# App Design and Flow [here](https://xd.adobe.com/view/f0b6940a-b1aa-4c19-456c-4bbd9765acac-8687/)

