import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class billNotification {
  final String? notificationId;
  final bool status;
  final DateTime? whenToNotify;
  final String token;
  final String title;
  final String body;
  final DateTime? createdDate;
  billNotification(
      {required this.notificationId,
      required this.status,
      required this.whenToNotify,
      required this.token,
      required this.title,
      required this.body,
      this.createdDate});

  factory billNotification.fromJson(Map<String, dynamic> json) =>
      _$billNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$billNotificationToJson(this);
}
