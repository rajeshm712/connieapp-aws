import 'package:connie/src/models/login_req_model.dart';
import 'package:connie/src/providers/loginProvider.dart';
import 'package:connie/src/utils/ResponseAPI.dart';
import 'package:connie/src/utils/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class LoginAbstract extends ChangeNotifier {
  Future<ResponseApi> loginApi(LoginReqModel reqModel, Status apiType);

  void setEyeOpenPressStatus(bool pressed);

  bool getEyeOpenPressStatus();

  void callLoginApi(
      BuildContext context,
      TextEditingController textEditingControllerEmail,
      TextEditingController textEditingControllerPw,
      LoginProvider loginProvider,
      GlobalKey<ScaffoldState> scKey);
}
