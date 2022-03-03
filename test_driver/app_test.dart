// // Created by Sanjeev Sangral on 17/09/20.
// import 'dart:io';
// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:test/test.dart';
//
// void main() {
//   group('ConnieApp', () {
//     // First, define the Finders and use them to locate widgets from the
//     // test suite. Note: the Strings provided to the `byValueKey` method must
//     // be the same as the Strings we used for the Keys in step 1.
//     final counterTextFinder = find.byValueKey('welcome');
//     final buttonMap = find.byValueKey('map');
//     final buttonType = find.byValueKey('type_button');
//     final buttonTypeScreenClose = find.byValueKey('type_screen_close_button');
//     final buttonMic = find.byValueKey('mic_button');
//     final buttonSupervisor = find.byValueKey('supervisor_button');
//     final typeTextField = find.byValueKey('type_command');
//
//     FlutterDriver driver;
//
//     // Connect to the Flutter driver before running any tests.
//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//       new Directory('screenshots').create();
//     });
//
//     // Close the connection to the driver after the tests have completed.
//     tearDownAll(() async {
//       if (driver != null) {
//         driver.close();
//       }
//     });
//
//     takeScreenshot(FlutterDriver driver, String path) async {
//       final List<int> pixels = await driver.screenshot();
//       final File file = new File(path);
//       await file.writeAsBytes(pixels);
//       print(path);
//     }
//
//     test('mic enable screen', () async {
//       // Use the `driver.getText` method to verify the counter starts at 0.
//       sleep(Duration(seconds: 3));
//       await driver.tap(buttonMic);
//       sleep(Duration(seconds: 3));
//       takeScreenshot(driver, 'screenshots/mic_enable_screen.png');
//       sleep(Duration(seconds: 2));
//       await driver.tap(buttonMic);
//       sleep(Duration(seconds: 2));
//       expect(await driver.getText(counterTextFinder), "Welcome");
//     });
//
//     test('map open & close', () async {
//       // First, tap the button.
//       sleep(Duration(seconds: 2));
//       takeScreenshot(driver, 'screenshots/welcome.png');
//       sleep(Duration(seconds: 2));
//       await driver.tap(buttonMap);
//       sleep(Duration(seconds: 3));
//       takeScreenshot(driver, 'screenshots/google_map.png');
//       sleep(Duration(seconds: 2));
//       await driver.tap(buttonMap);
//       sleep(Duration(seconds: 2));
//       expect(await driver.getText(counterTextFinder), "Welcome");
//     });
//
//
//     test('type screen', () async {
//       // Use the `driver.getText` method to verify the counter starts at 0.
//       sleep(Duration(seconds: 2));
//       await driver.tap(buttonType);
//       sleep(Duration(seconds: 2));
//       await driver.tap(typeTextField);
//       takeScreenshot(driver, 'screenshots/type_screen.png');
//       sleep(Duration(seconds: 2));
//       await driver.tap(typeTextField);
//       await driver.enterText('who are you');
//       sleep(Duration(seconds: 2));
//       takeScreenshot(driver, 'screenshots/type_screen_with_text.png');
//       sleep(Duration(seconds: 2));
//       await driver.tap(buttonTypeScreenClose);
//       sleep(Duration(seconds: 1));
//       expect(await driver.getText(counterTextFinder), "Welcome");
//     });
//   });
//
// }