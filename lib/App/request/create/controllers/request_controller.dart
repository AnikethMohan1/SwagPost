// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:get/get.dart' hide Response;
import 'package:swag_post/App/request/create/view/widgets/authorization/auth_types/auth_swithcer.dart';
import 'package:swag_post/App/request/create/view/widgets/headers.dart';
import 'package:swag_post/App/request/create/view/widgets/params.dart';
import 'package:swag_post/Constants/common_functions.dart';

enum Method {
  GET(color: Color(0xff87d79d)),
  POST(color: Color(0xfffbe58c)),
  PUT(
    color: Color(0xff81acf0),
  ),
  PATCH(color: Color(0xffbca9dd)),
  DELETE(color: Color(0xffea9e92)),
  HEAD(color: Color(0xff89da9f)),
  OPTIONS(color: Color(0xffbf5c95));

  const Method({required this.color});
  final Color color;
}

class RequestCreateController extends GetxController {
  //////[Global_dio]///
  Dio dio = Dio();
  /////[Paramerters_and_Headers]///////
  RxList<ParameterEntry> parameters = <ParameterEntry>[].obs;
  RxList<HeaderEntry> headersEntries = <HeaderEntry>[].obs;

  ///////////[Api_url_controller]//////
  TextEditingController apiUrlController = TextEditingController();
  ///////[Authorization_Controller]///////
  AuthConfiguration authConfiguration =
      AuthConfiguration(type: AuthType.none, credentials: {});

  TextEditingController apiMethodController =
      TextEditingController(text: 'GET');
  CodeController bodyController = CodeController();
  var apiHeader;

  ////[Api_Loading_Status]///////
  Rxn<RxStatus> apiLoadingStatus = Rxn<RxStatus>(RxStatus.empty());

  ///[Api_Response]/////
  Rxn<Response> apiResponse = Rxn<Response>();

  buildUrlWithParameters() {
    final selectedParams = converListtoMap(
      parameters,
    );
    final uri = Uri.parse(apiUrlController.text);
    final newUri =
        uri.replace(queryParameters: Map.fromEntries(selectedParams));

    apiUrlController.text = newUri.toString();
  }

  buildParametersWithUrl() {
    var url = Uri.parse(apiUrlController.text);
    final selectedParams = url.queryParameters.entries.map<ParameterEntry>(
      (e) {
        return ParameterEntry(
            key: TextEditingController(text: e.key),
            value: TextEditingController(text: e.value),
            isSelected: true);
      },
    ).toList();
    parameters.value = selectedParams;
  }

  buildHeader() {
    apiHeader = converListtoMap(headersEntries);
  }

  bool get _validateApiField => apiUrlController.text.isEmpty;

  doNetworkCall() async {
    apiLoadingStatus.value = RxStatus.loading();
    try {
      var url;

      if (!apiUrlController.text.contains('http')) {
        url = 'http://${apiUrlController.text}';
      } else {
        url = apiUrlController.text;
      }

      if (apiHeader != null) {
        dio.options.headers = apiHeader;
      }
      if (authConfiguration.type != AuthType.none) {
        await AuthService().authenticateRequest(authConfig: authConfiguration);
      }
      debugPrint('header${dio.options.headers}');
      var data;
      if (bodyController.text != '') {
        data = json.decode(bodyController.text.replaceAll('\n', '').trim());
      }
      dio.options.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      var bodyForreq = {
        "url": url,
        "method": apiMethodController.text,
        "headers": dio.options.headers,
        "body": data
      };
      debugPrint('body $bodyForreq');
      Response res =
          await dio.post('http://localhost:8080/proxy', data: bodyForreq);
      debugPrint('status code ${res.statusCode} ');
      apiResponse.value = res;
      apiLoadingStatus.value = RxStatus.success();
      debugPrint('$res');
    } on DioException catch (e) {
      apiLoadingStatus.value = RxStatus.error();
      log('${e.runtimeType}');
      debugPrint('${e.response?.data}');

      debugPrint('${e.response?.statusCode}');
      apiResponse.value = e.response;
      rethrow;
    }
  }
}
