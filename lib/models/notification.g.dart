// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

billNotification _$billNotificationFromJson(Map<String, dynamic> json) =>
    billNotification(
      notificationId: json['notificationId'] as String?,
      status: json['status'] as bool,
      whenToNotify: json['whenToNotify'] == null
          ? null
          : DateTime.parse(json['whenToNotify'] as String),
      token: json['token'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
    );

Map<String, dynamic> _$billNotificationToJson(billNotification instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'status': instance.status,
      'whenToNotify': instance.whenToNotify?.toIso8601String(),
      'token': instance.token,
      'title': instance.title,
      'body': instance.body,
      'createdDate': instance.createdDate?.toIso8601String(),
    };
