import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(int id);
  Future<List<TransactionEntity>> getTransactions();
  Stream<List<TransactionEntity>> watchTransactions();
}
