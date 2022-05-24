// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bill _$BillFromJson(Map<String, dynamic> json) => Bill(
      title: json['title'] as String,
      amount: json['amount'] as double,
      billId: json['billId'] as String,
      createdDate: json['createdDate'] as DateTime,
      dueDate: json['dueDate'] as DateTime,
      createdUser: json['createdUser'] as String,
      groupId: json['groupId'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
    );

Map<String, dynamic> _$BillToJson(Bill instance) => <String, dynamic>{
      'title': instance.title,
      'amount': instance.amount,
      'billId': instance.billId,
      'createdDate': instance.createdDate,
      'dueDate': instance.dueDate,
      'createdUser': instance.createdUser,
      'groupId': instance.groupId,
      'description': instance.description,
      'status': instance.status,
    };
