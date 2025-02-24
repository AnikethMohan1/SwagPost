import 'package:get/get.dart';
import 'package:swag_post/App/request/create/controllers/request_controller.dart';

import 'package:swag_post/App/workspace_home/controller/workspace_home_controller.dart';

class WorkSpaceHomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => RequestCreateController(),
    );
    Get.lazyPut(
      () => WorkspaceHomeController(),
    );
  }
}
