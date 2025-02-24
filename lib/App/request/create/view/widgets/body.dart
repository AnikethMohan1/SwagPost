import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:get/get.dart';
import 'package:swag_post/App/request/create/controllers/request_controller.dart';
import 'package:swag_post/Constants/constants.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _errorMessage = '';
  bool _isValid = true;
  int _errorLine = -1;
  final _sc = Get.find<RequestCreateController>();

  @override
  void initState() {
    _sc.bodyController.addListener(
      () {
        _validateJson();
      },
    );

    super.initState();
  }

  void _validateJson() {
    final inputText = _sc.bodyController.text;

    setState(() {
      try {
        jsonDecode(inputText);
        _errorMessage = '';
        _isValid = true;
        _errorLine = -1;
      } catch (e) {
        _errorMessage = e.toString();
        _isValid = false;
        _errorLine = _extractLineNumber(_errorMessage);
      }
    });
  }

  // Extract the line number from the error message
  int _extractLineNumber(String errorMessage) {
    final linePattern = RegExp(r'line (\d+)');
    final match = linePattern.firstMatch(errorMessage);
    if (match != null) {
      return int.parse(match.group(1) ?? '-1');
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Constants.borderColorGrey)),
              child: CodeField(
                lineNumberBuilder: (p0, p1) {
                  if (p0 == _errorLine) {
                    return TextSpan(text: 'Error');
                  }
                  return TextSpan();
                },
                controller: _sc.bodyController,
                minLines: 10,
              ),
            ),
          ),
          if (!_isValid && _sc.bodyController.text != '')
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
        ],
      ),
    );
  }
}
