import 'package:flutter/material.dart';

/// Created by Patrice Mulindi email(mulindipatrice00@gmail.com) on 31.11.2023.

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
