// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bill _$BillFromJson(Map<String, dynamic> json) => Bill(
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      billId: json['billId'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      paidBy: json['paidBy'] as String,
      createdUserID: json['createdUserID'] as String,
      groupId: json['groupId'] as String,
      comments: json['comments'] as String?,
      status: $enumDecode(_$billstatusEnumMap, json['status']),
    );

Map<String, dynamic> _$BillToJson(Bill instance) => <String, dynamic>{
      'title': instance.title,
      'amount': instance.amount,
      'billId': instance.billId,
      'createdDate': instance.createdDate.toIso8601String(),
      'dueDate': instance.dueDate.toIso8601String(),
      'paidBy': instance.paidBy,
      'createdUserID': instance.createdUserID,
      'groupId': instance.groupId,
      'comments': instance.comments,
      'status': _$billstatusEnumMap[instance.status],
    };

const _$billstatusEnumMap = {
  billstatus.pending: 1,
  billstatus.settled: 2,
};
