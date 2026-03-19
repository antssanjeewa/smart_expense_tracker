import 'package:isar_community/isar.dart';

import '../../../features/history/data/models/transaction_model.dart';

class IsarCollections {
  static List<CollectionSchema<dynamic>> get schemas => [
        TransactionModelSchema,

        //
      ];
}
