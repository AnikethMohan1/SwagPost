import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swag_post/App/workspace_home/controller/workspace_home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _sc = Get.find<WorkspaceHomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return DefaultTabController(
            length: _sc.swagPostTabs.length,
            child: Scaffold(
              appBar: AppBar(
                  title: Row(
                children: [
                  _sc.swagPostTabs.isNotEmpty
                      ? Expanded(
                          child: TabBar(
                              indicatorSize: TabBarIndicatorSize.label,
                              tabs: _sc.swagPostTabs))
                      : Container(),
                  IconButton(
                      onPressed: () {
                        _sc.addTab();
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ))
                ],
              )),
              body: Expanded(
                child: TabBarView(
                  children: _sc.swagPostTabWiget,
                ),
              ),
            ));
      },
    );
  }
}

class TabWidget extends StatelessWidget {
  const TabWidget({super.key, required this.title, required this.index});
  final String title;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(),
      width: 100,
      child: Row(
        children: [
          Icon(Icons.remove_red_eye_sharp),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          index != 0 ? Divider() : SizedBox()
        ],
      ),
    );
  }
}
