import 'transaction_type.dart';

class TransactionEntity {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String categoryId;
  final String walletId;
  final String? note;
  final String? remoteId;

  TransactionEntity({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.categoryId,
    required this.walletId,
    this.note,
    this.remoteId,
  });
}
