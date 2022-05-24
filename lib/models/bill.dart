import 'package:json_annotation/json_annotation.dart';

part 'bill.g.dart';

@JsonSerializable()
class Bill {
  final String title;
  final double amount;
  final String billId;
  final DateTime createdDate;
  final DateTime dueDate;
  final String createdUser;
  final String groupId;
  final String? description;
  final String status;

  Bill(
      {required this.title,
      required this.amount,
      required this.billId,
      required this.createdDate,
      required this.dueDate,
      required this.createdUser,
      required this.groupId,
      this.description,
      required this.status});

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  Map<String, dynamic> toJson() => _$BillToJson(this);
}
