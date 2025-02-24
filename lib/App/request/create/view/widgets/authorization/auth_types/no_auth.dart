import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoAuth extends StatelessWidget {
  const NoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'This request does not use any authorization.',
        style: TextStyle(color: Colors.grey[350]),
      ),
    );
  }
}
