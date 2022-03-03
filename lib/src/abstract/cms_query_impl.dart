// Created by Sanjeev Sangral on 15/2/21.
import 'package:flutter/services.dart';
import 'package:connie/src/abstract/cms_query_abstract.dart';

class CMSQueryImpl extends CMSQueryAbstract {
  static const platform = const MethodChannel('flutter.native/helper');
  String _responseFromNativeCode = 'No Result Found...';

  @override
  Future<String> cmsQuery(bool nativeTtsStarted, String startOrStop,
      String accessToken, String callTo) async {
    // TODO: implement cmsQuery
    String response;
    try {
      final String result = await platform.invokeMethod('helloFromNativeCode', {
        "nativeTtsStarted": nativeTtsStarted,
        "startOrStop": startOrStop,
        "accessToken": accessToken,
        "callTo": callTo
      });
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
    if (response.isNotEmpty) {
      return response;
    } else {
      return _responseFromNativeCode;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
