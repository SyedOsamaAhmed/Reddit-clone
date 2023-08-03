import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/failure.dart';
import 'package:reddit_clone/models/user_model.dart';

import '../../../core/firebase_constants.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../../typedefs.dart';

final userProfileRepositoryProvider = Provider(
  (ref) => UserProfileRepository(
    firestore: ref.watch(fireStoreProvider),
  ),
);

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  FutureVoid editCommunity(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(
        e.toString(),
      ));
    }
  }

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
}
