import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

const int individual = 1;
const int group = 2;
enum groupType {
  @JsonValue(1)
  individual,
  @JsonValue(2)
  group,
}

@JsonSerializable()
class Group {
  final String groupId;
  final groupType type;
  final String name;
  final Map<String, String> members;
  final List<String> membersUids;
  // final List<String>? members;
  final DateTime? createdDate;
  Group({
    required this.groupId,
    required this.type,
    required this.name,
    required this.membersUids,
    // this.members,
    required this.members,
    this.createdDate,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
