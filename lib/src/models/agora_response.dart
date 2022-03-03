// Created by Sanjeev Sangral on 08/09/21.
class AgoraResponse {
  String token;

  AgoraResponse({this.token});

  AgoraResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}
