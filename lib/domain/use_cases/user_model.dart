import 'package:task/models/user.dart';
import 'package:task/domain/firebase/cloud_methods.dart';
import 'package:task/utils/constants.dart';

/// Created by Patrice Mulindi email(mulindipatrice00@gmail.com) on 31.11.2023.
class UserUseCase {
  final CloudMethods _cloudMethods = CloudMethods();

  Future<void> upload(String doc, TaskUser user) async {
    await _cloudMethods.setDoc<TaskUser>(
      collection: Constants.users,
      doc: doc,
      file: user,
      fromFirestore: TaskUser.fromFirestore,
      toFirestore: (TaskUser user, _) => user.toFirestore(),
    );
  }

  /// Get the file to the specified path
  /// NOTE: doc should be user id
  Future<TaskUser?> get(String doc) async {
    final snap = await _cloudMethods.getDoc<TaskUser>(
      collection: Constants.users,
      doc: doc,
      fromFirestore: TaskUser.fromFirestore,
      toFirestore: (TaskUser user, _) => user.toFirestore(),
    );
    return snap.data();
  }
}
