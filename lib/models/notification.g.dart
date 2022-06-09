// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

billNotification _$billNotificationFromJson(Map<String, dynamic> json) =>
    billNotification(
      notificationId: json['notificationId'] as String?,
      status: json['status'] as bool,
      year: json['year'] as int,
      month: json['month'] as int,
      day: json['day'] as int,
      hours: json['hours'] as int,
      minutes: json['minutes'] as int,
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
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'hours': instance.hours,
      'minutes': instance.minutes,
      'token': instance.token,
      'title': instance.title,
      'body': instance.body,
      'createdDate': instance.createdDate?.toIso8601String(),
    };
