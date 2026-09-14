sealed class Failure implements Exception {
  const Failure(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection. Check your network and retry.']) : super(message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([String message = 'The request timed out. Please try again.']) : super(message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String message = 'Your session has expired. Please sign in again.']) : super(message, 401);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure([String message = 'You do not have permission to do that.']) : super(message, 403);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'The requested record was not found.']) : super(message, 404);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message, {this.errors = const <String>[]}) : super(message, 400);

  final List<String> errors;
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Something went wrong. Please try again.', int? code]) : super(message, code);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String message = 'An unexpected error occurred.']) : super(message);
}
