import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task/utils/constants.dart';

/// Created by Patrice Mulindi email(mulindipatrice00@gmail.com) on 31.11.2023.
class TaskUser {
  final String email;
  final String uid;
  final String name;
  final String mobile;
  final String gender;
  final String dob;

  const TaskUser({
    required this.email,
    required this.uid,
    required this.mobile,
    required this.name,
    required this.dob,
    required this.gender,
  });

  Map<String, dynamic> toFirestore() => {
        Constants.name: name,
        Constants.uid: uid,
        Constants.email: email,
        Constants.mobile: mobile,
        Constants.gender: gender,
        Constants.dob: dob,
      };

  factory TaskUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
    SnapshotOptions? options,
  ) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return TaskUser(
      email: snapshot[Constants.email],
      uid: snapshot[Constants.uid],
      mobile: snapshot[Constants.mobile],
      name: snapshot[Constants.name],
      gender: snapshot[Constants.gender],
      dob: snapshot[Constants.dob],
    );
  }
}
