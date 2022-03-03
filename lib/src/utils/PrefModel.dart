class PrefModel {
  String userName;
  bool isLogin;
  String backgroundnNotificationData;
  String deviceToken;
  String userId;
  String preferencesModel;
  String deepLink;
  String notificationMsg;
  bool isTermsConditions;

  PrefModel(
      {this.userName,
      this.deviceToken,
      this.preferencesModel,
      this.notificationMsg,
      this.userId,
      this.deepLink,
      this.isLogin,
      this.isTermsConditions,
      this.backgroundnNotificationData});

  factory PrefModel.fromJson(Map<String, dynamic> parsedJson) {
    return new PrefModel(
        userName: parsedJson['userName'] ?? "",
        deepLink: parsedJson['deepLink'] ?? "",
        notificationMsg: parsedJson['notificationMsg'] ?? "",
        preferencesModel: parsedJson['preferencesModel'] ?? "",
        deviceToken: parsedJson['deviceToken'] ?? "",
        userId: parsedJson['userId'] ?? "",
        isTermsConditions: parsedJson['isTermsConditions'] ?? false,
        backgroundnNotificationData:
            parsedJson['backgroundnNotificationData'] ?? "",
        isLogin: parsedJson['isLogin'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      "userName": this.userName,
      "deepLink": this.deepLink,
      "notificationMsg": this.notificationMsg,
      "deviceToken": this.deviceToken,
      "preferencesModel": this.preferencesModel,
      "userId": this.userId,
      "isTermsConditions": this.isTermsConditions,
      "backgroundnNotificationData": this.backgroundnNotificationData,
      "isLogin": this.isLogin
    };
  }
}
