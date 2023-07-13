import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/Features/community/repository/community_repository.dart';

import 'package:reddit_clone/core/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

final userCommunityProvider = StreamProvider((ref) {
  final userController = ref.watch(communityControllerProvider.notifier);
  return userController.getUserCommunities();
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  return CommunityController(
    communityRepository: communityRepository,
    ref: ref,
  );
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;

  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
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

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;

    return _communityRepository.getUserCommunities(uid);
  }
}
