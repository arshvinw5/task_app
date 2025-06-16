// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String token;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  // UserModel copyWith({
  //   String? id,
  //   String? name,
  //   String? email,
  //   String? password,
  //   String? confirmPassword,
  //   String? createdAt,
  //   String? updatedAt,
  //   String? token,
  // }) {
  //   return UserModel(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     email: email ?? this.email,
  //     password: password ?? this.password,
  //     confirmPassword: confirmPassword ?? this.confirmPassword,
  //     createdAt: createdAt ?? this.createdAt,
  //     updatedAt: updatedAt ?? this.updatedAt,
  //     token: token ?? this.token,
  //   );
  // }

  //object -> map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'token': token,
    };
  }

  //map -> user model objeect
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      token: map['token'] ?? '',
      confirmPassword: map['confirmPassword'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, password: $password, confirmPassword: $confirmPassword, createdAt: $createdAt, updatedAt: $updatedAt, token: $token)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.confirmPassword == confirmPassword &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.token == token;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        confirmPassword.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        token.hashCode;
  }
}
