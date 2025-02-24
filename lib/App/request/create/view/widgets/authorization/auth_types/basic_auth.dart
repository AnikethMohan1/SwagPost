import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swag_post/App/request/create/controllers/request_controller.dart';
import 'package:swag_post/Constants/attributes.dart';
import 'package:swag_post/Constants/constants.dart';

final username = TextEditingController();
final password = TextEditingController();

class BasicAuth extends StatefulWidget {
  const BasicAuth({super.key});

  @override
  State<BasicAuth> createState() => _BasicAuthState();
}

class _BasicAuthState extends State<BasicAuth> {
  final _sc = Get.find<RequestCreateController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: Get.width * 0.1, top: 40, left: Get.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Username',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                width: Get.width * 0.2,
                child: TextField(
                  controller: username,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  onChanged: (value) {
                    _sc.authConfiguration.credentials['username'] =
                        username.text;
                    log('${_sc.authConfiguration.credentials}');
                  },
                  decoration: const InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(
                          color: Constants.borderColorGrey, fontSize: 12),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.borderColorGrey)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.borderColorGrey))),
                ),
              ),
            ],
          ),
          kVSpaceM,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Password',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                width: Get.width * 0.2,
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  controller: password,
                  onChanged: (value) {
                    _sc.authConfiguration.credentials['password'] =
                        password.text;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          color: Constants.borderColorGrey, fontSize: 12),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.borderColorGrey)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.borderColorGrey))),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
