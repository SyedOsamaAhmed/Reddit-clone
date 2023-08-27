import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/Features/posts/repository/post_repository.dart';
import 'package:reddit_clone/Features/user_profiles/controller/user_profile_controller.dart';
import 'package:reddit_clone/core/enums/enums.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/models/comments_model.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
    postRepository: postRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final userPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final getPostsbyIdProvider = StreamProvider.family((ref, String postId) {
  final postCotroller = ref.watch(postControllerProvider.notifier);
  return postCotroller.getPostsById(postId);
});
final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postCotroller = ref.watch(postControllerProvider.notifier);
  return postCotroller.getPostComments(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  PostController({
    required PostRepository postRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;
    final post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentcount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      award: [],
      description: description,
    );

    final res = await _postRepository.addPosts(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);
    state = false;
    res.fold((l) => showSnackBar(context, l.errorMessage), (r) {
      showSnackBar(context, 'Posted Successfully!');
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;
    final post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentcount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      award: [],
      link: link,
    );

    final res = await _postRepository.addPosts(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);
    state = false;
    res.fold((l) => showSnackBar(context, l.errorMessage), (r) {
      showSnackBar(context, 'Posted Successfully!');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
      path: 'posts/${selectedCommunity.name}',
      id: postId,
      file: file,
    );

    imageRes.fold((l) => showSnackBar(context, l.errorMessage), (r) async {
      final post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentcount: 0,
        username: user.name,
        uid: user.uid,
        type: 'image',
        createdAt: DateTime.now(),
        award: [],
        link: r,
      );

      final res = await _postRepository.addPosts(post);
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.imagePost);
      state = false;
      res.fold((l) => showSnackBar(context, l.errorMessage), (r) {
        showSnackBar(context, 'Posted Successfully!');
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);
    res.fold((l) => null,
        (r) => showSnackBar(context, 'Post deleted successfully!'));
  }

  void upvotes(Post post) async {
    final userId = _ref.read(userProvider)!.uid;
    _postRepository.upvotes(post, userId);
  }

  void downvotes(Post post) async {
    final userId = _ref.read(userProvider)!.uid;
    _postRepository.downvotes(post, userId);
  }

  Stream<Post> getPostsById(String postId) {
    return _postRepository.getPostsById(postId);
  }

  void addComments(
      {required BuildContext context,
      required String text,
      required Post post}) async {
    final user = _ref.read(userProvider);
    String commentId = const Uuid().v4();
    Comment comment = Comment(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      username: user!.name,
      profilePic: user.profilePic,
    );
    final res = await _postRepository.addComments(comment);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);
    res.fold((l) => showSnackBar(context, l.errorMessage), (r) => null);
  }

  void awardPost({
    required Post post,
    required String award,
    required BuildContext context,
  }) async {
    final user = _ref.read(userProvider)!;

    final res = await _postRepository.awardPost(post, award, user.uid);

    res.fold((l) => showSnackBar(context, l.errorMessage), (r) {
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.awardPost);
      _ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });

      Routemaster.of(context).pop();
    });
  }

  Stream<List<Comment>> getPostComments(String postId) {
    return _postRepository.getPostComments(postId);
  }
}
