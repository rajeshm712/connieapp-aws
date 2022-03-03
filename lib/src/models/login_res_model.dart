import 'dart:convert';

LoginResModel loginResModelFromJson(String str) =>
    LoginResModel.fromJson(json.decode(str));

String loginResModelToJson(LoginResModel data) => json.encode(data.toJson());

class LoginResModel {
  LoginResModel({
    this.expiresIn,
    this.accessToken,
    this.userId,
    this.status,
  });

  int expiresIn;
  String accessToken;
  String userId;
  int status;

  factory LoginResModel.fromJson(Map<String, dynamic> json) => LoginResModel(
        expiresIn: json["expires_in"] == null ? null : json["expires_in"],
        accessToken: json["access_token"] == null ? null : json["access_token"],
        userId: json["user_id"] == null ? null : json["user_id"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "expires_in": expiresIn == null ? null : expiresIn,
        "access_token": accessToken == null ? null : accessToken,
        "user_id": userId == null ? null : userId,
        "status": status == null ? null : status,
      };
}
