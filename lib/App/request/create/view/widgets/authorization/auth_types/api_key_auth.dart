import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swag_post/App/request/create/controllers/request_controller.dart';
import 'package:swag_post/Constants/attributes.dart';

import '../../../../../../../Constants/constants.dart';

class ApiKey extends StatefulWidget {
  const ApiKey({super.key});

  @override
  State<ApiKey> createState() => _ApiKeyState();
}

TextEditingController keyApiKey = TextEditingController();
TextEditingController valueApiKey = TextEditingController();
TextEditingController addtoController = TextEditingController();

class _ApiKeyState extends State<ApiKey> {
  Map addto = {'Header': 'header', 'Query Paramerter': 'query'};
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
                'Key',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                width: Get.width * 0.2,
                child: TextField(
                  controller: keyApiKey,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  onChanged: (value) {
                    _sc.authConfiguration.credentials['keyName'] =
                        keyApiKey.text;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Key',
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
                'Value',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                width: Get.width * 0.2,
                child: TextField(
                  controller: valueApiKey,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  onChanged: (value) {
                    _sc.authConfiguration.credentials['apiKey'] =
                        valueApiKey.text;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Value',
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
                'Add to',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                  width: Get.width * 0.2,
                  child: DropdownMenu(
                    controller: addtoController,
                    initialSelection: addto.entries.first.value,
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 12),
                    requestFocusOnTap: false,
                    enableSearch: false,
                    onSelected: (value) {
                      _sc.authConfiguration.credentials['location'] = value;
                      log('$value');
                    },
                    focusNode: FocusNode(),
                    dropdownMenuEntries: addto.entries.map(
                      (e) {
                        return DropdownMenuEntry(
                            value: e.value,
                            label: e.key,
                            labelWidget: Text(
                              e.key,
                              style: const TextStyle(fontSize: 12),
                            ));
                      },
                    ).toList(),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
