class ResultState<T> {
  Status? status;
  T? data;
  String? message;

  ResultState(this.status, this.data, this.message);
  ResultState.loading() : status = Status.loading;
  ResultState.success(this.data) : status = Status.success;
  ResultState.failure(this.message) : status = Status.failure;
  ResultState.noConnection() : status = Status.noConnection;
  ResultState.empty() : status = Status.empty;
  ResultState.idle() : status = Status.idle;
}

enum Status { loading, success, failure, empty, noConnection, idle }