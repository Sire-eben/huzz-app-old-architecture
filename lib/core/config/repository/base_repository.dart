import 'dart:async';
import 'dart:io';

import 'package:huzz/core/config/model/result_model.dart';

class BaseRepositoryImpl implements BaseRepository {
  @override
  Future<Result> buildErrorResponse({error}) async {
    var result = Result();
    if (error is SocketException) {
      result = Result(
        isSuccessful: false,
        data: null,
        message: 'Check your network connection',
      );
    }
    if (error is TimeoutException) {
      result = Result(
        isSuccessful: false,
        data: null,
        message: 'Network request timed out. Try again.',
      );
    }
    if (error is HttpException) {
      result = Result(
        isSuccessful: false,
        data: null,
        message: 'Something went wrong',
      );
    }
    return result;
  }
}

abstract class BaseRepository {
  Future<Result> buildErrorResponse({dynamic error});
}
