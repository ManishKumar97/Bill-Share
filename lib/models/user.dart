import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class AppUser {
  final String? name;
  final String? email;
  final String uid;
  final List<Map<String, String>>? friends;
  final DateTime? createdDate;
  AppUser(
      {this.name,
      this.email,
      required this.uid,
      this.friends,
      this.createdDate});

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}