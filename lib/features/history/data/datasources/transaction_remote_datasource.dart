// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/transaction_model.dart';

// class TransactionRemoteDataSource {
//   final SupabaseClient client;

//   TransactionRemoteDataSource(this.client);

//   Future<void> addTransaction(TransactionModel model) async {
//     await client.from('transactions').insert(model.toJson());
//   }

//   Future<void> deleteTransaction(String id) async {
//     await client.from('transactions').delete().eq('id', id);
//   }

//   Future<List<TransactionModel>> getTransactions(String userId) async {
//     final res = await client
//         .from('transactions')
//         .select()
//         .eq('user_id', userId)
//         .order('date', ascending: false);

//     return (res as List).map((e) => TransactionModel.fromJson(e)).toList();
//   }
// }
