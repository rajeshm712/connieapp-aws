import 'package:flutter/material.dart';

class InfoBottomGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 67.2,
          height: 16.8,
          child: Image.asset("assets/images/group_17.png"),
        ),
        SizedBox(
          width: 30,
        ),
        SizedBox(
          width: 88,
          height: 16.8,
          child: Image.asset("assets/images/group_18.png"),
        ),
        SizedBox(
          width: 35,
        ),
        SizedBox(
          width: 56,
          height: 16.8,
          child: Image.asset("assets/images/group_19.png"),
        ),
        SizedBox(
          width: 38,
        ),
        SizedBox(
          width: 84.7,
          height: 16.8,
          child: Image.asset("assets/images/group_20.png"),
        ),
      ],
    );
  }
}
