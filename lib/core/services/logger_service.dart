import 'package:logger/logger.dart';

class LoggerService {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  void t(dynamic msg) => _logger.t(msg);
  void d(dynamic msg) => _logger.d(msg);
  void i(dynamic msg) => _logger.i(msg);
  void w(dynamic msg) => _logger.w(msg);

  void e(dynamic msg, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(msg, error: error, stackTrace: stackTrace);
  }
}
