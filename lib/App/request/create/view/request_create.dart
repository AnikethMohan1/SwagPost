import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:swag_post/App/request/create/controllers/request_controller.dart';
import 'package:swag_post/App/request/create/view/widgets/body.dart';
import 'package:swag_post/App/request/create/view/widgets/headers.dart';
import 'package:swag_post/App/request/create/view/widgets/params.dart';
import 'package:swag_post/App/request/create/view/widgets/authorization/authorization.dart';
import 'package:swag_post/App/request/create/view/widgets/response_sheet.dart';
import 'package:swag_post/Constants/attributes.dart';

import 'package:swag_post/Constants/constants.dart';

class CreateRequest extends StatefulWidget {
  const CreateRequest({
    super.key,
    this.controllerId,
  });
  final String? controllerId;

  @override
  State<CreateRequest> createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequest> {
  @override
  void initState() {
    Get.put(RequestCreateController(), tag: widget.controllerId);
    log('id ${Get.parameters}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Get.width * 0.4,
        elevation: 0,
        leading: Padding(
          padding: Constants.leftpadding,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey)),
                child: Icon(
                  Icons.http,
                  color: Colors.cyan[400],
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              const Text(
                'Untitled Request',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        actions: [
          Padding(
            padding: Constants.rightpadding,
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Icon(
                          Icons.save_outlined,
                          color: Colors.white,
                        ),
                        kHSpaceS,
                        Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [const ApiTextField(), kVSpaceS, const RequestProperties()],
      ),
    );
  }
}

class RequestProperties extends StatefulWidget {
  const RequestProperties({
    super.key,
  });

  @override
  State<RequestProperties> createState() => _RequestPropertiesState();
}

class _RequestPropertiesState extends State<RequestProperties> {
  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: Stack(
        children: [
          DefaultTabController(
              length: 4,
              animationDuration: Duration(milliseconds: 100),
              child: Scaffold(
                appBar: TabBar(
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      child: Text(
                        'Params',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Authorization',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Headers',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Body',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                  indicatorColor: Color(0xffe8477b),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                body: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [Parameters(), RequestAuth(), Headers(), Body()]),
              )),
          ResponseSheet()
        ],
      ),
    );
  }
}

class ApiTextField extends StatefulWidget {
  const ApiTextField({
    super.key,
  });

  @override
  State<ApiTextField> createState() => _ApiTextFieldState();
}

class _ApiTextFieldState extends State<ApiTextField> {
  bool _clickedMethodtype = false;
  bool _clickedApiTextField = false;
  Color _labelColor = Color(0xff87d79d);
  final formKey = GlobalKey<FormState>();

  final _sc = Get.find<RequestCreateController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: Constants.rightLeftPadding,
          child: Row(
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5)),
                          border: Border(
                              left: BorderSide(
                                  width: _clickedMethodtype ? 2 : 1,
                                  color: _clickedMethodtype
                                      ? Colors.blue[600]!
                                      : Colors.grey),
                              right: BorderSide(
                                  width: _clickedMethodtype ? 2 : 1,
                                  color: _clickedMethodtype
                                      ? Colors.blue[600]!
                                      : Colors.grey),
                              top: BorderSide(
                                  width: _clickedMethodtype ? 2 : 1,
                                  color: _clickedMethodtype
                                      ? Colors.blue[600]!
                                      : Colors.grey),
                              bottom: BorderSide(
                                  width: _clickedMethodtype ? 2 : 1,
                                  color: _clickedMethodtype
                                      ? Colors.blue[600]!
                                      : Colors.grey)),
                        ),
                        child: InkWell(
                          onTap: () {
                            _clickedMethodtype = true;
                            _clickedApiTextField = false;
                            setState(() {});
                          },
                          child: DropdownMenu(
                              controller: _sc.apiMethodController,
                              textStyle: TextStyle(color: _labelColor),
                              menuStyle: const MenuStyle(
                                shadowColor:
                                    WidgetStatePropertyAll(Colors.grey),
                                backgroundColor: WidgetStatePropertyAll(
                                  Constants.scaffoldBackground,
                                ),
                              ),
                              onSelected: (value) {
                                _clickedMethodtype = true;
                                _clickedApiTextField = false;
                                _labelColor =
                                    Method.values.byName(value!).color;
                                setState(() {});
                              },
                              trailingIcon:
                                  const Icon(CupertinoIcons.chevron_down),
                              inputDecorationTheme: const InputDecorationTheme(
                                  isDense: true, border: InputBorder.none),
                              dropdownMenuEntries: Method.values.map(
                                (e) {
                                  return DropdownMenuEntry(
                                      value: e.name,
                                      label: e.name,
                                      labelWidget: Text(
                                        e.name,
                                        style: TextStyle(color: e.color),
                                      ),
                                      style: const ButtonStyle(
                                        textStyle: WidgetStatePropertyAll(
                                            TextStyle(color: Colors.white)),
                                        alignment: Alignment.topCenter,
                                      ));
                                },
                              ).toList()),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _clickedMethodtype = false;
                      _clickedApiTextField = true;
                      setState(() {});
                    },
                    child: Container(
                      height: 40,
                      width: constraints.maxWidth >= 700
                          ? constraints.maxWidth * 0.72
                          : constraints.maxWidth * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                        border: Border(
                            left: BorderSide(
                                width: _clickedApiTextField ? 3 : 1,
                                color: _clickedApiTextField
                                    ? Colors.blue[600]!
                                    : Colors.grey),
                            right: BorderSide(
                                width: _clickedApiTextField ? 3 : 1,
                                color: _clickedApiTextField
                                    ? Colors.blue[600]!
                                    : Colors.grey),
                            top: BorderSide(
                                width: _clickedApiTextField ? 3 : 1,
                                color: _clickedApiTextField
                                    ? Colors.blue[600]!
                                    : Colors.grey),
                            bottom: BorderSide(
                                width: _clickedApiTextField ? 3 : 1,
                                color: _clickedApiTextField
                                    ? Colors.blue[600]!
                                    : Colors.grey)),
                      ),
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              // Returning non-null string shows error
                              return '';
                            }
                            // Returning null means no error
                            return null;
                          },
                          controller: _sc.apiUrlController,
                          onChanged: (value) {
                            _sc.buildParametersWithUrl();
                          },
                          cursorColor: Colors.white,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                          decoration: const InputDecoration(
                              errorStyle: TextStyle(height: 0),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color: Constants.buttonColor, width: 4)),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 20, bottom: 10)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              kHSpaceM,
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _sc.doNetworkCall();
                    }
                  },
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor: WidgetStateColor.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.hovered)) {
                            return const Color.fromARGB(255, 30, 71, 148);
                          }
                          return Constants.buttonColor;
                        },
                      )),
                  child: const Text(
                    'Send',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
