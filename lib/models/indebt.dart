import 'package:json_annotation/json_annotation.dart';

part 'indebt.g.dart';

const int pending = 1;
const int settled = 2;
enum indebtstatus {
  @JsonValue(1)
  pending,
  @JsonValue(2)
  settled,
}

@JsonSerializable()
class Indebt {
  final String indebtId;
  final String owedTo;
  final String owedBy;
  final double amount;
  final String billId;
  final DateTime createdDate;
  final DateTime dueDate;
  final indebtstatus status;

  Indebt(
      {required this.indebtId,
      required this.owedTo,
      required this.owedBy,
      required this.amount,
      required this.billId,
      required this.createdDate,
      required this.dueDate,
      required this.status});

  factory Indebt.fromJson(Map<String, dynamic> json) => _$IndebtFromJson(json);

  Map<String, dynamic> toJson() => _$IndebtToJson(this);
}
