import 'dart:async';

import 'package:connie/src/abstract/loginAbstract.dart';
import 'package:connie/src/models/login_req_model.dart';
import 'package:connie/src/models/login_res_model.dart';
import 'package:connie/src/ui/home_screen.dart';
import 'package:connie/src/utils/AppPref.dart';
import 'package:connie/src/utils/PrefModel.dart';
import 'package:connie/src/utils/Repository.dart';
import 'package:connie/src/utils/ResponseAPI.dart';
import 'package:connie/src/utils/Strings.dart';
import 'package:connie/src/utils/ViewUtil.dart';
import 'package:connie/src/utils/common_style.dart';
import 'package:connie/src/utils/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:connie/src/models/login_req_model.dart' as loginReqmodel;

class LoginProvider extends LoginAbstract {
  Repository _repository = Repository();
  bool loginAPISuccess = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool eyebuttonPressed = false;

  @override
  Future<ResponseApi> loginApi(LoginReqModel reqModel, Status apiType) async {
    // TODO: implement loginApi
    if (await SimpleConnectionChecker.isConnectedToInternet()) {
      print("loginAPI ");
      return await _repository.loginApi(reqModel, apiType);
    } else {
      return ResponseApi.fail(Strings.NO_INTERNET_CONNECTION, apiType);
    }
  }

  @override
  void callLoginApi(
      BuildContext context,
      TextEditingController textEditingControllerEmail,
      TextEditingController textEditingControllerPw,
      LoginProvider loginProvider,
      GlobalKey<ScaffoldState> scfKey) async {
    print("loginAPI callLoginApi");
    PrefModel prefModel = AppPref.getPref();
    List<String> deviceTokenList = [];
    deviceTokenList.add(prefModel.deviceToken);
    loginReqmodel.LoginReqModel postLogin = new loginReqmodel.LoginReqModel();
    String email = textEditingControllerEmail.text.trim();
    postLogin.username = email;
    postLogin.password = textEditingControllerPw.text.trim();
    DeviceTokens deviceTokens = new DeviceTokens();
    deviceTokens.connie = prefModel.deviceToken;
    postLogin.deviceTokens = deviceTokens;
    if (email.isEmpty) {
      showSnackBar("Please enter the Email", scfKey);
      return;
    } else if (!ViewUtil.checkEmailValid(email)) {
      showSnackBar("Please enter the valid  Email", scfKey);
      return;
    } else if (!ViewUtil.checkStringIsEmpty(postLogin.password)) {
      showSnackBar(Strings.PASSWORD_ERROR_MSG, scfKey);
      return;
    }
    /*else if (!checkTermConditions) {
      showSnackBar("Please agree to the Terms & Conditions by check the box");
      return;
    } */
    else {
      print("loginAPI Start");

      startTimer(scfKey);
      progress(context);
      ResponseApi responseApi =
          await loginProvider.loginApi(postLogin, Status.LOGIN_API);
      checkResponseLogin(responseApi, context, scfKey);
    }
  }

  void startTimer(GlobalKey<ScaffoldState> scKey) {
    Timer(Duration(seconds: 15), () {
      if (!loginAPISuccess) {
        showSnackBar("Request time out, please try again", scKey);
      }
      return;
    });
  }

  void progress(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Column(
          children: [
            SpinKitFadingCircle(color: primary),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Please wait...',
              style: styleJourney.copyWith(color: Colors.black, fontSize: 14.0),
            )
          ],
        ));
      },
    );
  }

  void showSnackBar(String msg, GlobalKey<ScaffoldState> scKey) {
    ViewUtil.showSnackBar(scKey, msg);
  }

  void checkResponseLogin(ResponseApi responseApi, BuildContext context,
      GlobalKey<ScaffoldState> scKey) {
    print("SUCCESS LOCATIONS_API" + responseApi.status.toString());
    loginAPISuccess = true;
    switch (responseApi.status) {
      case Status.SUCCESS:
        if (responseApi.apiTypeStatus == Status.LOGIN_API) {
          Navigator.pop(context);
          print("SUCCESS LOGIN_API");
          LoginResModel resModel = responseApi.data as LoginResModel;
          PrefModel prefModel = AppPref.getPref();
          // prefModel.userName = resModel.username;
          prefModel.isLogin = true;
          prefModel.userId = resModel.userId;
          AppPref.setPref(prefModel);
          openHomeScreen(context);
        }
        break;
      default:
        Navigator.pop(context);
        print("SUCCESS LOGIN_API fails" + responseApi.data.toString());

        showSnackBar(responseApi.data as String, scKey);
        break;
    }
  }

  void openHomeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  bool getEyeOpenPressStatus() {
    // TODO: implement getEyeOpenPressStatus

    return eyebuttonPressed;
  }

  @override
  void setEyeOpenPressStatus(bool pressed) {
    // TODO: implement setEyeOpenPressStatus

    eyebuttonPressed = pressed;
    notifyListeners();
  }
}
