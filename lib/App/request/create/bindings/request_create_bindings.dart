import 'package:get/get.dart';
import 'package:swag_post/App/request/create/controllers/request_controller.dart';

class RequestCreateBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => RequestCreateController(),
    );
  }
}
