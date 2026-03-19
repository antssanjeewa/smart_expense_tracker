import 'package:isar_community/isar.dart';
import '../../domain/entities/transaction_entity.dart';

part 'transaction_model.g.dart';

@collection
class TransactionModel {
  Id id = Isar.autoIncrement;

  late String title;
  late double amount;
  late DateTime date;

  @enumerated
  late TransactionType type;

  late String categoryId;
  late String walletId;
  String? note;
  String? remoteId;

  TransactionModel();

  // factory TransactionModel.fromJson(Map<String, dynamic> json) {
  //   return TransactionModel(
  //     id: json['id'],
  //     userId: json['user_id'],
  //     amount: (json['amount'] as num).toDouble(),
  //     category: json['category'],
  //     type: json['type'],
  //     date: DateTime.parse(json['date']),
  //     note: json['note'],
  //   );
  // }

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'user_id': userId,
  //       'amount': amount,
  //       'category': category,
  //       'type': type,
  //       'date': date.toIso8601String(),
  //       'note': note,
  //     };

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel()
      ..title = entity.title
      ..amount = entity.amount
      ..date = entity.date
      ..type = entity.type
      ..categoryId = entity.categoryId
      ..walletId = entity.walletId
      ..note = entity.note
      ..remoteId = entity.remoteId;
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      title: title,
      amount: amount,
      date: date,
      type: type,
      categoryId: categoryId,
      walletId: walletId,
      note: note,
      remoteId: remoteId,
    );
  }
}
