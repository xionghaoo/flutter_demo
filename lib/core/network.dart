class ApiResponse {
  final Status status;
  final String errorMessage;
  final dynamic data;
  ApiResponse(this.status, this.data, {this.errorMessage});
}

enum Status {
  success, failure, loading, none
}

class ResponseSuccessAction {
  final ApiResponse response;
  ResponseSuccessAction(this.response);
}
class ResponseFailureAction {
  final ApiResponse response;
  ResponseFailureAction(this.response);
}
class ResponseLoadingAction {
  final ApiResponse response;
  ResponseLoadingAction(this.response);
}