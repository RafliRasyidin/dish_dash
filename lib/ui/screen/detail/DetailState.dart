class DetailState<T> {
  Status? status;
  T? data;
  String? message;

  DetailState(this.status, this.data, this.message);
  DetailState.loading() : status = Status.loading;
  DetailState.hasData(this.data) : status = Status.hasData;
  DetailState.failure(this.message) : status = Status.failure;
  DetailState.noConnection() : status = Status.noConnection;
  DetailState.empty() : status = Status.empty;
  DetailState.idle() : status = Status.idle;
  DetailState.success(this.data) : status = Status.success;
}

enum Status { loading, hasData, success, failure, empty, noConnection, idle }