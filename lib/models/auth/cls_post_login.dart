import 'dart:convert';

ModelPostLogin modelPostLoginFromJson(String str) =>
    ModelPostLogin.fromJson(json.decode(str));

String modelPostLoginToJson(ModelPostLogin data) => json.encode(data.toJson());

class ModelPostLogin {
  ModelPostLogin({
    this.username,
    this.password,
  });

  String? username;
  String? password;

  factory ModelPostLogin.fromJson(Map<String, dynamic> json) => ModelPostLogin(
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}
