import 'app_services.dart';
import 'app_services_impl.dart';

class WEB {
  // create service instance
  static AppServicesImpl? _service;

  static AppServices? get API {
    if (_service == null) {
      _service = AppServicesImpl();
    }
    return _service;
  }
}