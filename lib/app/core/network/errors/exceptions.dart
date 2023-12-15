class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({
    this.statusCode,
    required this.message,
  });
}

class FatalException implements Exception {
  final String message;

  const FatalException({
    required this.message,
  });
}

class FormValidationException implements Exception {
  final dynamic model;

  FormValidationException({
    required this.model,
  });
}

class CacheException implements Exception {}

class InvalidTokenException implements Exception {}

class TypeErrorException implements Exception {}

/// region - MultiAuthPolicyExceptions
class UserNotFoundException implements Exception {}

class UnknownDeviceException implements Exception {}

class BadRequestException implements Exception {}

class UnauthorizedException implements Exception {}

class TypeMatchException implements Exception {}

/// endregion
