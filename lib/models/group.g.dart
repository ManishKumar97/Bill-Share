// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      groupId: json['groupId'] as String,
      type: $enumDecode(_$groupTypeEnumMap, json['type']),
      name: json['name'] as String,
      membersUids: (json['membersUids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      members:
          (json['members'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'groupId': instance.groupId,
      'type': _$groupTypeEnumMap[instance.type],
      'name': instance.name,
      'membersUids': instance.membersUids,
      'members': instance.members,
    };

const _$groupTypeEnumMap = {
  groupType.individual: 1,
  groupType.group: 2,
};
