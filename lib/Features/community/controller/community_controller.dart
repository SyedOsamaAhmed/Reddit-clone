import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/Features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/Features/community/repository/community_repository.dart';

import 'package:reddit_clone/core/constants.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/failure.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/models/post.dart';
import 'package:routemaster/routemaster.dart';

final userCommunityProvider = StreamProvider.autoDispose((ref) {
  final userController = ref.watch(communityControllerProvider.notifier);
  return userController.getUserCommunities();
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
    communityRepository: communityRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});
//Since we have to extract name for the community from the stream so we use .family with provider to get name
final getCommunityNameProvider =
    StreamProvider.family.autoDispose((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});
//search community provider:
final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});
// show posts on user profile screen:
final communityPostsProvider = StreamProvider.family((ref, String name) {
  final postController = ref.watch(communityControllerProvider.notifier);
  return postController.getCommunityPosts(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  CommunityController({
    required CommunityRepository communityRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state =
        true; //for loading purpose class is extended with stateNotifier and we use state variable.
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.addComunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.errorMessage), (r) {
      showSnackBar(context, 'Community created successfully');
      Routemaster.of(context).pop();
    });
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;
    final Either<Failure, void> res;

    if (community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }

    res.fold((l) => showSnackBar(context, l.errorMessage), (r) {
      if (community.members.contains(user.uid)) {
        showSnackBar(context, 'You have successfully leave a community!');
      } else {
        showSnackBar(context, 'You have successfully joined a community!');
      }
    });
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;

    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity({
    required Community community,
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );

      res.fold(
          (l) => showSnackBar(context, l.errorMessage),
          (r) => community = community.copyWith(
                avatar: r,
              ));
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );

      res.fold(
          (l) => showSnackBar(context, l.errorMessage),
          (r) => community = community.copyWith(
                banner: r,
              ));
    }
    final result = await _communityRepository.editCommunity(community);
    state = false;
    result.fold(
      (l) => showSnackBar(context, l.errorMessage),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void addMods(
      String communityName, List<String> uids, BuildContext context) async {
    final res = await _communityRepository.addMods(communityName, uids);
    res.fold(
      (l) => showSnackBar(context, l.errorMessage),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _communityRepository.getCommunityPosts(name);
  }
}
