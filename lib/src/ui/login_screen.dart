import 'package:connie/src/providers/loginProvider.dart';
import 'package:connie/src/utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  //
  LoginProvider loginProvider;

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool eyeOpenLogin = true;
  BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    loginProvider = Provider.of<LoginProvider>(context);
    buildContext = context;
    eyeOpenLogin = Provider.of<LoginProvider>(context).getEyeOpenPressStatus();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 50),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppUtil.getColorFromHex("#DBFFFE")),
                      constraints: BoxConstraints(maxHeight: 150.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "LOGIN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'RalewayBlack',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: getloginui(
                          context,
                          eyeOpenLogin,
                          loginEmailController,
                          loginPasswordController,
                          loginProvider,
                          _scaffoldKey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makecustomePasswordLoginWidget(
      String text,
      TextEditingController controller,
      TextInputAction textinput,
      bool obscureTextVal,
      TextInputType textInput,
      int charLength,
      bool isPrefix,
      String assetsImage,
      bool isEnable,
      bool eyeOpenStaus,
      BuildContext context,
      LoginProvider loginProvider) {
    return new Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        maxLength: charLength,
        keyboardType: textInput,
        cursorColor: AppUtil.getColorFromHex("#BABABA"),
        textInputAction: textinput,
        controller: controller,
        obscureText: obscureTextVal,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(
                color: AppUtil.getColorFromHex("#BABABA"), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppUtil.getColorFromHex("#BABABA"), width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          labelStyle: TextStyle(color: AppUtil.getColorFromHex("#BABABA")),
          labelText: text,
          hintText: '',
          counterText: "",
          suffixIconConstraints: BoxConstraints(minHeight: 32, minWidth: 32),
          suffixIcon: isPrefix
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setButtonPressStatus(context, eyeOpenStaus);
                    },
                    child: Icon(
                      Icons.remove_red_eye_sharp,
                      size: 25.0,
                      color: (() {
                        if (loginProvider.getEyeOpenPressStatus()) {
                          return AppUtil.getColorFromHex("#BABABA");
                        }
                        return AppUtil.getColorFromHex("#141414");
                      }()),
                    ),
                  ),
                )
              : SizedBox(),
        ),
      ),
    );
  }

  void setButtonPressStatus(BuildContext context, bool eyePressed) {
    Provider.of<LoginProvider>(context, listen: false)
        .setEyeOpenPressStatus(!eyePressed);
  }

  Widget makeWidget(
      String text,
      TextEditingController controller,
      TextInputAction textinput,
      bool obscureTextVal,
      TextInputType textInput,
      int charLength) {
    return new Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        maxLength: charLength,
        keyboardType: textInput,
        cursorColor: AppUtil.getColorFromHex("#BABABA"),
        textInputAction: textinput,
        controller: controller,
        obscureText: obscureTextVal,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: BorderSide(
                  color: AppUtil.getColorFromHex("#BABABA"), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppUtil.getColorFromHex("#BABABA"), width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            labelStyle: TextStyle(color: AppUtil.getColorFromHex("#BABABA")),
            labelText: text,
            hintText: '',
            counterText: ""),
      ),
    );
  }

  Widget getloginui(
      BuildContext context,
      bool eyeOpen,
      TextEditingController textEditingControllerEmail,
      TextEditingController textEditingControllerPw,
      LoginProvider loginProvider,
      GlobalKey<ScaffoldState> scaffold) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          makeWidget('Email', textEditingControllerEmail, TextInputAction.next,
              false, TextInputType.emailAddress, 40),
          SizedBox(
            height: 15,
          ),
          makecustomePasswordLoginWidget(
              'Password',
              textEditingControllerPw,
              TextInputAction.next,
              eyeOpen,
              TextInputType.text,
              50,
              true,
              'assets/sendpackage/Clock.svg',
              true,
              eyeOpen,
              context,
              loginProvider),
          /* makeWidget('Password', loginPasswordController, TextInputAction.next,
              true, TextInputType.text, 50),*/
          SizedBox(
            height: 40,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                loginProvider.callLoginApi(context, textEditingControllerEmail,
                    textEditingControllerPw, loginProvider, scaffold);
              },
              child: Text(
                'LOGIN',
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                primary: AppUtil.getColorFromHex("02D1CB"),
              ),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
