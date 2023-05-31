import 'package:cloud_firestore/cloud_firestore.dart';

/// Created by Patrice Mulindi email(mulindipatrice00@gmail.com) on 31.11.2023.
class CloudMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Upload the file to the specified path
  /// NOTE: doc should be user id
  Future<void> setDoc<R>(
      {required String collection,
      required String doc,
      required R file,
      required R Function(
              DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
          fromFirestore,
      required Map<String, Object?> Function(R, SetOptions?)
          toFirestore}) async {
    await _firestore
        .collection(collection)
        .doc(doc)
        .withConverter(fromFirestore: fromFirestore, toFirestore: toFirestore)
        .set(file);
  }

  /// Get the file to the specified path
  /// NOTE: doc should be user id
  Future<DocumentSnapshot<R>> getDoc<R>(
      {required String collection,
      required String doc,
      required R Function(
              DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?)
          fromFirestore,
      required Map<String, Object?> Function(R, SetOptions?)
          toFirestore}) async {
    return _firestore
        .collection(collection)
        .doc(doc)
        .withConverter(fromFirestore: fromFirestore, toFirestore: toFirestore)
        .get();
  }
}
