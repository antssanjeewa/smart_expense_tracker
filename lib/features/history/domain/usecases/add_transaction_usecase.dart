import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  Future<void> call(TransactionEntity transaction) {
    return repository.addTransaction(transaction);
  }
}

class WatchTransactionsUseCase {
  final TransactionRepository repository;

  WatchTransactionsUseCase(this.repository);

  Stream<List<TransactionEntity>> call() {
    return repository.watchTransactions();
  }
}
