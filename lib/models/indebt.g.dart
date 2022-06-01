// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'indebt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Indebt _$IndebtFromJson(Map<String, dynamic> json) => Indebt(
      indebtId: json['indebtId'] as String,
      groupId: json['groupId'] as String,
      owedTo: json['owedTo'] as String,
      owedBy: json['owedBy'] as String,
      amount: (json['amount'] as num).toDouble(),
      billId: json['billId'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: $enumDecode(_$indebtstatusEnumMap, json['status']),
    );

Map<String, dynamic> _$IndebtToJson(Indebt instance) => <String, dynamic>{
      'indebtId': instance.indebtId,
      'groupId': instance.groupId,
      'owedTo': instance.owedTo,
      'owedBy': instance.owedBy,
      'amount': instance.amount,
      'billId': instance.billId,
      'createdDate': instance.createdDate.toIso8601String(),
      'dueDate': instance.dueDate.toIso8601String(),
      'status': _$indebtstatusEnumMap[instance.status],
    };

const _$indebtstatusEnumMap = {
  indebtstatus.pending: 1,
  indebtstatus.settled: 2,
};
