enum AsyncValueState { loading, error, success }

class AsyncValue<T> {
  final T? data;
  final Object? error;
  final AsyncValueState state;

  AsyncValue._({this.data, this.error, required this.state});

  factory AsyncValue.loading() => AsyncValue._(state: AsyncValueState.loading);

  factory AsyncValue.success(T data) =>
      AsyncValue._(data: data, state: AsyncValueState.success);

  factory AsyncValue.error(Object error) =>
      AsyncValue._(error: error, state: AsyncValueState.error);

  AsyncValue<T> whenData(T Function(T data) update) {
    if (state == AsyncValueState.success && data != null) {
      return AsyncValue.success(update(data as T));
    }
    return this;
  }
}
