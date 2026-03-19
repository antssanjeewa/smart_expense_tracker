import 'package:isar_community/isar.dart';

import '../models/transaction_model.dart';

class TransactionLocalDataSource {
  final Isar isar;

  TransactionLocalDataSource(this.isar);

  Future<void> saveTransaction(TransactionModel model) async {
    await isar.writeTxn(() async {
      await isar.transactionModels.put(model);
    });
  }

  Future<List<TransactionModel>> getAllTransactions() async {
//     return await isar.transactionModels
//         .filter()
//         .userIdEqualTo(userId)
//         .sortByDateDesc()
//         .findAll();
    return await isar.transactionModels.where().findAll();
  }

  Stream<List<TransactionModel>> watchTransactions() {
//     return isar.transactionModels
//         .filter()
//         .userIdEqualTo(userId)
//         .watch(fireImmediately: true);
    return isar.transactionModels.where().watch(fireImmediately: true);
  }

  Future<void> deleteTransaction(int id) async {
    await isar.writeTxn(() async {
      await isar.transactionModels.delete(id);
    });
  }
}
