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
const int equally = 0;
const int percentage = 1;
const int number = 2;
enum splitType {
  @JsonValue(0)
  equally,
  @JsonValue(1)
  percentage,
  @JsonValue(2)
  number,
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
  final splitType splittype;
  final billstatus status;
  final Map<String, double> memberShares;

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
      required this.splittype,
      required this.status,
      required this.memberShares});

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  Map<String, dynamic> toJson() => _$BillToJson(this);
}
