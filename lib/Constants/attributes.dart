import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double kValueS = 4;
const double kValueSp = 5;
const double kValueM = 10;
const double kValueL = 20;
const double kValueXL = 50;
const double kValueXXL = 100;
///////////////[Vertical.Space]////////////////
Widget get kVSpaceS => const SizedBox(height: kIsWeb ? kValueS : kValueS);

Widget get kVSpaceSp => const SizedBox(height: kIsWeb ? kValueSp : kValueSp);

Widget get kVSpaceM => const SizedBox(height: kIsWeb ? kValueL : kValueM);

Widget get kVSpaceL => const SizedBox(height: kIsWeb ? kValueL : kValueL);

Widget get kVSpaceXL => const SizedBox(height: kIsWeb ? kValueXL : kValueXL);

Widget get kVSpaceXXL => const SizedBox(height: kIsWeb ? kValueXXL : kValueXXL);

///////////////[Horizontal.Space]////////////////
Widget get kHSpaceS => const SizedBox(width: kIsWeb ? kValueS : kValueS);

Widget get kHSpaceSp => const SizedBox(width: kIsWeb ? kValueSp : kValueSp);

Widget get kHSpaceM => const SizedBox(width: kIsWeb ? kValueL : kValueL);

Widget get kHSpaceL => const SizedBox(width: kIsWeb ? kValueL : kValueL);

Widget get kHSpaceXL => const SizedBox(width: kIsWeb ? kValueXL : kValueXL);

Widget get kHSpaceXXL => const SizedBox(width: kIsWeb ? kValueXXL : kValueXXL);

///////////////[BorderRadius.Space]////////////////
BorderRadius get kBorderRadiusCircularS => BorderRadius.circular(kValueS);

BorderRadius get kBorderRadiusCircularM => BorderRadius.circular(kValueM);

BorderRadius get kBorderRadiusCircularL => BorderRadius.circular(kValueL);

BorderRadius get kBorderRadiusCircularXL => BorderRadius.circular(kValueXL);

BorderRadius get kBorderRadiusCircularXXL => BorderRadius.circular(kValueXXL);
