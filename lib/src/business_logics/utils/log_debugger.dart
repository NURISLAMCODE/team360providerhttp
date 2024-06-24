
import 'package:logger/logger.dart';

class LogDebugger {
  static final Logger _logger = Logger();

  static Logger get instance => _logger;
}