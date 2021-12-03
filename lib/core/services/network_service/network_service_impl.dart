import 'dart:convert';

import 'package:http/http.dart' as http;
import 'network_service_abstract.dart';

class NetworkServiceImpl implements NetworkService {
  @override
  Map<String, String> getRequestHeaders({bool? isNotAuthenticated}) {
    Map<String, String> headers = <String, String>{};
    headers['Content-Type'] = 'application/json';

    if (!isNotAuthenticated!) {
      String token = jsonDecode('token' ?? '');
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  @override
  Future<http.Response> deleteHttpResponse({Uri? uri, Object? body}) async {
    http.Response res;
    res = await http
        .delete(
          uri!,
          headers: getRequestHeaders(),
          body: jsonEncode(body),
        )
        .timeout(Duration(seconds: 45));
    return res;
  }

  @override
  Future<http.Response> getHttpResponse({Uri? uri}) async {
    http.Response res;
    res = await http
        .get(uri!, headers: getRequestHeaders())
        .timeout(Duration(seconds: 45));
    return res;
  }

  @override
  Future<http.Response> patchHttpResponse({Uri? uri, Object? body}) async {
    http.Response res;
    res = await http
        .patch(
          uri!,
          headers: getRequestHeaders(),
          body: jsonEncode(body),
        )
        .timeout(Duration(seconds: 45));
    return res;
  }

  @override
  Future<http.Response> postHttpResponse({Uri? uri, Object? body}) async {
    http.Response res;
    res = await http
        .post(
          uri!,
          headers: getRequestHeaders(),
          body: jsonEncode(body),
        )
        .timeout(Duration(seconds: 45));
    return res;
  }

  @override
  Future<http.Response> putHttpResponse({Uri? uri, Object? body}) async {
    http.Response res;
    res = await http
        .post(
          uri!,
          headers: getRequestHeaders(),
          body: jsonEncode(body),
        )
        .timeout(Duration(seconds: 45));
    return res;
  }

  @override
  Future<http.Response> noAuthPostHttpResponse({Uri? uri, Object? body}) async {
    http.Response res;
    res = await http
        .post(
          uri!,
          headers: getRequestHeaders(isNotAuthenticated: true),
          body: jsonEncode(body),
        )
        .timeout(Duration(seconds: 45));
    return res;
  }
}
