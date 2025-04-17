import 'package:logger/web.dart';

abstract class Log {
  void d(String message);
  void e(String message);
  void i(String message);
}

class BobailAiLogger implements Log {
  final _logger = Logger();

  @override
  void d(String message) => _logger.d(message);

  @override
  void e(String message) => _logger.e(message);

  @override
  void i(String message) => _logger.i(message);
}

class SilentLogger implements Log {
  @override
  void d(String message) {}

  @override
  void e(String message) {}

  @override
  void i(String message) {}
}
