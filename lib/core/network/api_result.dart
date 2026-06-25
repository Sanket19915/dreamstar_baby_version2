class ApiResult<T> {
  final T? data;
  final String? errorMessage;
  final int? statusCode;
  final Map<String, String>? fieldErrors;

  const ApiResult._({
    this.data,
    this.errorMessage,
    this.statusCode,
    this.fieldErrors,
  });

  bool get isSuccess => errorMessage == null && data != null;

  factory ApiResult.success(T data, {int? statusCode}) {
    return ApiResult._(data: data, statusCode: statusCode);
  }

  factory ApiResult.failure(
    String message, {
    int? statusCode,
    Map<String, String>? fieldErrors,
  }) {
    return ApiResult._(
      errorMessage: message,
      statusCode: statusCode,
      fieldErrors: fieldErrors,
    );
  }
}
