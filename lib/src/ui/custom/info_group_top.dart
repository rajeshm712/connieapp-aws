import 'package:flutter/material.dart';

class InfoGroupTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 25.6,
          height: 16.8,
          child: Image.asset("assets/images/group_21.png"),
        ),
        SizedBox(
          width: 80,
        ),
        SizedBox(
          width: 28.8,
          height: 16.8,
          child: Image.asset("assets/images/group_22.png"),
        ),
        SizedBox(
          width: 80,
        ),
        SizedBox(
          width: 27.2,
          height: 16.8,
          child: Image.asset("assets/images/group_23.png"),
        ),
        SizedBox(
          width: 100,
        ),
        SizedBox(
          width: 48,
          height: 16.8,
          child: Image.asset("assets/images/group_24.png"),
        ),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
