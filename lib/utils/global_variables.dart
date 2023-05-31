import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task/ui/views/dashboard.dart';

/// Created by Patrice Mulindi email(mulindipatrice00@gmail.com) on 31.11.2023.
const webScreenSize = 600;
List<Widget> homeScreenItems = [
  Dashboard(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
