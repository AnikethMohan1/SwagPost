import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swag_post/App/request/create/controllers/request_controller.dart';
import 'package:swag_post/Constants/constants.dart';

class BearToken extends StatefulWidget {
  const BearToken({super.key});

  @override
  State<BearToken> createState() => _BearTokenState();
}

TextEditingController bearerToken = TextEditingController();

class _BearTokenState extends State<BearToken> {
  final _sc = Get.find<RequestCreateController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: Get.width * 0.1, top: 40, left: Get.width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              'Token',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: Get.width * 0.2,
            child: TextField(
              controller: bearerToken,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              onChanged: (value) {
                _sc.authConfiguration.credentials['token'] = bearerToken.text;
              },
              decoration: const InputDecoration(
                  hintText: 'Token',
                  hintStyle:
                      TextStyle(color: Constants.borderColorGrey, fontSize: 12),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.borderColorGrey)),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Constants.borderColorGrey))),
            ),
          ),
        ],
      ),
    );
  }
}
