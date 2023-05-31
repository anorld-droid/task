import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task/domain/use_cases/user_model.dart';
import 'package:task/models/user.dart';

/// Created by Patrice Mulindi email(mulindipatrice00@gmail.com) on 31.11.2023.

class UserProvider with ChangeNotifier {
  TaskUser? _user;
  TaskUser get getUser => _user!;
  final UserUseCase _userUseCase = UserUseCase();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> refreshUser() async {
    TaskUser? user = await _userUseCase.get(_auth.currentUser!.uid);
    _user = user;
    notifyListeners();
  }
}
