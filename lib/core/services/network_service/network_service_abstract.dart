import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class NetworkService {
  // Get Response
  Future<http.Response> getHttpResponse({@required Uri uri});

  // Post Method
  Future<http.Response> postHttpResponse({Uri uri, Object body});

  // Unauthenticated Post Method
  Future<http.Response> noAuthPostHttpResponse({Uri uri, Object body});

  // Put Method
  Future<http.Response> putHttpResponse({Uri uri, Object body});

  // Delete Method
  Future<http.Response> deleteHttpResponse({Uri uri, Object body});

  // Delete Method
  Future<http.Response> patchHttpResponse({Uri uri, Object body});

  Map<String, String> getRequestHeaders({bool isNotAuthenticated});
}
