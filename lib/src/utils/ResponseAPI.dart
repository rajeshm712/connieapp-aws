import 'package:connie/src/utils/status.dart';

class ResponseApi {
  Status status;
  Status apiTypeStatus;
  Object data;

  ResponseApi(Status status, Object data, Status apiTypeStatus) {
    this.status = status;
    this.data = data;
    this.apiTypeStatus = apiTypeStatus;
  }

  static ResponseApi loading(Status apiTypeStatus) {
    return new ResponseApi(Status.LOADING, null, apiTypeStatus);
  }

  static ResponseApi success(Object data, Status apiTypeStatus) {
    return new ResponseApi(Status.SUCCESS, data, apiTypeStatus);
  }

  static ResponseApi fail400(Object data, Status apiTypeStatus) {
    return new ResponseApi(Status.FAIL_400, data, apiTypeStatus);
  }

  static ResponseApi fail404(Object data, Status apiTypeStatus) {
    return new ResponseApi(Status.FAIL_404, data, apiTypeStatus);
  }

  static ResponseApi authFail(Object data, Status apiTypestatus) {
    return new ResponseApi(Status.AUTH_FAIL, null, apiTypestatus);
  }

  static ResponseApi fail(Object data, Status apiTypeStatus) {
    return new ResponseApi(Status.FAIL, data, apiTypeStatus);
  }

  static ResponseApi failDb(String data, Status apiTypeStatus) {
    return new ResponseApi(Status.FAIL_DB, data, apiTypeStatus);
  }
}
