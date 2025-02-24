import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swag_post/App/request/create/controllers/request_controller.dart';
import 'package:swag_post/App/request/create/view/widgets/authorization/auth_types/api_key_auth.dart';
import 'package:swag_post/App/request/create/view/widgets/authorization/auth_types/auth_swithcer.dart';
import 'package:swag_post/App/request/create/view/widgets/authorization/auth_types/basic_auth.dart';
import 'package:swag_post/App/request/create/view/widgets/authorization/auth_types/bear_token.dart';
import 'package:swag_post/App/request/create/view/widgets/authorization/auth_types/no_auth.dart';
import 'package:swag_post/Constants/attributes.dart';
import 'package:swag_post/Constants/constants.dart';

class RequestAuth extends StatefulWidget {
  const RequestAuth({super.key});

  @override
  State<RequestAuth> createState() => _RequestAuthState();
}

int selectedAuthIndex = 0;
final authTypeController = TextEditingController(text: 'No Auth');

class _RequestAuthState extends State<RequestAuth> {
  List<Widget> authTypeWidget = const [
    NoAuth(),
    BasicAuth(),
    BearToken(),
    ApiKey(),
    BearToken()
  ];

  PageController _pageController = PageController();
  final _sc = Get.find<RequestCreateController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xff6b6b6b)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  'Auth Type',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                width: Get.width * 0.3,
                padding: EdgeInsets.only(left: 10, top: 10),
                child: DropdownMenu(
                    controller: authTypeController,
                    inputDecorationTheme: InputDecorationTheme(
                        border: MaterialStateOutlineInputBorder.resolveWith(
                      (states) {
                        if (states.contains(WidgetState.focused)) {
                          return const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants.buttonColor, width: 3));
                        }
                        if (states.contains(WidgetState.hovered)) {
                          return const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.white,
                          ));
                        }
                        return const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff6b6b6b)));
                      },
                    )),
                    onSelected: (value) {
                      int index = AuthType.values.indexWhere(
                        (element) => element == value,
                      );

                      selectedAuthIndex = index;
                      _sc.authConfiguration.type = value;
                      setState(() {});
                    },
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 12),
                    menuStyle: const MenuStyle(
                      shadowColor: WidgetStatePropertyAll(Colors.grey),
                      backgroundColor: WidgetStatePropertyAll(
                        Constants.scaffoldBackground,
                      ),
                    ),
                    dropdownMenuEntries: AuthType.values.map(
                      (e) {
                        return DropdownMenuEntry(
                          value: e,
                          label: e.name,
                          labelWidget: Text(
                            e.name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        );
                      },
                    ).toList()),
              ),
              kVSpaceM,
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 20),
                child: Text(
                  'The authorization header will be automatically generated when you send the request',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
          const VerticalDivider(
            color: Color(0xff6b6b6b),
          ),
          Flexible(
            child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              pageSnapping: false,
              itemCount: authTypeWidget.length,
              controller: _pageController,
              itemBuilder: (context, index) {
                return authTypeWidget[selectedAuthIndex];
              },
            ),
          )
        ],
      ),
    );
  }
}
