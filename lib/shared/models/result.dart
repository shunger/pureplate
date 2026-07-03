/// A sealed union type representing either a successful value or a failure.
///
/// Use [Result.success] to wrap a successful computation and [Result.failure]
/// to represent an error with an optional underlying exception.
sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;

  const factory Result.failure(String message, [Object? error]) = Failure<T>;

  T? get dataOrNull;

  bool get isSuccess;

  bool get isFailure;

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) failure,
  });
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  T? get dataOrNull => data;

  @override
  bool get isSuccess => true;

  @override
  bool get isFailure => false;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) failure,
  }) {
    return success(data);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Result.success($data)';
}

final class Failure<T> extends Result<T> {
  const Failure(this.message, [this.error]);

  final String message;

  final Object? error;

  @override
  T? get dataOrNull => null;

  @override
  bool get isSuccess => false;

  @override
  bool get isFailure => true;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) failure,
  }) {
    return failure(message, error);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          message == other.message &&
          error == other.error;

  @override
  int get hashCode => Object.hash(message, error);

  @override
  String toString() => 'Result.failure($message, $error)';
}
