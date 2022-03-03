import 'dart:convert';

import 'package:connie/src/models/login_req_model.dart';
import 'package:connie/src/models/login_res_model.dart';
import 'package:connie/src/utils/status.dart';

import 'ResponseAPI.dart';
import 'UrlConstant.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
//Client client = Client();

  Future<ResponseApi> getLoginApi(
      LoginReqModel reqModel, Status apiType) async {
    print(UrlConstant.URL_LOGIN_API + "---" + reqModel.toString() + "");

    var response = await http.post(Uri.parse(UrlConstant.URL_LOGIN_API),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqModel));
    print("Response getLoginApi" + response.body);
    return handleStatusCode(response, apiType);
  }

  ResponseApi handleStatusCode(http.Response response, Status apiType) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          print("try--");
          return onResponse200(response.body, apiType);
        } catch (e) {
          print(e.toString());
          return ResponseApi.fail("Path Not Found", apiType);
        }
        break;

      case 404:
        return ResponseApi.fail404("User not found", apiType);
        break;

      case 400:
        break;

      case 500:
      default:
        print("default--");
        return ResponseApi.fail(
            "Unable To Connect. Please try after sometime", apiType);
        break;
    }
  }

  ResponseApi onResponse200(String response, Status status) {
    switch (status) {
      case Status.LOGIN_API:
        LoginResModel model = LoginResModel.fromJson(json.decode(response));
        print("sucess on LOGIN_API");
        return ResponseApi.success(model, status);

      default:
        return ResponseApi.fail(
            "Unable To Connect. Please try after sometime", status);
    }
  }
}
