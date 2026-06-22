class ServerException implements Exception {
  final String? message;

  const ServerException([this.message]);
}

class NetworkException implements Exception {
  final String? message;

  const NetworkException([this.message]);
}

class TimeoutException implements Exception {
  final String? message;

  const TimeoutException([this.message]);
}

class InvalidCredentialsException implements Exception {
  final String? message;

  const InvalidCredentialsException([this.message]);
}

class CacheException implements Exception {
  final String? message;

  const CacheException([this.message]);
}

class LocationException implements Exception {
  final String? message;

  const LocationException([this.message]);
}
