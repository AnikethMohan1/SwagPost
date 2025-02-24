import 'package:get/get.dart';
import 'package:swag_post/App/request/create/view/widgets/headers.dart';
import 'package:swag_post/App/request/create/view/widgets/params.dart';

converListtoMap(
  parameters,
) {
  if (parameters.runtimeType == RxList<ParameterEntry>) {
    parameters as RxList<ParameterEntry>;
    final selectedParams = parameters
        .where((param) =>
            param.isSelected &&
            param.key.text.trim().isNotEmpty &&
            param.value.text.trim().isNotEmpty)
        .map(
            (param) => MapEntry(param.key.text.trim(), param.value.text.trim()))
        .toList();
    return selectedParams;
  } else if (parameters.runtimeType == RxList<HeaderEntry>) {
    parameters as List<HeaderEntry>;
    final selectedParams = parameters
        .where((param) =>
            param.isSelected &&
            param.key.text.trim().isNotEmpty &&
            param.value.text.trim().isNotEmpty)
        .map(
            (param) => MapEntry(param.key.text.trim(), param.value.text.trim()))
        .toList();
    var map = Map.fromEntries(selectedParams);
    return map;
  }
}
