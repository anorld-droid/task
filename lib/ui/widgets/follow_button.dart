import 'package:flutter/material.dart';

/// Created by Patrice Mulindi email(mulindipatrice00@gmail.com) on 31.11.2023.

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color bgColor;
  final Color borderColor;
  final String text;
  final Color textColor;
  final double width;
  final double height;
  const FollowButton(
      {Key? key,
      this.function,
      required this.bgColor,
      required this.borderColor,
      required this.text,
      required this.textColor,
      this.width = 250,
      this.height = 27})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          width: width,
          height: height,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
