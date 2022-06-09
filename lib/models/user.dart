import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class AppUser {
  final String? name;
  final String? email;
  final String uid;
  final Map<String, String>? friends;
  final DateTime? createdDate;
  final String? token;
  AppUser(
      {this.name,
      this.email,
      required this.uid,
      this.friends,
      this.createdDate,
      this.token});

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
