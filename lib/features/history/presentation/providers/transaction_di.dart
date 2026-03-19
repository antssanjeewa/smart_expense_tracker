import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/local/isar_service.dart';
import '../../data/datasources/transaction_local_datasource.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import 'transaction_controller.dart';

// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../data/datasources/transaction_remote_datasource.dart';
// import '../../data/repositories/transaction_repository_impl.dart';

// import '../../domain/repositories/transaction_repository.dart';
// import '../../domain/usecases/add_transaction_usecase.dart';
// import '../../domain/usecases/delete_transaction_usecase.dart';
// import '../../domain/usecases/get_transactions_usecase.dart';
// import '../../domain/usecases/watch_transactions_usecase.dart';

// import 'transaction_controller.dart';

// /// -----------------------------
// /// DATASOURCES
// /// -----------------------------

// final transactionRemoteDataSourceProvider =
//     Provider<TransactionRemoteDataSource>((ref) {
//   final client = ref.watch(supabaseClientProvider);
//   return TransactionRemoteDataSource(client);
// });
final transactionLocalDataSourceProvider =
    Provider<TransactionLocalDataSource>((ref) {
  final isar = ref.watch(isarProvider);
  return TransactionLocalDataSource(isar);
});

// /// -----------------------------
// /// REPOSITORY
// /// -----------------------------

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final localDataSource = ref.watch(transactionLocalDataSourceProvider);
  return TransactionRepositoryImpl(
    local: localDataSource,
  );
});

final transactionsStreamProvider =
    StreamProvider<List<TransactionEntity>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.watchTransactions();
});

// final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
//   return TransactionRepositoryImpl(
//     remote: ref.watch(transactionRemoteDataSourceProvider),
//     local: ref.watch(transactionLocalDataSourceProvider),
//   );
// });

// /// -----------------------------
// /// USE CASES
// /// -----------------------------

// final addTransactionUseCaseProvider = Provider((ref) {
//   return AddTransactionUseCase(
//     ref.watch(transactionRepositoryProvider),
//   );
// });

// final deleteTransactionUseCaseProvider = Provider((ref) {
//   return DeleteTransactionUseCase(
//     ref.watch(transactionRepositoryProvider),
//   );
// });

// final getTransactionsUseCaseProvider = Provider((ref) {
//   return GetTransactionsUseCase(
//     ref.watch(transactionRepositoryProvider),
//   );
// });

// final watchTransactionsUseCaseProvider = Provider((ref) {
//   return WatchTransactionsUseCase(
//     ref.watch(transactionRepositoryProvider),
//   );
// });

// /// -----------------------------
// /// CONTROLLER (STATE)
// /// -----------------------------

final transactionControllerProvider =
    AsyncNotifierProvider.autoDispose<TransactionController, void>(() {
  return TransactionController();
});

// final transactionControllerProvider =
//     StateNotifierProvider<TransactionController, TransactionState>((ref) {
//   return TransactionController(
//     addTransaction: ref.watch(addTransactionUseCaseProvider),
//     deleteTransaction: ref.watch(deleteTransactionUseCaseProvider),
//     getTransactions: ref.watch(getTransactionsUseCaseProvider),
//     watchTransactions: ref.watch(watchTransactionsUseCaseProvider),
//   );
// });
