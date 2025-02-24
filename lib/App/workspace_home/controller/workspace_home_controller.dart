import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swag_post/App/request/create/view/request_create.dart';
import 'package:swag_post/App/workspace_home/view/widgets/overview.dart';
import 'package:swag_post/App/workspace_home/view/workspace_home_view.dart';

class WorkspaceHomeController extends GetxController {
  RxList<Widget> swagPostTabs =
      <Widget>[TabWidget(title: 'Overview', index: 0)].obs;
  RxList<Widget> swagPostTabWiget = <Widget>[Overview()].obs;

  addTab() {
    final newIndex = swagPostTabs.length + 1;
    final controllerId = 'workspace_controller_$newIndex';
    Get.parameters['id'] = newIndex.toString();

    swagPostTabs.add(TabWidget(title: 'Get', index: swagPostTabs.length + 1));
    swagPostTabWiget.add(CreateRequest(
      key: UniqueKey(),
      controllerId: controllerId,
    ));
  }
}
