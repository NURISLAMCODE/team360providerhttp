class ResponseObject {
  int id;
  Object object;

  ResponseObject({this.id = 500, required this.object});
}

class ResponseCode {
  static const int NO_INTERNET_CONNECTION = 0;
  static const int AUTHORIZATION_FAILED = 900;
  static const int SUCCESSFUL = 200;
  static const int FAILED = 501;
  static const int NOT_FOUND = 502;
}

