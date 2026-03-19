import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar_community/isar.dart';
import 'isar_collections.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = _initDB();
  }

  Future<Isar> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        IsarCollections.schemas,
        directory: dir.path,
        inspector: true,
      );
    }
    return Isar.getInstance()!;
  }
}

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError();
});
