class Result<T> {
  bool isSuccessful = false;
  T data;
  String message = '';

  Result({
    this.isSuccessful = false,
    this.message = '',
    this.data,
  });

  Result.initial()
      : isSuccessful = false,
        message = '';
}
