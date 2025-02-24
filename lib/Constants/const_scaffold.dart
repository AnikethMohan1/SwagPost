import 'package:flutter/material.dart';

class ProjectScaffold extends StatelessWidget {
  const ProjectScaffold(
      {super.key,
      this.body,
      this.appBarleading,
      this.title,
      this.actions,
      this.appbarBackgroundColor,
      this.elevation = 0});
  final Widget? body;
  final Widget? appBarleading;
  final Widget? title;
  final List<Widget>? actions;
  final Color? appbarBackgroundColor;
  final double elevation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: appBarleading,
        title: title,
        actions: actions,
        backgroundColor: appbarBackgroundColor,
        elevation: elevation,
      ),
      body: body,
    );
  }
}
