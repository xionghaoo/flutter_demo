class ApiResponse {
  final Status status;
  final String errorMessage;
  final dynamic data;
  ApiResponse(this.status, {this.data, this.errorMessage});
}

enum Status {
  success, failure, loading, none
}