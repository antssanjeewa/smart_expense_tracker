import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  // final TransactionRemoteDataSource remote;
  final TransactionLocalDataSource local;
  final logger = LoggerService();

  TransactionRepositoryImpl({
    // required this.remote,
    required this.local,
  });

  @override
  Future<void> addTransaction(TransactionEntity entity) async {
    try {
      final model = TransactionModel.fromEntity(entity);
      // await remote.addTransaction(model);
      await local.saveTransaction(model);
      logger.i("addTransaction Success");
    } catch (e) {
      logger.e("addTransaction process failed", e);
      throw AppException.fromError(e);
    }
  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final localData = await local.getAllTransactions();
    return localData.map((model) => model.toEntity()).toList();

    // if (localData.isNotEmpty) {
    //   return localData.map((e) => e.toEntity()).toList();
    // }

    // final remoteData = await remote.getTransactions(userId);
    // return remoteData.map((e) => e.toEntity()).toList();
  }

  @override
  Stream<List<TransactionEntity>> watchTransactions() {
    return local.watchTransactions().map(
          (models) => models.map((model) => model.toEntity()).toList(),
        );
  }

  @override
  Future<void> deleteTransaction(int id) async {
    // await remote.deleteTransaction(id);
    await local.deleteTransaction(id);
  }
}
