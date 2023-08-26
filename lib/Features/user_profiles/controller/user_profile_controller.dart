import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/Features/user_profiles/repositories/user_profile_repository.dart';
import 'package:reddit_clone/core/enums/enums.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final getUserPostsProvider = StreamProvider.family((ref, String uid) =>
    ref.read(userProfileControllerProvider.notifier).getUserPosts(uid));

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepo;
  final StorageRepository _storageRepository;
  final Ref _ref;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _userProfileRepo = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void editCommunity(
      {required File? profileFile,
      required File? bannerFile,
      required BuildContext context,
      required String name}) async {
    UserModel user = _ref.read(userProvider)!;

    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profileFile,
      );

      res.fold(
          (l) => showSnackBar(context, l.errorMessage),
          (r) => user = user.copyWith(
                profilePic: r,
              ));
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/banner',
        id: user.uid,
        file: bannerFile,
      );

      res.fold(
          (l) => showSnackBar(context, l.errorMessage),
          (r) => user = user.copyWith(
                banner: r,
              ));
    }

    user = user.copyWith(
      name: name,
    );
    final result = await _userProfileRepo.editCommunity(user);
    state = false;
    result.fold((l) => showSnackBar(context, l.errorMessage), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepo.getUserPosts(uid);
  }

  void updateUserKarma(UserKarma userKarma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + userKarma.karma);

    final res = await _userProfileRepo.updateUserKarma(user);
    res.fold(
      (l) => null,
      (r) => _ref.read(userProvider.notifier).update((state) => user),
    );
  }
}
