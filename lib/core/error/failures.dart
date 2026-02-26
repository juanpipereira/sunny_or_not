import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

final class ServerFailure extends Failure {
  const ServerFailure(
      [super.message = 'Something went wrong. Please, try again']);
}

final class ConnectionFailure extends Failure {
  const ConnectionFailure(
      [super.message = 'Please, check your internet connection']);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure(
      [super.message = 'An unexpected error occurred. Please, try again']);
}

final class LocationNotFoundFailure extends Failure {
  const LocationNotFoundFailure([super.message = 'City not found']);
}

final class GpsPermissionFailure extends Failure {
  const GpsPermissionFailure([super.message = 'GPS permission is required']);
}
