import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  final String? notificationId;
  final bool status;
  final DateTime? whenToNotify;
  final String token;
  final String title;
  final String body;
  final DateTime? createdDate;
  Notification(
      {required this.notificationId,
      required this.status,
      required this.whenToNotify,
      required this.token,
      required this.title,
      required this.body,
      this.createdDate});

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
