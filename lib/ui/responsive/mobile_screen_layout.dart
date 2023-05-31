import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task/ui/views/dashboard.dart';

/// Created by Patrice Mulindi email(mulindipatrice00@gmail.com) on 31.11.2023.

class MobileScreenLayout extends StatefulWidget {
  final Widget? screen;
  const MobileScreenLayout({Key? key, this.screen}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Dashboard(uid: FirebaseAuth.instance.currentUser!.uid),
    );
  }
}
