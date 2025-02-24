import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:swag_post/App/request/create/controllers/request_controller.dart';

import 'package:swag_post/Constants/constants.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ResponseSheet extends StatefulWidget {
  const ResponseSheet({super.key});

  @override
  State<ResponseSheet> createState() => _ResponseSheetState();
}

class _ResponseSheetState extends State<ResponseSheet> {
  // Height constraints for the bottom sheet
  final double _minHeight = 50.0;
  final double _maxHeight = Get.height * 0.8;

  // Current height of the bottom sheet
  double _currentHeight = Get.height * 0.2;
  final _sc = Get.find<RequestCreateController>();

  indentJson(var json) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(json);
    return prettyprint;
  }

  _addNewLinesAfterKeys(String jsonString) {
    // Use a regular expression to find all key-value pairs and add new lines after each one
    final regex = RegExp(r'("\w+":)');
    return jsonString.replaceAllMapped(regex, (match) {
      return '${match.group(0)}\n'.toString(); // Add a new line after the key
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int statusCode = _sc.apiResponse.value?.statusCode ?? 404;
      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          height: _currentHeight,
          decoration: const BoxDecoration(
            color: Constants.scaffoldBackground,
          ),
          child: ListView(
            children: [
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _currentHeight -= details.delta.dy;

                    _currentHeight =
                        _currentHeight.clamp(_minHeight, _maxHeight);
                  });
                },
                child: const MouseRegion(
                  cursor: SystemMouseCursors.resizeUpDown,
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Divider(
                        color: Constants.borderColorGrey,
                        height: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Response',
                    style: TextStyle(color: Colors.white),
                  ),
                  _currentHeight != 50
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              _currentHeight = 50;
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_down_rounded))
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              _currentHeight = Get.height * 0.5;
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_up_rounded))
                ],
              ),
              if (_sc.apiLoadingStatus.value!.isLoading) ...[
                const LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: Constants.borderColorGrey,
                  color: Constants.buttonColor,
                )
              ],
              if (_sc.apiLoadingStatus.value!.isSuccess) ...[
                if (statusCode >= 200 && statusCode <= 201) ...[
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.green,
                  ).animate(delay: const Duration(milliseconds: 100)).fadeOut()
                ]
              ] else if (_sc.apiLoadingStatus.value!.isError) ...[
                if (statusCode >= 300 && statusCode < 399) ...[
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.orange,
                  ).animate(delay: const Duration(milliseconds: 100)).fadeOut()
                ] else ...[
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.red,
                  ).animate(delay: const Duration(milliseconds: 100)).fadeOut()
                ],
              ],
              if (_sc.apiResponse.value == null) ...[
                emptyResponse(),
              ] else ...[
                Text(
                  '${_sc.apiResponse.value?.data}',
                  style: TextStyle(color: Colors.white),
                )
              ]
            ],
          ),
        ),
      );
    });
  }

  Expanded emptyResponse() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(Get.width / 2.3, _currentHeight / 5),
                child: Column(
                  children: [
                    SvgPicture.network(
                        'https://postman.com/_aether-assets/illustrations/dark/illustration-hit-send.svg'),
                    Text(
                      'Click Send to get a response',
                      style: TextStyle(color: Constants.borderColorGrey),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
