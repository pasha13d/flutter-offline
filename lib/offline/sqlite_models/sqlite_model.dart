class SqliteModels {}

enum Tables {
  Users,
}

class SqliteUpdateStatus {
  bool? isSuccess;
  String? message;
  int? result;

  SqliteUpdateStatus({
    this.isSuccess,
    this.message,
    this.result,
  });

  SqliteUpdateStatus.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}