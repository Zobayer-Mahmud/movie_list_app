abstract class Failure {
  const Failure([this.message]);
  final String? message;
}

class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message]);
}
