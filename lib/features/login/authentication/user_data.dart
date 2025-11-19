class UserData {
  String? emailId;
  String? password;

  UserData({this.emailId, this.password});

  UserData.fromJson(Map<String, dynamic> json) {
    emailId = json['emailId'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['emailId'] = emailId;
    data['password'] = password;
    return data;
  }
}
