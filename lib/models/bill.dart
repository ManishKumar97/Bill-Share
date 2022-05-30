import 'package:json_annotation/json_annotation.dart';

part 'bill.g.dart';

const int pending = 1;
const int settled = 2;
enum billstatus {
  @JsonValue(1)
  pending,
  @JsonValue(2)
  settled,
}

@JsonSerializable()
class Bill {
  final String title;
  final double amount;
  final String billId;
  final DateTime createdDate;
  final DateTime dueDate;
  final String paidBy;
  final String createdUserID;
  final String groupId;
  final String? comments;
  final billstatus status;

  Bill(
      {required this.title,
      required this.amount,
      required this.billId,
      required this.createdDate,
      required this.dueDate,
      required this.paidBy,
      required this.createdUserID,
      required this.groupId,
      this.comments,
      required this.status});

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  Map<String, dynamic> toJson() => _$BillToJson(this);
}
