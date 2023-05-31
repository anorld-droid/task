import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task/ui/views/dashboard.dart';

import 'package:task/utils/colors.dart';
import 'package:task/utils/constants.dart';

class WebScreenLayout extends StatefulWidget {
  final Widget? screen;
  const WebScreenLayout({Key? key, this.screen}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: Text(
          Constants.appName,
        ),
      ),
      body: Dashboard(uid: FirebaseAuth.instance.currentUser!.uid),
    );
  }
}
