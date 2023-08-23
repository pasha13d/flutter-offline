import 'sqlite_services.dart';
import 'sqlite_services_impl.dart';

class Offline {
  /// create service instance
  static SqliteServicesImpl? _service;

  static SqliteServices? get API {
    if (_service == null) {
      _service = SqliteServicesImpl();
    }
    return _service;
  }
}