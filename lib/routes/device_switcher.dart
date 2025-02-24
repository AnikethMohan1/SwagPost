import 'package:flutter/material.dart';

class DeviceViewSwitcher extends StatefulWidget {
  final Widget mobileView;
  final Widget desktopView;
  const DeviceViewSwitcher(
      {Key? key, required this.mobileView, required this.desktopView})
      : super(key: key);

  @override
  State<DeviceViewSwitcher> createState() => _DeviceViewSwitcherState();
}

class _DeviceViewSwitcherState extends State<DeviceViewSwitcher> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return widget.mobileView;
        } else {
          return widget.desktopView;
        }
      },
    );
  }
}
