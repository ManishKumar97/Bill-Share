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
      splittype: $enumDecode(_$splitTypeEnumMap, json['splittype']),
      status: $enumDecode(_$billstatusEnumMap, json['status']),
      memberShares: (json['memberShares'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
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
      'splittype': _$splitTypeEnumMap[instance.splittype],
      'status': _$billstatusEnumMap[instance.status],
      'memberShares': instance.memberShares,
    };

const _$splitTypeEnumMap = {
  splitType.equally: 0,
  splitType.percentage: 1,
  splitType.number: 2,
};

const _$billstatusEnumMap = {
  billstatus.pending: 1,
  billstatus.settled: 2,
};
