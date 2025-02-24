import 'package:get/route_manager.dart';
import 'package:swag_post/App/workspace_home/bindings/bindings.dart';
import 'package:swag_post/App/workspace_home/view/workspace_home_view.dart';
import 'package:swag_post/App/request/create/bindings/request_create_bindings.dart';
import 'package:swag_post/App/request/create/view/request_create.dart';
import 'package:swag_post/routes/device_switcher.dart';
import 'package:swag_post/routes/routes_name.dart';

class AppPages {
  static List<GetPage> getPages() {
    return [..._createRequest(), ..._introPages()];
  }

  static List<GetPage> _introPages() {
    return [
      GetPage(
        name: RoutesName.workSpaceHome,
        binding: WorkSpaceHomeBindings(),
        page: () => const DeviceViewSwitcher(
            mobileView: HomeScreen(), desktopView: HomeScreen()),
      )
    ];
  }

  static List<GetPage> _createRequest() {
    return [
      GetPage(
        name: RoutesName.requestCreate,
        binding: RequestCreateBindings(),
        page: () => DeviceViewSwitcher(
            mobileView: CreateRequest(), desktopView: CreateRequest()),
      )
    ];
  }
}
