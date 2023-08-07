import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/firebase_constants.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/failure.dart';
import 'package:reddit_clone/typedefs.dart';

import '../../../models/post.dart';

final postRepositoryProvider = Provider(
  (ref) => PostRepository(
    firestore: ref.watch(fireStoreProvider),
  ),
);

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid addPosts(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(
        e.toString(),
      ));
    }
  }

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
}
