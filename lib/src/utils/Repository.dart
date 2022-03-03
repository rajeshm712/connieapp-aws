import 'package:connie/src/models/login_req_model.dart';
import 'package:connie/src/utils/status.dart';

import 'APIProvider.dart';
import 'ResponseAPI.dart';

class Repository {
  ApiProvider appApiProvider = ApiProvider();

  Future<ResponseApi> loginApi(LoginReqModel reqModel, Status apiType) {
    return appApiProvider.getLoginApi(reqModel, apiType);
  }
}
