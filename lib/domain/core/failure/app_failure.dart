class SocketFailure extends AppFailure {
  SocketFailure({String? message})
      : super(message ?? "Check your internet connection and tryagain");
}

class TimeoutFailure extends AppFailure {
  TimeoutFailure() : super("youre internet connection is too slow");
}

class ServerFailure extends AppFailure {
  ServerFailure(String message) : super(message);
}

class ClientFailure extends AppFailure {
  ClientFailure(String message) : super(message);
}

class UserNotFoundFailure extends AppFailure {
  UserNotFoundFailure(String message) : super(message);
}

class TokenFailure extends AppFailure {
  TokenFailure(String message) : super(message);
}

class DataValidationFailure extends AppFailure {
  DataValidationFailure(String message) : super(message);
}

abstract class AppFailure {
  final String message;
  AppFailure(this.message);
}
